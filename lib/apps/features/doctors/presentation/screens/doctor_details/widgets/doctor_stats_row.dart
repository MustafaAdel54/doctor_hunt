import 'package:flutter/material.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';
import 'package:doctor_hunt/apps/features/doctors/data/models/doctor_model.dart';

class DoctorStatsRow extends StatelessWidget {
  final DoctorModel doctor;

  const DoctorStatsRow({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _StatItem(value: doctor.runningCount.toString(), label: 'Runing'),
            Container(width: 1, height: 40, color: Colors.grey.shade200),
            _StatItem(value: doctor.ongoingCount.toString(), label: 'Ongoing'),
            Container(width: 1, height: 40, color: Colors.grey.shade200),
            _StatItem(value: doctor.patientsCount.toString(), label: 'Patient'),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFBFB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: context.medium18.copyWith(color: context.palette.textMain),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: context.regular14.copyWith(color: context.palette.textSub),
          ),
        ],
      ),
    );
  }
}
