import 'package:doctor_hunt/features/appointments/cubit/appointments_state.dart';
import 'package:doctor_hunt/features/appointments/models/appointment_model.dart';
import 'package:doctor_hunt/features/doctors/models/doctor_model.dart';
import 'package:doctor_hunt/shared/generated/app_colors.dart';
import 'package:doctor_hunt/shared/generated/image_assets.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppointmentDoctorHeader extends StatelessWidget {
  final AppointmentModel appointment;
  final AppointmentTab tab;
  final DoctorModel? doctor;

  const AppointmentDoctorHeader({
    super.key,
    required this.appointment,
    required this.tab,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final locale = Localizations.localeOf(context).languageCode;

    final doctorName = appointment.doctorName[locale] ??
        appointment.doctorName.values.firstOrNull ??
        doctor?.name[locale] ??
        doctor?.name.values.firstOrNull ??
        'Doctor';

    final specialization = doctor?.specialization ?? 'Specialist';

    final isCancelled =
        appointment.status == 'cancelled' || tab == AppointmentTab.cancelled;
    final isCompleted =
        appointment.status == 'completed' || tab == AppointmentTab.completed;

    final badgeBg = isCancelled
        ? const Color(0xFFFFF0F0)
        : const Color(0xFFE8F8F3);
    final badgeColor = isCancelled
        ? const Color(0xFFF15B5D)
        : FigmaRaw.green500;
    final statusText = isCancelled
        ? t.appointments.cancelled
        : isCompleted
            ? t.appointments.completed
            : t.appointments.upcoming;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: Container(
            width: 66.w,
            height: 66.w,
            color: FigmaRaw.green500.withValues(alpha: 0.08),
            child: doctor?.image != null && doctor!.image!.isNotEmpty
                ? Image.asset(doctor!.image!, fit: BoxFit.cover)
                : Image.asset(ImageAssets.popDoctor1, fit: BoxFit.cover),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                doctorName,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: palette.textMain,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4.h),
              Text(
                specialization,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w300,
                  color: palette.textSub,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        SizedBox(width: 6.w),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: badgeBg,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6.w,
                height: 6.w,
                decoration: BoxDecoration(
                  color: badgeColor,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                statusText,
                style: TextStyle(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w500,
                  color: badgeColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
