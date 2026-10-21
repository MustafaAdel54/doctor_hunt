import 'package:doctor_hunt/shared/generated/app_colors.dart';
import 'package:doctor_hunt/shared/generated/image_assets.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingEmptySlots extends StatelessWidget {
  final String dateHeading;

  const BookingEmptySlots({
    super.key,
    required this.dateHeading,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 24.h),

          // Centered Date Heading (Figma 1:685 - 16px, 500 weight)
          Text(
            dateHeading,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: context.palette.textMain,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 36.h),

          // Exact Illustration from Figma (Node 3640:1433)
          Image.asset(
            ImageAssets.noSlotsIllustration,
            width: 240.w,
            height: 215.h,
            fit: BoxFit.contain,
          ),

          SizedBox(height: 24.h),

          // Subtext "No slots available" (Figma 1:684 - 14px, #677294)
          Text(
            t.appointments.noSlotsAvailable,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: FigmaRaw.grey500,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 48.h),
        ],
      ),
    );
  }
}

