import 'package:flutter/material.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';
import 'package:doctor_hunt/apps/features/doctors/data/models/doctor_model.dart';
import 'package:doctor_hunt/i18n/strings.g.dart';

class DoctorServicesList extends StatelessWidget {
  final DoctorModel doctor;

  const DoctorServicesList({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.doctors.services,
            style: context.medium18.copyWith(color: context.palette.textMain),
          ),
          const SizedBox(height: 16),
          ...doctor.services.asMap().entries.map((entry) {
            final index = entry.key;
            final service = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${index + 1}. ',
                    style: context.medium14.copyWith(
                      color: context.palette.primary,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      service,
                      style: context.regular14.copyWith(
                        color: context.palette.textSub,
                      ),
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
