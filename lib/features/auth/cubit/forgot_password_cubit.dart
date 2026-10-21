import 'package:doctor_hunt/core/error/failures.dart';
import 'package:doctor_hunt/core/session/session_service.dart';
import 'package:doctor_hunt/features/auth/repo/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit({
    required this.repo,
    required this.sessionService,
  }) : super(const ForgotPasswordState());

  final AuthRepo repo;
  final SessionService sessionService;

  Future<void> sendOtp(String email) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    final result = await repo.resetPassword(email.trim());
    result.fold(
      (failure) {
        if (!isClosed) {
          emit(state.copyWith(
            isLoading: false,
            errorMessage: _mapFailureToCode(failure),
          ));
        }
      },
      (_) {
        if (!isClosed) {
          emit(state.copyWith(
            isLoading: false,
            email: email.trim(),
            step: ForgotPasswordStep.otp,
            clearError: true,
          ));
        }
      },
    );
  }

  Future<void> resendOtp() async {
    if (state.email.isEmpty) return;
    emit(state.copyWith(isLoading: true, clearError: true));
    final result = await repo.resetPassword(state.email);
    result.fold(
      (failure) {
        if (!isClosed) {
          emit(state.copyWith(
            isLoading: false,
            errorMessage: _mapFailureToCode(failure),
          ));
        }
      },
      (_) {
        if (!isClosed) {
          emit(state.copyWith(isLoading: false, clearError: true));
        }
      },
    );
  }

  Future<void> verifyOtp(String otp) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    // Set recovery flag BEFORE verifying OTP to suppress any auto-login redirect
    sessionService.isPasswordRecovery = true;
    final result = await repo.verifyOtp(email: state.email, token: otp.trim());
    result.fold(
      (failure) {
        sessionService.isPasswordRecovery = false;
        if (!isClosed) {
          emit(state.copyWith(
            isLoading: false,
            errorMessage: _mapFailureToCode(failure),
          ));
        }
      },
      (_) {
        if (!isClosed) {
          emit(state.copyWith(
            isLoading: false,
            otp: otp.trim(),
            step: ForgotPasswordStep.resetPassword,
            clearError: true,
          ));
        }
      },
    );
  }

  Future<void> updatePassword(String newPassword) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    final result = await repo.updatePassword(newPassword);
    await result.fold(
      (failure) async {
        if (!isClosed) {
          emit(state.copyWith(
            isLoading: false,
            errorMessage: _mapFailureToCode(failure),
          ));
        }
      },
      (_) async {
        await repo.logout();
        sessionService.isPasswordRecovery = false;
        if (!isClosed) {
          emit(state.copyWith(
            isLoading: false,
            isSuccess: true,
            clearError: true,
          ));
        }
      },
    );
  }

  void backToEmail() {
    emit(state.copyWith(
      step: ForgotPasswordStep.email,
      clearError: true,
    ));
  }

  void clearError() {
    emit(state.copyWith(clearError: true));
  }

  @override
  Future<void> close() {
    if (sessionService.isPasswordRecovery) {
      sessionService.isPasswordRecovery = false;
      repo.logout();
    }
    return super.close();
  }

  String _mapFailureToCode(Failure failure) {
    if (failure is AuthFailure) return failure.code;
    if (failure is NetworkFailure) return 'network';
    if (failure is ServerFailure) return 'server';
    return 'unknown';
  }
}
