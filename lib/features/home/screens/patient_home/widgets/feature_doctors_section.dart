import 'package:flutter/material.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';
import 'package:doctor_hunt/apps/core/constants/app_constants.dart';
import 'package:doctor_hunt/i18n/strings.g.dart';
import '../../../models/home_mock_data.dart';
import 'cards/feature_doctor_card.dart';

class FeatureDoctorsSection extends StatelessWidget {
  const FeatureDoctorsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final doctors = HomeMockData.featureDoctors;

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
                t.home.featuredDoctors,
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
          height: 130,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            scrollDirection: Axis.horizontal,
            itemCount: doctors.length,
            separatorBuilder: (context, index) => Gaps.w16,
            itemBuilder: (context, index) {
              return FeatureDoctorCard(doctor: doctors[index], onTap: () {});
            },
          ),
        ),
      ],
    );
  }
}
