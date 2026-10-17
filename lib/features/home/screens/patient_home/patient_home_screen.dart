import 'package:flutter/material.dart';
import 'package:doctor_hunt/apps/core/constants/app_constants.dart';
import 'widgets/home_header.dart';
import 'widgets/home_search_bar.dart';
import 'widgets/live_doctors_section.dart';
import 'widgets/category_tabs_section.dart';
import 'widgets/popular_doctors_section.dart';
import 'widgets/feature_doctors_section.dart';

class PatientHomeScreen extends StatelessWidget {
  const PatientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // The BottomNavigationBar is provided by the PatientShell wrapper from the router.
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                const HomeHeader(),
                const Positioned(
                  top: 126,
                  left: 20,
                  right: 20,
                  child: HomeSearchBar(),
                ),
                // We add an invisible box to ensure the Stack sizes itself
                // large enough to contain the overlapping SearchBar.
                const SizedBox(
                  width: double.infinity,
                  height:
                      156 + 24, // Header height + amount search bar overhangs
                ),
              ],
            ),
            const SizedBox(height: 30),
            const LiveDoctorsSection(),
            Gaps.h32,
            const CategoryTabsSection(),
            Gaps.h16,
            const PopularDoctorsSection(),
            Gaps.h32,
            const FeatureDoctorsSection(),
            Gaps.h32,
          ],
        ),
      ),
    );
  }
}
