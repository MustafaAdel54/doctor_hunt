import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/supabase_constants.dart';
import '../utils/logger.dart';
import 'session_state.dart';

class SessionService extends ChangeNotifier
    implements ValueListenable<SessionState> {
  SessionService({
    required SupabaseClient supabase,
  }) : _supabase = supabase {
    _init();
  }

  final SupabaseClient _supabase;

  SessionState _state = const SessionState.initial();
  StreamSubscription<AuthState>? _authSub;

  @override
  SessionState get value => _state;

  void _init() {
    _authSub = _supabase.auth.onAuthStateChange.listen((data) {
      _handleAuthChange(data.session?.user);
    });
  }

  Future<void> _handleAuthChange(User? user) async {
    if (user == null) {
      _updateState(const SessionState.unauthenticated());
      return;
    }

    try {
      final doc = await _supabase
          .from(SbC.profiles)
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (doc == null) {
        // Supabase user exists but no application profile yet.
        _updateState(
          SessionState.authenticatedWithoutProfile(userId: user.id),
        );
        return;
      }

      final isActive = doc[SbC.isActive] as bool? ?? true;
      if (!isActive) {
        Log.d('User ${user.id} is deactivated.');
        _updateState(SessionState.authenticatedInactive(userId: user.id));
        return;
      }

      final role = doc[SbC.role] as String?;
      if (role != null) {
        _updateState(
          SessionState.authenticated(userId: user.id, role: role),
        );
      } else {
        // Document exists but role field is missing — treat as no profile.
        _updateState(
          SessionState.authenticatedWithoutProfile(userId: user.id),
        );
      }
    } catch (e) {
      Log.e('Error fetching user profile', e);
      _updateState(
        SessionState.authenticatedWithoutProfile(userId: user.id),
      );
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
