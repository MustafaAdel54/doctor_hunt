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

import 'widgets/popular_doctor_list_card.dart';
import 'widgets/popular_doctors_background_glow.dart';
import 'widgets/popular_doctors_header.dart';

class PopularDoctorsScreen extends StatelessWidget {
  const PopularDoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Scaffold(
      backgroundColor: palette.surface,
      body: Stack(
        children: [
          const PopularDoctorsBackgroundGlow(),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PopularDoctorsHeader(),
                Expanded(
                  child: BlocBuilder<DoctorsCubit, DoctorsState>(
                    buildWhen: (prev, curr) =>
                        prev.popularDoctors != curr.popularDoctors ||
                        prev.isLoading != curr.isLoading ||
                        prev.errorMessage != curr.errorMessage,
                    builder: (context, state) {
                      final doctors = state.popularDoctors;

                      if (state.isLoading && doctors.isEmpty) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: palette.primary,
                          ),
                        );
                      }

                      if (state.errorMessage != null && doctors.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(24.r),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: palette.danger,
                                  size: 40.sp,
                                ),
                                Gaps.h12,
                                Text(
                                  state.errorMessage!,
                                  style: context.regular14TextSub,
                                  textAlign: TextAlign.center,
                                ),
                                Gaps.h16,
                                ElevatedButton.icon(
                                  onPressed: () =>
                                      context.read<DoctorsCubit>().loadDoctors(),
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
                          ),
                        );
                      }

                      if (doctors.isEmpty) {
                        return Center(
                          child: Text(
                            t.doctors.noDoctors,
                            style: context.regular16TextSub,
                            textAlign: TextAlign.center,
                          ),
                        );
                      }

                      return ListView.separated(
                        padding: EdgeInsets.only(
                          left: 20.w,
                          right: 20.w,
                          top: 14.h,
                          bottom: 24.h,
                        ),
                        itemCount: doctors.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 14.h),
                        itemBuilder: (context, index) {
                          final doctor = doctors[index];
                          return PopularDoctorListCard(
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
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
