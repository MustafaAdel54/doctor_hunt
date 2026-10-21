import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthBottomSheetWrapper extends StatelessWidget {
  const AuthBottomSheetWrapper({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30.r),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16.h),
            Center(
              child: Container(
                width: 130.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: palette.textBorders,
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
            ),
            SizedBox(height: 28.h),
            Text(
              title,
              style: context.medium24TextMain,
            ),
            SizedBox(height: 12.h),
            Text(
              subtitle,
              style: context.regular14TextSub.copyWith(
                height: 1.5,
              ),
            ),
            SizedBox(height: 24.h),
            child,
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}
