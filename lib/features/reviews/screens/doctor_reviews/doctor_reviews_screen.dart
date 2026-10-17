import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';

class DoctorReviewsScreen extends StatelessWidget {
  const DoctorReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          t.reviews.title,
          style: context.medium16TextMain,
        ),
      ),
    );
  }
}
