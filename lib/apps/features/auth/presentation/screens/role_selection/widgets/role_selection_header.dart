import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';
import 'package:doctor_hunt/i18n/strings.g.dart';

class RoleSelectionHeader extends StatelessWidget {
  const RoleSelectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 40.h),
        // App Logo
        Center(
          child: Image.asset(
            'assets/images/logos/splash_logo.png', // Assuming this holds the Doctor Hunt logo based on the provided design
            height: 100.h,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: 48.h),
        Text(
          t.auth.chooseRole,
          style: context.bold.copyWith(
            color: palette.textMain,
            fontSize: 24.sp,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12.h),
        Text(
          t.auth.roleSubtitle,
          style: context.regular.copyWith(
            color: palette.textSub,
            fontSize: 14.sp,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
