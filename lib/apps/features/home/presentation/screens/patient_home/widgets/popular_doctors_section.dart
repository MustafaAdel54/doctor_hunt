import 'package:flutter/material.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';
import 'package:doctor_hunt/apps/core/constants/app_constants.dart';
import 'package:doctor_hunt/i18n/strings.g.dart';
import '../../../models/home_mock_data.dart';
import 'cards/popular_doctor_card.dart';

class PopularDoctorsSection extends StatelessWidget {
  const PopularDoctorsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final doctors = HomeMockData.popularDoctors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                t.home.popularDoctors,
                style: context.medium18.copyWith(
                  color: context.palette.textMain,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      t.home.seeAll,
                      style: context.light12.copyWith(
                        color: context.palette.textSub,
                      ),
                    ),
                    Gaps.w4,
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 10,
                      color: context.palette.textSub,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Gaps.h16,
        SizedBox(
          height: 264,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            scrollDirection: Axis.horizontal,
            itemCount: doctors.length,
            separatorBuilder: (context, index) => Gaps.w16,
            itemBuilder: (context, index) {
              return PopularDoctorCard(doctor: doctors[index], onTap: () {});
            },
          ),
        ),
      ],
    );
  }
}
