import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../constants/firebase_constants.dart';
import '../utils/logger.dart';
import 'session_state.dart';

class SessionService extends ChangeNotifier
    implements ValueListenable<SessionState> {
  SessionService({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  }) : _auth = auth,
       _firestore = firestore {
    _init();
  }

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  SessionState _state = const SessionState.initial();
  StreamSubscription<User?>? _authSub;
  StreamSubscription<DocumentSnapshot>? _userDocSub;

  @override
  SessionState get value => _state;

  void _init() {
    _authSub = _auth.authStateChanges().listen((user) {
      _userDocSub?.cancel();
      _userDocSub = null;

      if (user == null) {
        _updateState(const SessionState.unauthenticated());
        return;
      }

      // Listen to the Firestore user document for role and active status.
      // This stream fires immediately with the current document state, and
      // again whenever the document is created, updated, or deleted.
      _userDocSub = _firestore
          .collection(FbC.users)
          .doc(user.uid)
          .snapshots()
          .listen(
            (doc) {
              if (!doc.exists) {
                // Firebase user exists but no application profile yet.
                // This is the normal state for a brand-new Google Sign-In user
                // before they complete Role Selection.
                _updateState(
                  SessionState.authenticatedWithoutProfile(userId: user.uid),
                );
                return;
              }

              final data = doc.data();
              if (data == null) {
                _updateState(
                  SessionState.authenticatedWithoutProfile(userId: user.uid),
                );
                return;
              }

              final isActive = data[FbC.isActive] as bool? ?? true;
              if (!isActive) {
                Log.d('User ${user.uid} is deactivated. Signing out.');
                _auth.signOut();
                return;
              }

              final role = data[FbC.role] as String?;
              if (role != null) {
                _updateState(
                  SessionState.authenticated(userId: user.uid, role: role),
                );
              } else {
                // Document exists but role field is missing — treat as no profile.
                _updateState(
                  SessionState.authenticatedWithoutProfile(userId: user.uid),
                );
              }
            },
            onError: (Object e) {
              Log.e('Error listening to user document', e);
            },
          );
    });
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
    _userDocSub?.cancel();
    super.dispose();
  }
}
