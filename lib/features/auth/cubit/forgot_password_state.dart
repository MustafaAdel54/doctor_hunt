import 'package:equatable/equatable.dart';

enum ForgotPasswordStep {
  email,
  otp,
  resetPassword,
}

class ForgotPasswordState extends Equatable {
  const ForgotPasswordState({
    this.step = ForgotPasswordStep.email,
    this.email = '',
    this.otp = '',
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  final ForgotPasswordStep step;
  final String email;
  final String otp;
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  ForgotPasswordState copyWith({
    ForgotPasswordStep? step,
    String? email,
    String? otp,
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
    bool clearError = false,
  }) {
    return ForgotPasswordState(
      step: step ?? this.step,
      email: email ?? this.email,
      otp: otp ?? this.otp,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [
        step,
        email,
        otp,
        isLoading,
        errorMessage,
        isSuccess,
      ];
}
