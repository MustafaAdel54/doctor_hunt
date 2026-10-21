import 'package:doctor_hunt/features/favorites/cubit/favorites_cubit.dart';
import 'package:doctor_hunt/features/favorites/cubit/favorites_state.dart';
import 'package:doctor_hunt/features/home/models/home_mock_data.dart';
import 'package:doctor_hunt/features/home/screens/popular_doctors/widgets/popular_doctors_background_glow.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'widgets/favourite_doctor_grid_card.dart';
import 'widgets/favourite_doctors_empty_state.dart';
import 'widgets/favourite_doctors_search_bar.dart';

class FavouriteDoctorsScreen extends StatefulWidget {
  const FavouriteDoctorsScreen({super.key});

  @override
  State<FavouriteDoctorsScreen> createState() => _FavouriteDoctorsScreenState();
}

class _FavouriteDoctorsScreenState extends State<FavouriteDoctorsScreen> {
  String _searchQuery = '';

  // Source list of all available doctors
  List<HomeDoctor> get _allDoctors {
    final seen = <String>{};
    final list = <HomeDoctor>[];
    for (final doc in [
      ...HomeMockData.popularDoctors,
      ...HomeMockData.featureDoctors,
    ]) {
      if (seen.add(doc.id)) {
        list.add(doc);
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Scaffold(
      backgroundColor: palette.surface,
      body: Stack(
        children: [
          const PopularDoctorsBackgroundGlow(),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  child: Text(
                    t.doctors.favouriteDoctors,
                    style: context.medium18TextMain,
                  ),
                ),
                FavouriteDoctorsSearchBar(
                  onChanged: (q) => setState(() => _searchQuery = q.trim()),
                ),
                Expanded(
                  child: BlocBuilder<FavoritesCubit, FavoritesState>(
                    builder: (context, state) {
                      if (state.isLoading && state.favoriteDoctorIds.isEmpty) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: palette.primary,
                          ),
                        );
                      }

                      // Filter doctors that are favorited
                      final favoritedDoctors = _allDoctors.where((doctor) {
                        return state.isFavorite(doctor.id);
                      }).toList();

                      // Apply search query filter if typed
                      final filteredDoctors = _searchQuery.isEmpty
                          ? favoritedDoctors
                          : favoritedDoctors.where((doctor) {
                              final nameMatches = doctor.name
                                  .toLowerCase()
                                  .contains(_searchQuery.toLowerCase());
                              final specMatches = doctor.specialization
                                      ?.toLowerCase()
                                      .contains(_searchQuery.toLowerCase()) ??
                                  false;
                              return nameMatches || specMatches;
                            }).toList();

                      if (filteredDoctors.isEmpty) {
                        return FavouriteDoctorsEmptyState(
                          isSearchResult: _searchQuery.isNotEmpty &&
                              favoritedDoctors.isNotEmpty,
                        );
                      }

                      return GridView.builder(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 12.h,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15.w,
                          mainAxisSpacing: 15.h,
                          childAspectRatio: 160 / 185,
                        ),
                        itemCount: filteredDoctors.length,
                        itemBuilder: (context, index) {
                          return FavouriteDoctorGridCard(
                            doctor: filteredDoctors[index],
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
