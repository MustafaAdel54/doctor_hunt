import 'package:doctor_hunt/shared/generated/image_assets.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorLocationMap extends StatelessWidget {
  const DoctorLocationMap({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Container(
        height: 210.h,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: palette.shadowSoft,
              blurRadius: 10.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Image.asset(
            ImageAssets.doctorMap,
            width: double.infinity,
            height: 210.h,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: palette.surfaceAlt,
              child: Center(
                child: Icon(
                  Icons.map,
                  size: 48.sp,
                  color: palette.textPlaceholder,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
