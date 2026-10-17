import 'package:doctor_hunt/shared/constants/app_constants.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeSectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAllTap;
  final String? seeAllText;

  const HomeSectionHeader({
    super.key,
    required this.title,
    this.onSeeAllTap,
    this.seeAllText,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: context.medium18TextMain,
          ),
          if (onSeeAllTap != null)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onSeeAllTap,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    seeAllText ?? t.home.seeAll,
                    style: context.light12TextSub,
                  ),
                  Gaps.w4,
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 10.sp,
                    color: palette.textSub,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
