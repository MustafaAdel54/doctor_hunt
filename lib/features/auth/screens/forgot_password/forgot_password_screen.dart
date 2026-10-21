import 'package:doctor_hunt/core/di/injector.dart';
import 'package:doctor_hunt/features/auth/cubit/forgot_password_cubit.dart';
import 'package:doctor_hunt/features/auth/screens/forgot_password/forgot_password_sheet.dart';
import 'package:doctor_hunt/features/auth/screens/widgets/auth_background_glow.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Scaffold(
      backgroundColor: palette.surface,
      appBar: AppBar(
        backgroundColor: palette.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          const AuthBackgroundGlow(),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: BlocProvider(
                create: (_) => sl<ForgotPasswordCubit>(),
                child: const ForgotPasswordSheet(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
