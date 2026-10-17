import 'package:doctor_hunt/shared/generated/image_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashBackgroundGlow extends StatelessWidget {
  const SplashBackgroundGlow({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Glow Top-Left
        Positioned(
          top: -40.h,
          left: -80.w,
          child: IgnorePointer(
            child: Image.asset(
              ImageAssets.bgEllipseTop,
              width: 216.w,
              height: 216.h,
              fit: BoxFit.contain,
            ),
          ),
        ),
        // Background Glow Bottom-Right
        Positioned(
          bottom: -50.h,
          right: -60.w,
          child: IgnorePointer(
            child: Image.asset(
              ImageAssets.bgEllipseBottom,
              width: 250.w,
              height: 250.h,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }
}
