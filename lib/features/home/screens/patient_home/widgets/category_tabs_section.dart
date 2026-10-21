import 'package:doctor_hunt/shared/generated/image_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoryTabsSection extends StatelessWidget {
  const CategoryTabsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      physics: const BouncingScrollPhysics(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildCategoryTab(ImageAssets.catTooth, () {}),
          SizedBox(width: 8.w),
          _buildCategoryTab(ImageAssets.catHeart, () {}),
          SizedBox(width: 8.w),
          _buildCategoryTab(ImageAssets.catEye, () {}),
          SizedBox(width: 8.w),
          _buildCategoryTab(ImageAssets.catBody, () {}),
        ],
      ),
    );
  }

  Widget _buildCategoryTab(String asset, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(
        asset,
        width: 100.w,
        height: 120.h,
      ),
    );
  }
}
