import 'package:doctor_hunt/shared/generated/image_assets.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoleSelectionHeader extends StatelessWidget {
  const RoleSelectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 40.h),
        // App Logo
        Center(
          child: Image.asset(
            ImageAssets.splashLogo, // Assuming this holds the Doctor Hunt logo based on the provided design
            height: 100.h,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: 48.h),
        Text(
          t.auth.chooseRole,
          style: context.bold24TextMain,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12.h),
        Text(
          t.auth.roleSubtitle,
          style: context.regular14TextSub.copyWith(height: 1.5),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
