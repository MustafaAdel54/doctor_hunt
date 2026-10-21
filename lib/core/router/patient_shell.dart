import 'package:doctor_hunt/features/appointments/cubit/appointments_cubit.dart';
import 'package:doctor_hunt/shared/widgets/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class PatientShell extends StatelessWidget {
  const PatientShell({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          if (index == 2 && GetIt.instance.isRegistered<AppointmentsCubit>()) {
            GetIt.instance<AppointmentsCubit>().refreshAppointments();
          }
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        icons: const [
          Icons.home_filled,
          Icons.favorite_border,
          Icons.menu_book,
          Icons.settings_outlined,
        ],
      ),
    );
  }
}
