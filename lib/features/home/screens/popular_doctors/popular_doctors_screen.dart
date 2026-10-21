import 'package:doctor_hunt/core/router/routes.dart';
import 'package:doctor_hunt/features/doctors/cubit/doctors_cubit.dart';
import 'package:doctor_hunt/features/doctors/cubit/doctors_state.dart';
import 'package:doctor_hunt/features/home/models/home_mock_data.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
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
                        prev.popularDoctors != curr.popularDoctors,
                    builder: (context, state) {
                      final doctors = state.popularDoctors;

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
                                extra: doctor.toDoctorModel(),
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
