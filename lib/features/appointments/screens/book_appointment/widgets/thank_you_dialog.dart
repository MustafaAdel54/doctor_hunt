import 'package:doctor_hunt/core/router/routes.dart';
import 'package:doctor_hunt/features/appointments/cubit/appointments_cubit.dart';
import 'package:doctor_hunt/features/appointments/cubit/appointments_state.dart';
import 'package:doctor_hunt/shared/generated/app_colors.dart';
import 'package:doctor_hunt/shared/generated/image_assets.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class ThankYouDialog extends StatelessWidget {
  final String doctorName;
  final String formattedDate;
  final String formattedTime;

  const ThankYouDialog({
    super.key,
    required this.doctorName,
    required this.formattedDate,
    required this.formattedTime,
  });

  static Future<void> show(
    BuildContext context, {
    required String doctorName,
    required String formattedDate,
    required String formattedTime,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: FigmaRaw.almostBlack.withValues(alpha: 0.65),
      builder: (_) => ThankYouDialog(
        doctorName: doctorName,
        formattedDate: formattedDate,
        formattedTime: formattedTime,
      ),
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
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 28.h, 20.w, 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Thumbs Up Circular Badge
            Image.asset(
              ImageAssets.bookingSuccessThumbsUp,
              width: 140.w,
              height: 140.w,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20.h),

            // "Thank You !" Title
            Text(
              t.appointments.thankYou,
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.w500,
                color: palette.textMain,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),

            // "Your Appointment Successful" Subtitle
            Text(
              t.appointments.appointmentSuccessful,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w400,
                color: palette.textSub,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),

            // Description with dynamic details
            Text(
              t.appointments.bookingSuccessDesc(
                doctor: doctorName,
                date: formattedDate,
                time: formattedTime,
              ),
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: palette.textSub,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),

            // "Done" Button (295.w x 54.h, rounded 6.r)
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (GetIt.instance.isRegistered<AppointmentsCubit>()) {
                    final apptCubit = GetIt.instance<AppointmentsCubit>();
                    apptCubit.switchTab(AppointmentTab.upcoming);
                    apptCubit.refreshAppointments();
                  }
                  context.go(Paths.myAppointments);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: FigmaRaw.green500,
                  foregroundColor: FigmaRaw.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  t.appointments.done,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: FigmaRaw.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
