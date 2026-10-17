import 'package:doctor_hunt/core/di/injector.dart';
import 'package:doctor_hunt/core/utils/error_mapper.dart';
import 'package:doctor_hunt/features/auth/cubit/auth_cubit.dart';
import 'package:doctor_hunt/features/auth/cubit/auth_state.dart';
import 'package:doctor_hunt/features/auth/screens/widgets/auth_background_glow.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/widgets/auth_social_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'widgets/signup_footer.dart';
import 'widgets/signup_form.dart';
import 'widgets/signup_header.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthCubit>(),
      child: const _SignupView(),
    );
  }
}

class _SignupView extends StatelessWidget {
  const _SignupView();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Scaffold(
      backgroundColor: palette.surface,
      body: Stack(
        children: [
          const AuthBackgroundGlow(),
          SafeArea(
            child: BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                state.whenOrNull(
                  error: (code) {
                    if (code == 'cancelled') return;
                    final msg = getErrorMessage(code);
                    if (msg.isEmpty) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(msg), backgroundColor: palette.danger),
                    );
                  },
                );
              },
              builder: (context, state) {
                final isLoading = state.maybeWhen(
                  loading: () => true,
                  orElse: () => false,
                );

                return LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: IntrinsicHeight(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SignupHeader(),
                                SizedBox(height: 36.h),
                                AuthSocialButtons(
                                  isLoading: isLoading,
                                  onGooglePressed: () =>
                                      context.read<AuthCubit>().loginWithGoogle(),
                                  onFacebookPressed: () {},
                                ),
                                SizedBox(height: 32.h),
                                SignupForm(isLoading: isLoading),
                                const Spacer(),
                                const SignupFooter(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
