import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class DoctorDetailsShimmer extends StatelessWidget {
  const DoctorDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Shimmer.fromColors(
      baseColor: palette.surfaceAlt,
      highlightColor: palette.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Shimmer
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 44.w,
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: palette.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                Container(width: 120.w, height: 20.h, color: palette.white),
                Container(
                  width: 44.w,
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: palette.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),

          // Card Shimmer
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            height: 140.h,
            decoration: BoxDecoration(
              color: palette.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          SizedBox(height: 30.h),

          // Stats Row Shimmer
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            height: 90.h,
            decoration: BoxDecoration(
              color: palette.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          SizedBox(height: 30.h),

          // Services Shimmer
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 100.w, height: 24.h, color: palette.white),
                SizedBox(height: 16.h),
                Container(
                  width: double.infinity,
                  height: 20.h,
                  color: palette.white,
                ),
                SizedBox(height: 16.h),
                Container(
                  width: double.infinity,
                  height: 20.h,
                  color: palette.white,
                ),
                SizedBox(height: 16.h),
                Container(
                  width: double.infinity,
                  height: 20.h,
                  color: palette.white,
                ),
              ],
            ),
          ),
          SizedBox(height: 30.h),

          // Map Shimmer
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            height: 200.h,
            decoration: BoxDecoration(
              color: palette.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
        ],
      ),
    );
  }
}
