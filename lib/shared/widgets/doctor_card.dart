import 'package:doctor_hunt/features/doctors/models/doctor_model.dart';
import 'package:doctor_hunt/shared/constants/app_constants.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({
    super.key,
    required this.doctor,
    required this.onTap,
    this.onBookTap,
  });

  final DoctorModel doctor;
  final VoidCallback onTap;
  final VoidCallback? onBookTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final locale = TranslationProvider.of(context).locale.name;

    final name = doctor.name[locale] ?? doctor.name.values.firstOrNull ?? '';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: palette.textBorders),
          boxShadow: [
            BoxShadow(
              color: palette.shadowSoft,
              blurRadius: 10.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo
            Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.md),
                color: palette.primary.withValues(alpha: 0.1),
                image: doctor.image != null
                    ? DecorationImage(
                        image: NetworkImage(doctor.image!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: doctor.image == null
                  ? Icon(Icons.person, color: palette.primary, size: 40.sp)
                  : null,
            ),
            Gaps.w16,
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: context.bold16TextMain,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Gaps.h4,
                  Text(
                    doctor.specialization,
                    style: context.regular14TextSub,
                  ),
                  Gaps.h8,
                  Row(
                    children: [
                      Icon(Icons.star, color: palette.warning, size: 16.sp),
                      Gaps.w4,
                      Text(
                        doctor.rating.toStringAsFixed(1),
                        style: context.medium14TextMain,
                      ),
                      Gaps.w12,
                      Icon(
                        Icons.work_history,
                        color: palette.primary,
                        size: 16.sp,
                      ),
                      Gaps.w4,
                      Text(
                        t.doctors.experience(n: doctor.yearsExperience),
                        style: context.medium14TextSub,
                      ),
                    ],
                  ),
                  if (onBookTap != null) ...[
                    Gaps.h12,
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: onBookTap,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: palette.primary,
                          side: BorderSide(color: palette.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                        ),
                        child: Text(
                          t.doctors.bookNow,
                          style: context.medium14Primary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
