import 'package:doctor_hunt/core/router/routes.dart';
import 'package:doctor_hunt/features/doctors/models/doctor_model.dart';
import 'package:doctor_hunt/shared/constants/app_constants.dart';
import 'package:doctor_hunt/shared/generated/app_colors.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class DoctorProfileCard extends StatelessWidget {
  final DoctorModel doctor;
  final String doctorId;

  const DoctorProfileCard({
    super.key,
    required this.doctor,
    required this.doctorId,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final locale = Localizations.localeOf(context).languageCode;
    final name = doctor.name[locale] ?? doctor.name.values.first;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: palette.shadowSoft,
            blurRadius: 20.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Doctor Image with Hero
          Hero(
            tag: 'doctor_image_$doctorId',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: _buildDoctorImage(doctor.image, palette),
            ),
          ),
          SizedBox(width: 16.w),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and Favorite
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: context.medium18TextMain,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(Icons.favorite, color: palette.danger, size: 24.sp),
                  ],
                ),
                Gaps.h4,

                // Specialization
                Text(
                  doctor.specialization,
                  style: context.regular12TextSub,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Gaps.h8,

                // Rating and Hourly Rate
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: palette.warning,
                          size: 16.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          doctor.rating > 0 ? doctor.rating.toStringAsFixed(1) : '5.0',
                          style: context.medium14TextMain,
                        ),
                      ],
                    ),
                    Text(
                      t.doctors.perHour(price: doctor.hourlyRate.toStringAsFixed(2)),
                      style: context.medium14Primary,
                    ),
                  ],
                ),
                Gaps.h12,

                // Book Now Button
                SizedBox(
                  width: double.infinity,
                  height: 36.h,
                  child: ElevatedButton(
                    onPressed: () {
                      context.pushNamed(
                        Routes.bookAppointment,
                        pathParameters: {'doctorId': doctorId},
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: palette.primary,
                      foregroundColor: palette.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      padding: EdgeInsets.zero,
                      elevation: 0,
                    ),
                    child: Text(
                      t.doctors.bookNow,
                      style: context.medium14White,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorImage(String? image, AppPalette palette) {
    if (image == null || image.isEmpty) {
      return Container(
        width: 90.w,
        height: 90.h,
        color: palette.primary.withValues(alpha: 0.1),
        child: Icon(Icons.person, color: palette.primary, size: 40.sp),
      );
    }

    if (image.startsWith('http://') || image.startsWith('https://')) {
      return Image.network(
        image,
        width: 90.w,
        height: 90.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: 90.w,
          height: 90.h,
          color: palette.primary.withValues(alpha: 0.1),
          child: Icon(Icons.person, color: palette.primary, size: 40.sp),
        ),
      );
    }

    return Image.asset(
      image,
      width: 90.w,
      height: 90.h,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        width: 90.w,
        height: 90.h,
        color: palette.primary.withValues(alpha: 0.1),
        child: Icon(Icons.person, color: palette.primary, size: 40.sp),
      ),
    );
  }
}
