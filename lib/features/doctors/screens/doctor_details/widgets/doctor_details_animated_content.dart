import 'package:doctor_hunt/features/doctors/models/doctor_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'doctor_details_header.dart';
import 'doctor_location_map.dart';
import 'doctor_profile_card.dart';
import 'doctor_services_list.dart';

class DoctorDetailsAnimatedContent extends StatelessWidget {
  final DoctorModel doctor;
  final String doctorId;

  const DoctorDetailsAnimatedContent({
    super.key,
    required this.doctor,
    required this.doctorId,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DoctorDetailsHeader(),

              // Profile Card
              Transform.translate(
                offset: Offset(0, 30.h * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: DoctorProfileCard(doctor: doctor, doctorId: doctorId),
                ),
              ),

              SizedBox(height: 16.h),

              // Services List
              Transform.translate(
                offset: Offset(0, 40.h * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: DoctorServicesList(doctor: doctor),
                ),
              ),

              SizedBox(height: 20.h),

              // Location Map Card
              Transform.translate(
                offset: Offset(0, 50.h * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: const DoctorLocationMap(),
                ),
              ),

              SizedBox(height: 32.h),
            ],
          ),
        );
      },
    );
  }
}
