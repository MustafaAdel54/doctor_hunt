import 'package:flutter/material.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';
import 'package:doctor_hunt/apps/core/constants/app_constants.dart';
import 'package:doctor_hunt/i18n/strings.g.dart';
import '../../../models/home_mock_data.dart';
import 'cards/live_doctor_card.dart';

class LiveDoctorsSection extends StatelessWidget {
  const LiveDoctorsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final doctors = HomeMockData.liveDoctors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            t.home.liveDoctors,
            style: context.medium18.copyWith(color: context.palette.textMain),
          ),
        ),
        Gaps.h16,
        SizedBox(
          height: 168,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            scrollDirection: Axis.horizontal,
            itemCount: doctors.length,
            separatorBuilder: (context, index) => Gaps.w16,
            itemBuilder: (context, index) {
              return LiveDoctorCard(doctor: doctors[index], onTap: () {});
            },
          ),
        ),
      ],
    );
  }
}
