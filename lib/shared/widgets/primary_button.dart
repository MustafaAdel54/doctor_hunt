import 'package:doctor_hunt/shared/constants/app_constants.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.isOutline = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final bool isOutline;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    final child = isLoading
        ? SizedBox.square(
            dimension: 24.w,
            child: CircularProgressIndicator(
              strokeWidth: 2.w,
              color: isOutline ? palette.primary : palette.white,
            ),
          )
        : Text(
            text,
            style: isOutline ? context.bold18Primary : context.bold18White,
          );

    final button = isOutline
        ? OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: palette.primary,
              side: BorderSide(color: palette.primary, width: 1.5.w),
              padding: EdgeInsets.symmetric(
                vertical: 16.h,
                horizontal: 24.w,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
            ),
            child: child,
          )
        : ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: palette.primary,
              foregroundColor: palette.white,
              disabledBackgroundColor: palette.primary.withValues(alpha: 0.5),
              padding: EdgeInsets.symmetric(
                vertical: 16.h,
                horizontal: 24.w,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              elevation: 0,
            ),
            child: child,
          );

    if (isFullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }
}
