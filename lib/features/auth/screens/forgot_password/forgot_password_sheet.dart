import 'package:doctor_hunt/core/di/injector.dart';
import 'package:doctor_hunt/core/utils/error_mapper.dart';
import 'package:doctor_hunt/features/auth/cubit/forgot_password_cubit.dart';
import 'package:doctor_hunt/features/auth/cubit/forgot_password_state.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/forgot_password_email_step.dart';
import 'widgets/forgot_password_otp_step.dart';
import 'widgets/forgot_password_reset_step.dart';

class ForgotPasswordSheet extends StatelessWidget {
  const ForgotPasswordSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0x990C0B0A),
      builder: (_) => BlocProvider(
        create: (_) => sl<ForgotPasswordCubit>(),
        child: const ForgotPasswordSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          final msg = getErrorMessage(state.errorMessage!);
          if (msg.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(msg),
                backgroundColor: palette.danger,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }

        if (state.isSuccess) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(t.auth.passwordResetSuccess),
              backgroundColor: palette.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<ForgotPasswordCubit>();

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: switch (state.step) {
            ForgotPasswordStep.email => ForgotPasswordEmailStep(
                key: const ValueKey('email_step'),
                initialEmail: state.email,
                isLoading: state.isLoading,
                onContinue: (email) => cubit.sendOtp(email),
              ),
            ForgotPasswordStep.otp => ForgotPasswordOtpStep(
                key: const ValueKey('otp_step'),
                isLoading: state.isLoading,
                errorMessage: state.errorMessage,
                onContinue: (otp) => cubit.verifyOtp(otp),
                onResend: () => cubit.resendOtp(),
                onClearError: () => cubit.clearError(),
              ),
            ForgotPasswordStep.resetPassword => ForgotPasswordResetStep(
                key: const ValueKey('reset_step'),
                isLoading: state.isLoading,
                onUpdatePassword: (password) => cubit.updatePassword(password),
              ),
          },
        );
      },
    );
  }
}
