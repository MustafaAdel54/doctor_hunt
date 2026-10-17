import 'package:doctor_hunt/shared/generated/image_assets.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          ImageAssets.appLogo,
          width: 70.w,
          height: 70.h,
        ),
        SizedBox(height: 16.h),
        Text(
          t.common.appName,
          style: context.bold26TextMain.copyWith(letterSpacing: -0.3),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
