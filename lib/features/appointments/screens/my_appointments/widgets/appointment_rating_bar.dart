import 'package:doctor_hunt/features/appointments/models/appointment_model.dart';
import 'package:doctor_hunt/shared/generated/image_assets.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppointmentRatingBar extends StatelessWidget {
  final AppointmentModel appointment;
  final VoidCallback onTap;

  const AppointmentRatingBar({
    super.key,
    required this.appointment,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final rating = appointment.rating;
    final isRated = rating != null && rating > 0;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 32.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          color: isRated ? const Color(0xFFFFF9E6) : const Color(0xFFE8F8F3),
          borderRadius: BorderRadius.circular(6.r),
          border: isRated
              ? Border.all(
                  color: const Color(0xFFF6D060).withValues(alpha: 0.35),
                  width: 1,
                )
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (isRated) ...[
                  Icon(
                    Icons.star_rounded,
                    color: const Color(0xFFF6D060),
                    size: 16.sp,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '${t.appointments.yourRating}: $rating.0',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF333333),
                    ),
                  ),
                ] else ...[
                  Text(
                    t.appointments.tapToRateYourVisit,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: palette.textSub,
                    ),
                  ),
                ],
              ],
            ),
            if (isRated)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (index) {
                  final isFilled = index < rating;
                  return Padding(
                    padding: EdgeInsets.only(left: 2.w),
                    child: Icon(
                      Icons.star_rounded,
                      size: 14.sp,
                      color: isFilled
                          ? const Color(0xFFF6D060)
                          : const Color(0xFFD6D9E0),
                    ),
                  );
                }),
              )
            else
              SvgPicture.asset(
                ImageAssets.apptRatingStars,
                height: 14.h,
              ),
          ],
        ),
      ),
    );
  }
}
