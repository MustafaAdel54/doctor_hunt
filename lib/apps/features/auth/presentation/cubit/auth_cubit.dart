import 'package:doctor_hunt/apps/core/error/failures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/auth_repo.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required this.repo}) : super(const AuthState.initial());

  final AuthRepo repo;

  Future<void> loginWithEmail(String email, String password) async {
    emit(const AuthState.loading());
    final result = await repo.loginWithEmail(email, password);
    result.fold(
      (failure) {
        if (!isClosed) emit(AuthState.error(_mapFailureToMessage(failure)));
      },
      (user) {
        if (!isClosed) emit(const AuthState.success());
      },
    );
  }

  /// Creates the Firebase Auth account only (no Firestore profile).
  /// After success, [SessionService] emits [authenticatedWithoutProfile]
  /// and GoRouter redirects to Role Selection automatically.
  Future<void> registerWithEmailOnly(
    String email,
    String password,
    String name,
  ) async {
    emit(const AuthState.loading());
    final result = await repo.registerWithEmailOnly(email, password, name);
    result.fold(
      (failure) {
        if (!isClosed) emit(AuthState.error(_mapFailureToMessage(failure)));
      },
      (_) {
        // Firebase Auth user created. SessionService detects no Firestore
        // profile and emits authenticatedWithoutProfile → Role Selection.
        if (!isClosed) emit(const AuthState.success());
      },
    );
  }

  bool _isCreatingProfile = false;

  /// Creates the Firestore application profile after role selection.
  /// Used for both email-registered and Google Sign-In users.
  Future<void> createUserProfile({
    required String uid,
    required String email,
    required String role,
    String? name,
    String? photoUrl,
    String? phone,
    bool isVerified = false,
  }) async {
    if (_isCreatingProfile) return;
    _isCreatingProfile = true;

    try {
      emit(const AuthState.loading());
      final result = await repo.createUserProfile(
        uid: uid,
        email: email,
        role: role,
        name: name,
        photoUrl: photoUrl,
        phone: phone,
        isVerified: isVerified,
      );
      result.fold(
        (failure) {
          if (!isClosed) emit(AuthState.error(_mapFailureToMessage(failure)));
        },
        (user) {
          // Profile created. SessionService Firestore stream fires automatically,
          // transitions to authenticated(role: ...), GoRouter redirects to home.
          if (!isClosed) emit(const AuthState.success());
        },
      );
    } finally {
      _isCreatingProfile = false;
    }
  }

  /// Performs Google OAuth + Firebase sign-in only.
  /// Does NOT create a Firestore profile. Does NOT accept a role.
  Future<void> loginWithGoogle() async {
    emit(const AuthState.loading());
    final result = await repo.loginWithGoogle();
    result.fold(
      (failure) {
        if (!isClosed) emit(AuthState.error(_mapFailureToMessage(failure)));
      },
      (_) {
        if (!isClosed) emit(const AuthState.success());
      },
    );
  }

  Future<void> resetPassword(String email) async {
    emit(const AuthState.loading());
    final result = await repo.resetPassword(email);
    result.fold(
      (failure) {
        if (!isClosed) emit(AuthState.error(_mapFailureToMessage(failure)));
      },
      (_) {
        if (!isClosed) emit(const AuthState.success());
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is AuthFailure) return failure.code;
    if (failure is NetworkFailure) return 'No internet connection';
    if (failure is ServerFailure) return 'Server error';
    return 'An unexpected error occurred';
  }
}
