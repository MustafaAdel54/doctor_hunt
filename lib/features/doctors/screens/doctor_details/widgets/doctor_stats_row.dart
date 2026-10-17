import 'package:doctor_hunt/features/doctors/models/doctor_model.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'doctor_stat_item.dart';

class DoctorStatsRow extends StatelessWidget {
  final DoctorModel doctor;

  const DoctorStatsRow({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: palette.shadowSoft,
              blurRadius: 20.r,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            DoctorStatItem(
              value: doctor.runningCount.toString(),
              label: t.doctors.statRunning,
            ),
            Container(width: 1.w, height: 40.h, color: palette.textBorders),
            DoctorStatItem(
              value: doctor.ongoingCount.toString(),
              label: t.doctors.statOngoing,
            ),
            Container(width: 1.w, height: 40.h, color: palette.textBorders),
            DoctorStatItem(
              value: doctor.patientsCount.toString(),
              label: t.doctors.statPatients,
            ),
          ],
        ),
      ),
    );
  }
}
