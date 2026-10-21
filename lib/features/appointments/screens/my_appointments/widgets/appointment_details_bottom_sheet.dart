import 'package:doctor_hunt/features/appointments/models/appointment_model.dart';
import 'package:doctor_hunt/features/doctors/cubit/doctors_cubit.dart';
import 'package:doctor_hunt/shared/generated/app_colors.dart';
import 'package:doctor_hunt/shared/generated/image_assets.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class AppointmentDetailsBottomSheet extends StatelessWidget {
  final AppointmentModel appointment;

  const AppointmentDetailsBottomSheet({
    super.key,
    required this.appointment,
  });

  static Future<void> show(BuildContext context, AppointmentModel appointment) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AppointmentDetailsBottomSheet(appointment: appointment),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final locale = Localizations.localeOf(context).languageCode;
    final doctor = GetIt.instance<DoctorsCubit>().getDoctorById(appointment.doctorId);

    final doctorName = appointment.doctorName[locale] ??
        appointment.doctorName.values.firstOrNull ??
        doctor?.name[locale] ??
        doctor?.name.values.firstOrNull ??
        'Doctor';

    final specialization = doctor?.specialization ?? 'Specialist';
    final fee = doctor != null
        ? '\$${doctor.hourlyRate.toStringAsFixed(2)}'
        : '\$28.00';

    final formattedDate = DateFormat('dd MMM yyyy').format(appointment.startTime);
    final formattedTime = DateFormat('hh:mm a').format(appointment.startTime);

    final isCancelled = appointment.status == 'cancelled';
    final isCompleted = appointment.status == 'completed';

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

    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 28.h),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20.r,
            offset: Offset(0, -4.h),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: palette.textSub.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 18.h),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                t.appointments.appointmentDetailsTitle,
                style: context.bold18TextMain,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(20.r),
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
                    SizedBox(width: 5.w),
                    Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: badgeColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Doctor card section
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: Container(
                  width: 60.w,
                  height: 60.w,
                  color: FigmaRaw.green500.withValues(alpha: 0.08),
                  child: doctor?.image != null && doctor!.image!.isNotEmpty
                      ? Image.asset(doctor.image!, fit: BoxFit.cover)
                      : Image.asset(ImageAssets.popDoctor1, fit: BoxFit.cover),
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctorName,
                      style: context.medium16TextMain,
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
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),
          Divider(color: palette.textBorders, height: 1),
          SizedBox(height: 16.h),

          // Details Rows
          _buildInfoRow(
            icon: ImageAssets.apptCalendar,
            label: t.appointments.appointmentDate,
            value: formattedDate,
            context: context,
          ),
          SizedBox(height: 14.h),
          _buildInfoRow(
            icon: ImageAssets.apptClock,
            label: t.appointments.appointmentTime,
            value: formattedTime,
            context: context,
          ),
          SizedBox(height: 14.h),
          _buildInfoRow(
            icon: ImageAssets.apptFee,
            label: t.appointments.consultationFee,
            value: fee,
            context: context,
          ),

          if (appointment.patientName != null && appointment.patientName!.isNotEmpty) ...[
            SizedBox(height: 14.h),
            _buildTextRow(
              label: t.appointments.patientName,
              value: appointment.patientName!,
              context: context,
            ),
          ],

          if (appointment.notes != null && appointment.notes!.isNotEmpty) ...[
            SizedBox(height: 14.h),
            _buildTextRow(
              label: t.appointments.notes,
              value: appointment.notes!,
              context: context,
            ),
          ],

          SizedBox(height: 24.h),

          // Close button
          SizedBox(
            width: double.infinity,
            height: 46.h,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: FigmaRaw.green500,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.r),
                ),
                elevation: 0,
              ),
              child: Text(
                t.common.ok,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required String icon,
    required String label,
    required String value,
    required BuildContext context,
  }) {
    final palette = context.palette;
    return Row(
      children: [
        SvgPicture.asset(icon, width: 22.w, height: 22.w),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                color: palette.textSub,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: palette.textMain,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextRow({
    required String label,
    required String value,
    required BuildContext context,
  }) {
    final palette = context.palette;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: palette.textSub,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12.sp,
              color: palette.textMain,
            ),
          ),
        ),
      ],
    );
  }
}
