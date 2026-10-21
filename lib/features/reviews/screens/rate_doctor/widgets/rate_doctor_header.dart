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
import 'package:go_router/go_router.dart';

class RateDoctorHeader extends StatelessWidget {
  final AppointmentModel? appointment;

  const RateDoctorHeader({
    super.key,
    required this.appointment,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final locale = Localizations.localeOf(context).languageCode;

    final doctor = appointment != null
        ? GetIt.instance<DoctorsCubit>().getDoctorById(appointment!.doctorId)
        : null;

    final doctorName = appointment?.doctorName[locale] ??
        appointment?.doctorName.values.firstOrNull ??
        doctor?.name[locale] ??
        doctor?.name.values.firstOrNull ??
        'Doctor';

    final specialization = doctor?.specialization ?? 'Specialist';

    return Column(
      children: [
        SizedBox(height: 12.h),

        // Navigation Bar
        Row(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (context.canPop()) context.pop();
              },
              child: Container(
                width: 30.w,
                height: 30.w,
                decoration: BoxDecoration(
                  color: palette.surface,
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: palette.shadowSoft,
                      blurRadius: 10.r,
                      offset: Offset(0, 2.h),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  ImageAssets.backArrow,
                  width: 30.w,
                  height: 30.h,
                ),
              ),
            ),
            SizedBox(width: 20.w),
            Text(
              t.appointments.rateDoctor,
              style: context.medium18TextMain,
            ),
          ],
        ),

        SizedBox(height: 28.h),

        // Doctor Avatar
        ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            width: 100.w,
            height: 100.w,
            color: FigmaRaw.green500.withValues(alpha: 0.08),
            child: doctor?.image != null && doctor!.image!.isNotEmpty
                ? Image.asset(doctor.image!, fit: BoxFit.cover)
                : Image.asset(ImageAssets.popDoctor1, fit: BoxFit.cover),
          ),
        ),

        SizedBox(height: 16.h),

        Text(
          doctorName,
          style: context.bold18TextMain,
        ),
        SizedBox(height: 4.h),
        Text(
          specialization,
          style: context.regular14TextSub.copyWith(color: palette.textSub),
        ),
      ],
    );
  }
}
