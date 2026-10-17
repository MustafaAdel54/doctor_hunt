import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';

class BookAppointmentScreen extends StatelessWidget {
  const BookAppointmentScreen({super.key, required this.doctorId});
  final String doctorId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          t.doctors.bookNow,
          style: context.medium16TextMain,
        ),
      ),
    );
  }
}
