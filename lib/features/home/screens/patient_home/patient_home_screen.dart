import 'package:doctor_hunt/shared/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'widgets/category_tabs_section.dart';
import 'widgets/feature_doctors_section.dart';
import 'widgets/home_header.dart';
import 'widgets/home_search_bar.dart';
import 'widgets/popular_doctors_section.dart';

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
                Positioned(
                  top: 126.h,
                  left: 20.w,
                  right: 20.w,
                  child: const HomeSearchBar(),
                ),
                // We add an invisible box to ensure the Stack sizes itself
                // large enough to contain the overlapping SearchBar.
                SizedBox(
                  width: double.infinity,
                  height: 180.h, // Header height + amount search bar overhangs
                ),
              ],
            ),
            Gaps.h32,
            const CategoryTabsSection(),
            Gaps.h16,
            const PopularDoctorsSection(),
            Gaps.h32,
            const FeatureDoctorsSection(),
            SizedBox(height: 100.h), // padding for bottom nav bar
          ],
        ),
      ),
    );
  }
}
