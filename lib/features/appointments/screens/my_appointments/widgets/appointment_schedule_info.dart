import 'package:doctor_hunt/features/appointments/models/appointment_model.dart';
import 'package:doctor_hunt/features/doctors/models/doctor_model.dart';
import 'package:doctor_hunt/shared/generated/image_assets.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class AppointmentScheduleInfo extends StatelessWidget {
  final AppointmentModel appointment;
  final DoctorModel? doctor;

  const AppointmentScheduleInfo({
    super.key,
    required this.appointment,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    final fee = doctor != null
        ? '\$${doctor!.hourlyRate.toStringAsFixed(2)}'
        : '\$28.00';

    final formattedDate =
        DateFormat('dd MMM yyyy').format(appointment.startTime);
    final formattedTime = DateFormat('hh:mm a').format(appointment.startTime);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: AppointmentDetailItem(
                icon: ImageAssets.apptCalendar,
                label: t.appointments.appointmentDate,
                value: formattedDate,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: AppointmentDetailItem(
                icon: ImageAssets.apptClock,
                label: t.appointments.appointmentTime,
                value: formattedTime,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        AppointmentDetailItem(
          icon: ImageAssets.apptFee,
          label: t.appointments.consultationFee,
          value: fee,
        ),
      ],
    );
  }
}

class AppointmentDetailItem extends StatelessWidget {
  final String icon;
  final String label;
  final String value;

  const AppointmentDetailItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Row(
      children: [
        SvgPicture.asset(icon, width: 28.w, height: 28.w),
        SizedBox(width: 6.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 9.sp,
                  color: palette.textSub,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: palette.textMain,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
