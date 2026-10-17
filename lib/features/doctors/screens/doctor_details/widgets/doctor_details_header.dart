import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class DoctorDetailsHeader extends StatelessWidget {
  const DoctorDetailsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => context.pop(),
            child: Container(
              width: 44.w,
              height: 44.h,
              decoration: BoxDecoration(
                color: palette.surface,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: palette.shadowSoft,
                    blurRadius: 10.r,
                    offset: Offset(0, 4.h),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 20.sp,
                color: palette.textSub,
              ),
            ),
          ),
          // Title
          Text(
            t.doctors.detailsTitle,
            style: context.medium18TextMain,
          ),
          // Search icon
          Container(
            width: 44.w,
            height: 44.h,
            alignment: Alignment.center,
            child: Icon(Icons.search, size: 28.sp, color: palette.textSub),
          ),
        ],
      ),
    );
  }
}
