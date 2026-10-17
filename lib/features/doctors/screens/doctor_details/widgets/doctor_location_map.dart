import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorLocationMap extends StatelessWidget {
  const DoctorLocationMap({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 10.h,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          height: 200.h,
          width: double.infinity,
          color: palette.surfaceAlt,
          child: Center(
            child: Icon(
              Icons.map,
              size: 60.sp,
              color: palette.textPlaceholder,
            ),
          ),
        ),
      ),
    );
  }
}
