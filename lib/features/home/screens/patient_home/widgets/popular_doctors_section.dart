import 'package:doctor_hunt/core/router/routes.dart';
import 'package:doctor_hunt/features/home/models/home_mock_data.dart';
import 'package:doctor_hunt/shared/constants/app_constants.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'cards/popular_doctor_card.dart';
import 'home_section_header.dart';

class PopularDoctorsSection extends StatelessWidget {
  const PopularDoctorsSection({super.key});

  @override
  Widget build(BuildContext context) {
    const doctors = HomeMockData.popularDoctors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeSectionHeader(
          title: t.home.popularDoctors,
          onSeeAllTap: () => context.pushNamed(Routes.popularDoctors),
        ),
        Gaps.h16,
        SizedBox(
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
                    extra: doctor.toDoctorModel(),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
