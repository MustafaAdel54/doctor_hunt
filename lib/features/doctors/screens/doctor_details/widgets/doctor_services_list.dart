import 'package:doctor_hunt/features/doctors/models/doctor_model.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorServicesList extends StatelessWidget {
  final DoctorModel doctor;

  const DoctorServicesList({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.doctors.services,
            style: context.medium18TextMain,
          ),
          SizedBox(height: 16.h),
          ...doctor.services.asMap().entries.map((entry) {
            final index = entry.key;
            final service = entry.value;
            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${index + 1}. ',
                    style: context.medium14Primary,
                  ),
                  Expanded(
                    child: Text(
                      service,
                      style: context.regular14TextSub,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
