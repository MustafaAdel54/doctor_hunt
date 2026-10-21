import 'dart:async';

import 'package:doctor_hunt/core/constants/supabase_constants.dart';
import 'package:doctor_hunt/shared/utils/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'session_state.dart';

class SessionService extends ChangeNotifier
    implements ValueListenable<SessionState> {
  SessionService({
    required this._supabase,
  }) {
    _init();
  }

  final SupabaseClient _supabase;

  SessionState _state = const SessionState.initial();
  StreamSubscription<AuthState>? _authSub;
  bool _isPasswordRecovery = false;

  bool get isPasswordRecovery => _isPasswordRecovery;
  set isPasswordRecovery(bool value) {
    if (_isPasswordRecovery != value) {
      _isPasswordRecovery = value;
      notifyListeners();
    }
  }

  @override
  SessionState get value => _state;

  User? get currentUser => _supabase.auth.currentUser;
  String? get currentUserId => _supabase.auth.currentUser?.id;

  void _init() {
    _authSub = _supabase.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.passwordRecovery) {
        _isPasswordRecovery = true;
      }
      if (_isPasswordRecovery) {
        Log.d('Password recovery in progress. Suppressing automatic redirect.');
        return;
      }
      _handleAuthChange(data.session?.user);
    });
  }

  bool _isEvaluating = false;
  User? _pendingUser;
  bool _hasPending = false;

  Future<void> _handleAuthChange(User? user) async {
    if (_isPasswordRecovery) return;

    if (user == null) {
      _updateState(const SessionState.unauthenticated());
      _hasPending = false;
      return;
    }

    _pendingUser = user;
    _hasPending = true;

    if (_isEvaluating) return;

    _isEvaluating = true;
    try {
      while (_hasPending) {
        final currentUserToEvaluate = _pendingUser;
        _hasPending = false;

        if (currentUserToEvaluate == null) {
          _updateState(const SessionState.unauthenticated());
          continue;
        }

        for (int attempt = 1; attempt <= 3; attempt++) {
          try {
            final doc = await _supabase
                .from(SbC.profiles)
                .select()
                .eq('id', currentUserToEvaluate.id)
                .maybeSingle();

            if (doc == null) {
              // Supabase user exists but no application profile yet.
              _updateState(
                SessionState.authenticatedWithoutProfile(userId: currentUserToEvaluate.id),
              );
            } else {
              final isActive = doc[SbC.isActive] as bool? ?? true;
              if (!isActive) {
                Log.d('User ${currentUserToEvaluate.id} is deactivated.');
                _updateState(SessionState.authenticatedInactive(userId: currentUserToEvaluate.id));
              } else {
                final role = doc[SbC.role] as String?;
                if (role != null) {
                  _updateState(
                    SessionState.authenticated(userId: currentUserToEvaluate.id, role: role),
                  );
                } else {
                  // Document exists but role field is missing — treat as no profile.
                  _updateState(
                    SessionState.authenticatedWithoutProfile(userId: currentUserToEvaluate.id),
                  );
                }
              }
            }
            break; // Break retry loop on success
          } catch (e) {
            Log.e('Error fetching user profile (attempt $attempt)', e);
            if (attempt == 3) {
              _updateState(
                const SessionState.error('Failed to load profile. Please check your connection.'),
              );
            } else {
              // Short backoff
              await Future.delayed(const Duration(seconds: 1));
            }
          }
        }
      }
    } finally {
      _isEvaluating = false;
    }
  }

  /// Forces a re-evaluation of the session state.
  /// Called manually after creating a profile, since Supabase does not 
  /// stream table changes globally by default.
  Future<void> refreshProfile() async {
    await _handleAuthChange(_supabase.auth.currentUser);
  }

  void _updateState(SessionState newState) {
    if (_state != newState) {
      _state = newState;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }
}
