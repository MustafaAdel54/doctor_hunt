import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';

class DoctorRequestsScreen extends StatelessWidget {
  const DoctorRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          t.doctor.pendingRequests,
          style: context.medium16TextMain,
        ),
      ),
    );
  }
}
