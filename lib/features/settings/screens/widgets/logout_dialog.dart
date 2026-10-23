import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<bool?> showLogoutConfirmationDialog(BuildContext context) {
  final palette = context.palette;

  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (dialogCtx) => Dialog(
      backgroundColor: palette.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      elevation: 8,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.settings.logoutConfirmTitle,
              style: dialogCtx.bold18TextMain,
            ),
            SizedBox(height: 12.h),
            Text(
              t.settings.logoutConfirmMessage,
              style: dialogCtx.regular14TextSub,
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(dialogCtx).pop(false),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  ),
                  child: Text(
                    t.common.cancel,
                    style: dialogCtx.medium14TextSub,
                  ),
                ),
                SizedBox(width: 8.w),
                ElevatedButton(
                  onPressed: () => Navigator.of(dialogCtx).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: palette.primary,
                    foregroundColor: palette.white,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    t.settings.ok,
                    style: dialogCtx.bold14White,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
