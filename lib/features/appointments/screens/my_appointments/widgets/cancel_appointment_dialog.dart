import 'package:doctor_hunt/shared/generated/app_colors.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CancelAppointmentDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final bool isCancelling;

  const CancelAppointmentDialog({
    super.key,
    required this.onConfirm,
    this.isCancelling = false,
  });

  static Future<bool?> show(BuildContext context, {required VoidCallback onConfirm}) {
    return showDialog<bool>(
      context: context,
      builder: (_) => CancelAppointmentDialog(onConfirm: onConfirm),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      backgroundColor: palette.surface,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Warning Icon
            Container(
              width: 56.w,
              height: 56.w,
              decoration: const BoxDecoration(
                color: Color(0xFFFFF0F0),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.event_busy_rounded,
                color: const Color(0xFFF15B5D),
                size: 28.sp,
              ),
            ),
            SizedBox(height: 16.h),

            // Title
            Text(
              t.appointments.cancelAppointmentConfirmTitle,
              style: context.bold18TextMain,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),

            // Description
            Text(
              t.appointments.cancelAppointmentConfirmDesc,
              style: context.regular14TextSub.copyWith(
                color: palette.textSub,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 44.h,
                    child: OutlinedButton(
                      onPressed: isCancelling ? null : () => Navigator.of(context).pop(false),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: palette.textSub.withValues(alpha: 0.25),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                      ),
                      child: Text(
                        t.appointments.keepAppointment,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: palette.textMain,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: SizedBox(
                    height: 44.h,
                    child: ElevatedButton(
                      onPressed: isCancelling
                          ? null
                          : () {
                              Navigator.of(context).pop(true);
                              onConfirm();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF15B5D),
                        foregroundColor: FigmaRaw.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                      ),
                      child: isCancelling
                          ? SizedBox(
                              width: 18.w,
                              height: 18.w,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              t.appointments.confirmCancel,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: FigmaRaw.white,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
