import 'package:doctor_hunt/features/doctors/models/doctor_model.dart';
import 'package:doctor_hunt/shared/generated/app_colors.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorServicesList extends StatelessWidget {
  final DoctorModel doctor;

  const DoctorServicesList({super.key, required this.doctor});

  static const List<String> _defaultServices = [
    'Patient care should be the number one priority.',
    'If you run your practiceyou know how frustrating.',
    'That’s why some of appointment reminder system.',
  ];

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final services = doctor.services.isNotEmpty ? doctor.services : _defaultServices;

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
          ...services.asMap().entries.map((entry) {
            final index = entry.key;
            final service = entry.value;
            final isLast = index == services.length - 1;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${index + 1}.   ',
                      style: TextStyle(
                        color: FigmaRaw.green500,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        service,
                        style: TextStyle(
                          color: palette.textSub.withValues(alpha: 0.9),
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w300,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
                if (!isLast)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Divider(
                      height: 1,
                      thickness: 0.8,
                      color: palette.textSub.withValues(alpha: 0.1),
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
