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
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 30.w,
                  height: 30.w,
                  decoration: BoxDecoration(
                    color: palette.white,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                Container(width: 120.w, height: 20.h, color: palette.white),
                Container(
                  width: 30.w,
                  height: 30.w,
                  decoration: BoxDecoration(
                    color: palette.white,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),

          // Card Shimmer (170.h, 8.r)
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            height: 170.h,
            decoration: BoxDecoration(
              color: palette.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          SizedBox(height: 16.h),

          // Services Shimmer
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 100.w, height: 20.h, color: palette.white),
                SizedBox(height: 16.h),
                Container(
                  width: double.infinity,
                  height: 16.h,
                  color: palette.white,
                ),
                SizedBox(height: 16.h),
                Container(
                  width: double.infinity,
                  height: 16.h,
                  color: palette.white,
                ),
                SizedBox(height: 16.h),
                Container(
                  width: double.infinity,
                  height: 16.h,
                  color: palette.white,
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),

          // Map Shimmer (210.h, 12.r)
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            height: 210.h,
            decoration: BoxDecoration(
              color: palette.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ],
      ),
    );
  }
}
