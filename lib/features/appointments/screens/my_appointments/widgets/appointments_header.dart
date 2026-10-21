import 'package:doctor_hunt/shared/generated/image_assets.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class AppointmentsHeader extends StatelessWidget {
  const AppointmentsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Row(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (context.canPop()) {
                context.pop();
              } else {
                // Switch to home tab in patient shell
                StatefulNavigationShell.of(context).goBranch(0);
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
          SizedBox(width: 20.w),
          Text(
            t.appointments.appointmentsTitle,
            style: context.medium18TextMain,
          ),
        ],
      ),
    );
  }
}
