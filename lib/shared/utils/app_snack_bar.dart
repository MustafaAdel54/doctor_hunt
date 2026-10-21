import 'package:doctor_hunt/shared/generated/app_colors.dart';
import 'package:doctor_hunt/shared/generated/image_assets.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

abstract final class AppSnackBar {
  /// Displays a floating snackbar from the bottom indicating whether a doctor
  /// was added to or removed from favourites.
  static void showFavorite(
    BuildContext context, {
    required bool isAdded,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 30.w,
              height: 30.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isAdded
                    ? FigmaRaw.red.withValues(alpha: 0.15)
                    : Colors.white.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: isAdded
                  ? SvgPicture.asset(
                      ImageAssets.heartFilled,
                      width: 16.w,
                      height: 14.h,
                    )
                  : SvgPicture.asset(
                      ImageAssets.heartOutline,
                      width: 16.w,
                      height: 14.h,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                isAdded
                    ? t.doctors.addedToFavourites
                    : t.doctors.removedFromFavourites,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  letterSpacing: 0.1,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: FigmaRaw.slate800,
        behavior: SnackBarBehavior.floating,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        duration: const Duration(milliseconds: 1800),
      ),
    );
  }
}
