import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorStatItem extends StatelessWidget {
  final String value;
  final String label;

  const DoctorStatItem({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      width: 80.w,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: context.medium18TextMain,
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: context.regular14TextSub,
          ),
        ],
      ),
    );
  }
}
