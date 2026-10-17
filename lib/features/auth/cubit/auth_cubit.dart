import 'package:doctor_hunt/core/error/failures.dart';
import 'package:doctor_hunt/core/session/session_service.dart';
import 'package:doctor_hunt/features/auth/repo/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required this.repo, required this.sessionService}) : super(const AuthState.initial());

  final AuthRepo repo;
  final SessionService sessionService;

  Future<void> loginWithEmail(String email, String password) async {
    emit(const AuthState.loading());
    final result = await repo.loginWithEmail(email, password);
    result.fold(
      (failure) {
        if (!isClosed) emit(AuthState.error(_mapFailureToCode(failure)));
      },
      (user) {
        if (!isClosed) emit(const AuthState.success());
      },
    );
  }

  /// Creates the Supabase Auth account only (no database profile).
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
        if (!isClosed) emit(AuthState.error(_mapFailureToCode(failure)));
      },
      (_) {
        // Supabase Auth user created. SessionService detects no database
        // profile and emits authenticatedWithoutProfile → Role Selection.
        if (!isClosed) emit(const AuthState.success());
      },
    );
  }


  /// Performs Google OAuth + Supabase sign-in only.
  /// Does NOT create a database profile. Does NOT accept a role.
  Future<void> loginWithGoogle() async {
    emit(const AuthState.loading());
    final result = await repo.loginWithGoogle();
    result.fold(
      (failure) {
        if (!isClosed) emit(AuthState.error(_mapFailureToCode(failure)));
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
        if (!isClosed) emit(AuthState.error(_mapFailureToCode(failure)));
      },
      (_) {
        if (!isClosed) emit(const AuthState.success());
      },
    );
  }

  Future<void> logout() async {
    emit(const AuthState.loading());
    final result = await repo.logout();
    result.fold(
      (failure) {
        if (!isClosed) emit(AuthState.error(_mapFailureToCode(failure)));
      },
      (_) {
        if (!isClosed) emit(const AuthState.initial());
      },
    );
  }

  String _mapFailureToCode(Failure failure) {
    if (failure is AuthFailure) return failure.code;
    if (failure is NetworkFailure) return 'network';
    if (failure is ServerFailure) return 'server';
    return 'unknown';
  }
}
