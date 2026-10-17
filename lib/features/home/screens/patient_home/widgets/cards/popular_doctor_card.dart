import 'package:doctor_hunt/features/home/models/home_mock_data.dart';
import 'package:doctor_hunt/shared/constants/app_constants.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PopularDoctorCard extends StatelessWidget {
  const PopularDoctorCard({
    super.key,
    required this.doctor,
    required this.onTap,
  });

  final HomeDoctor doctor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 190.w,
        height: 264.h,
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: palette.shadowSoft,
              blurRadius: 40.r,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: 'doctor_image_${doctor.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(12.r),
                ),
                child: Image.asset(
                  doctor.imageAsset,
                  width: 190.w,
                  height: 180.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 190.w,
                    height: 180.h,
                    color: palette.surfaceAlt,
                    child: Icon(
                      Icons.person,
                      color: palette.textPlaceholder,
                      size: 40.sp,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      doctor.name,
                      style: context.medium18TextMain,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                    if (doctor.specialization != null) ...[
                      Gaps.h4,
                      Text(
                        doctor.specialization!,
                        style: context.regular12TextSub,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ],
                    Gaps.h4,
                    RatingBarIndicator(
                      rating: doctor.rating,
                      itemBuilder: (context, index) =>
                          Icon(Icons.star, color: palette.warning),
                      itemCount: 5,
                      itemSize: 12.sp,
                      direction: Axis.horizontal,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
