import 'package:doctor_hunt/core/router/routes.dart';
import 'package:doctor_hunt/features/doctors/cubit/doctors_cubit.dart';
import 'package:doctor_hunt/shared/generated/image_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

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
          _buildCategoryTab(ImageAssets.catTooth, () {
            context.read<DoctorsCubit>().searchDoctors('Dentist');
            context.pushNamed(Routes.search);
          }),
          SizedBox(width: 8.w),
          _buildCategoryTab(ImageAssets.catHeart, () {
            context.read<DoctorsCubit>().searchDoctors('Cardiologist');
            context.pushNamed(Routes.search);
          }),
          SizedBox(width: 8.w),
          _buildCategoryTab(ImageAssets.catEye, () {
            context.read<DoctorsCubit>().searchDoctors('Eye');
            context.pushNamed(Routes.search);
          }),
          SizedBox(width: 8.w),
          _buildCategoryTab(ImageAssets.catBody, () {
            context.read<DoctorsCubit>().searchDoctors('Specialist');
            context.pushNamed(Routes.search);
          }),
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
