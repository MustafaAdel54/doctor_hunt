import 'package:doctor_hunt/features/doctors/models/doctor_model.dart';
import 'package:doctor_hunt/features/doctors/widgets/doctor_image.dart';
import 'package:doctor_hunt/shared/constants/app_constants.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FeatureDoctorCard extends StatelessWidget {
  const FeatureDoctorCard({
    super.key,
    required this.doctor,
    required this.onTap,
  });

  final DoctorModel doctor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final locale = Localizations.localeOf(context).languageCode;
    final doctorName = doctor.localizedName(locale);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 96.w,
        height: 130.h,
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(6.r),
          boxShadow: [
            BoxShadow(
              color: palette.shadowSoft,
              blurRadius: 20.r,
              offset: Offset(0, -1.h),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Content
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Gaps.h16,
                Center(
                  child: Hero(
                    tag: 'doctor_image_${doctor.id}',
                    child: DoctorImage(
                      image: doctor.image,
                      width: 54.w,
                      height: 54.h,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Gaps.h8,
                Text(
                  doctorName,
                  style: context.medium12TextMain,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                if (doctor.hourlyRate > 0) ...[
                  Gaps.h4,
                  Text(
                    doctor.formattedHourlyRate,
                    style: context.light8Primary,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
            // Rating badge (top left)
            Positioned(
              top: 8.h,
              left: 8.w,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: palette.warning, size: 10.sp),
                  SizedBox(width: 2.w),
                  Text(
                    doctor.rating.toStringAsFixed(1),
                    style: context.regular11TextSub,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
