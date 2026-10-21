import 'package:doctor_hunt/core/router/routes.dart';
import 'package:doctor_hunt/features/appointments/cubit/appointments_state.dart';
import 'package:doctor_hunt/shared/generated/app_colors.dart';
import 'package:doctor_hunt/shared/generated/image_assets.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AppointmentsEmptyState extends StatelessWidget {
  final AppointmentTab tab;

  const AppointmentsEmptyState({
    super.key,
    required this.tab,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    final title = switch (tab) {
      AppointmentTab.upcoming => t.appointments.noUpcomingAppointments,
      AppointmentTab.completed => t.appointments.noCompletedAppointments,
      AppointmentTab.cancelled => t.appointments.noCancelledAppointments,
    };

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              ImageAssets.noSlotsIllustration,
              width: 140.w,
              height: 140.w,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20.h),
            Text(
              title,
              style: context.medium18TextMain,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              t.appointments.noAppointmentsFound,
              style: context.regular14TextSub.copyWith(color: palette.textSub),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            SizedBox(
              height: 44.h,
              child: ElevatedButton(
                onPressed: () {
                  context.pushNamed(Routes.popularDoctors);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: FigmaRaw.green500,
                  foregroundColor: FigmaRaw.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                ),
                child: Text(
                  t.home.popularDoctors,
                  style: TextStyle(
                    fontSize: 14.sp,
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
