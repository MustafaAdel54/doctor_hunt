import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:doctor_hunt/apps/core/di/injector.dart';
import 'package:doctor_hunt/apps/core/widgets/auth_social_buttons.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';
import '../../cubit/auth_cubit.dart';
import '../../cubit/auth_state.dart';
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
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          state.whenOrNull(
            error: (msg) {
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

          return SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SignupHeader(),
                        SizedBox(height: 48.h),
                        AuthSocialButtons(
                          isLoading: isLoading,
                          onGooglePressed: () =>
                              context.read<AuthCubit>().loginWithGoogle(),
                          onFacebookPressed: () {},
                        ),
                        SizedBox(height: 40.h),
                        SignupForm(isLoading: isLoading),
                        SizedBox(height: 16.h),
                        const SignupFooter(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
