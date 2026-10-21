import 'package:doctor_hunt/core/router/routes.dart';
import 'package:doctor_hunt/shared/generated/image_assets.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class DoctorDetailsHeader extends StatelessWidget {
  const DoctorDetailsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button (30x30 with 10.r)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (context.canPop()) {
                context.pop();
              }
            },
            child: Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                color: palette.surface,
                borderRadius: BorderRadius.circular(10.r),
                boxShadow: [
                  BoxShadow(
                    color: palette.shadowSoft,
                    blurRadius: 10.r,
                    offset: Offset(0, 2.h),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                ImageAssets.backArrow,
                width: 30.w,
                height: 30.h,
              ),
            ),
          ),

          // Title
          Text(
            t.doctors.detailsTitle,
            style: context.medium18TextMain,
          ),

          // Search icon
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => context.pushNamed(Routes.search),
            child: SizedBox(
              width: 30.w,
              height: 30.w,
              child: Center(
                child: Icon(
                  Icons.search,
                  size: 20.sp,
                  color: palette.textSub,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
