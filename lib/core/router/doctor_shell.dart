import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';

class DoctorShell extends StatelessWidget {
  const DoctorShell({super.key, required this.navigationShell});
  final Widget navigationShell;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: navigationShell,
    bottomNavigationBar: BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: const Icon(Icons.home), label: t.nav.home),
        BottomNavigationBarItem(icon: const Icon(Icons.list), label: t.nav.requests),
        BottomNavigationBarItem(
          icon: const Icon(Icons.schedule),
          label: t.doctor.availability,
        ),
        BottomNavigationBarItem(icon: const Icon(Icons.star), label: t.reviews.title),
        BottomNavigationBarItem(icon: const Icon(Icons.person), label: t.nav.profile),
      ],
    ),
  );
}
