import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:doctor_hunt/apps/core/di/injector.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';
import '../../cubit/auth_cubit.dart';
import '../../cubit/auth_state.dart';
import 'widgets/login_header.dart';
import 'package:doctor_hunt/apps/core/widgets/auth_social_buttons.dart';
import 'widgets/login_form.dart';
import 'widgets/login_footer.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthCubit>(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView();

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
                        const LoginHeader(),
                        SizedBox(height: 48.h),
                        AuthSocialButtons(
                          isLoading: isLoading,
                          onGooglePressed: () =>
                              context.read<AuthCubit>().loginWithGoogle(),
                          onFacebookPressed:
                              () {}, // Optional feature out of scope
                        ),
                        SizedBox(height: 40.h),
                        LoginForm(isLoading: isLoading),
                        SizedBox(height: 16.h),
                        const LoginFooter(),
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
