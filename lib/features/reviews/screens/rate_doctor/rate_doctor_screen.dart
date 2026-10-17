import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';

class RateDoctorScreen extends StatelessWidget {
  const RateDoctorScreen({super.key, required this.appointmentId});
  final String appointmentId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          t.reviews.rateVisit,
          style: context.medium16TextMain,
        ),
      ),
    );
  }
}
