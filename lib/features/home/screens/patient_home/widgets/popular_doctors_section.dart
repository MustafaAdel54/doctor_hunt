import 'package:doctor_hunt/core/router/routes.dart';
import 'package:doctor_hunt/features/doctors/cubit/doctors_cubit.dart';
import 'package:doctor_hunt/features/doctors/cubit/doctors_state.dart';
import 'package:doctor_hunt/shared/constants/app_constants.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'cards/popular_doctor_card.dart';
import 'home_section_header.dart';

class PopularDoctorsSection extends StatelessWidget {
  const PopularDoctorsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return BlocBuilder<DoctorsCubit, DoctorsState>(
      buildWhen: (prev, curr) =>
          prev.popularDoctors != curr.popularDoctors ||
          prev.isLoading != curr.isLoading ||
          prev.errorMessage != curr.errorMessage,
      builder: (context, state) {
        final doctors = state.popularDoctors;

        Widget content;

        if (state.isLoading && doctors.isEmpty) {
          content = SizedBox(
            height: 264.h,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              separatorBuilder: (_, __) => Gaps.w16,
              itemBuilder: (context, index) => Container(
                width: 190.w,
                height: 264.h,
                decoration: BoxDecoration(
                  color: palette.surfaceAlt.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: SizedBox(
                    width: 24.w,
                    height: 24.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: palette.primary,
                    ),
                  ),
                ),
              ),
            ),
          );
        } else if (state.errorMessage != null && doctors.isEmpty) {
          content = Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              color: palette.surface,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: palette.shadowSoft,
                  blurRadius: 10.r,
                  offset: Offset(0, 2.h),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, color: palette.danger, size: 36.sp),
                Gaps.h8,
                Text(
                  state.errorMessage!,
                  style: context.regular14TextSub,
                  textAlign: TextAlign.center,
                ),
                Gaps.h12,
                ElevatedButton.icon(
                  onPressed: () => context.read<DoctorsCubit>().loadDoctors(),
                  icon: const Icon(Icons.refresh),
                  label: Text(t.common.retry),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: palette.primary,
                    foregroundColor: palette.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (doctors.isEmpty) {
          content = Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            padding: EdgeInsets.all(24.r),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: palette.surface,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              t.doctors.noDoctors,
              style: context.regular14TextSub,
              textAlign: TextAlign.center,
            ),
          );
        } else {
          content = SizedBox(
            height: 264.h,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              scrollDirection: Axis.horizontal,
              itemCount: doctors.length,
              separatorBuilder: (context, index) => Gaps.w16,
              itemBuilder: (context, index) {
                final doctor = doctors[index];
                return PopularDoctorCard(
                  doctor: doctor,
                  onTap: () {
                    context.pushNamed(
                      Routes.doctorDetails,
                      pathParameters: {'doctorId': doctor.id},
                      extra: doctor,
                    );
                  },
                );
              },
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeSectionHeader(
              title: t.home.popularDoctors,
              onSeeAllTap: () => context.pushNamed(Routes.popularDoctors),
            ),
            Gaps.h16,
            content,
          ],
        );
      },
    );
  }
}
