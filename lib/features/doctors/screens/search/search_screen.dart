import 'dart:async';

import 'package:doctor_hunt/core/router/routes.dart';
import 'package:doctor_hunt/features/doctors/cubit/doctors_cubit.dart';
import 'package:doctor_hunt/features/doctors/cubit/doctors_state.dart';
import 'package:doctor_hunt/features/home/screens/popular_doctors/widgets/popular_doctor_list_card.dart';
import 'package:doctor_hunt/features/home/screens/popular_doctors/widgets/popular_doctors_background_glow.dart';
import 'package:doctor_hunt/shared/constants/app_constants.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 350), () {
      if (mounted) {
        context.read<DoctorsCubit>().searchDoctors(query);
      }
    });
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
              children: [
                // Search App Bar
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  child: Row(
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          if (context.canPop()) {
                            context.pop();
                          }
                        },
                        child: Container(
                          width: 30.w,
                          height: 30.w,
                          decoration: BoxDecoration(
                            color: palette.surface,
                            borderRadius: BorderRadius.circular(10.r),
                            boxShadow: [
                              BoxShadow(
                                color: palette.shadowSoft,
                                blurRadius: 10.r,
                                offset: Offset(0, 2.h),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            size: 16.sp,
                            color: palette.textMain,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Container(
                          height: 48.h,
                          padding: EdgeInsets.symmetric(horizontal: 14.w),
                          decoration: BoxDecoration(
                            color: palette.surface,
                            borderRadius: BorderRadius.circular(8.r),
                            boxShadow: [
                              BoxShadow(
                                color: palette.shadowSoft,
                                blurRadius: 10.r,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search,
                                color: palette.textSub,
                                size: 20.sp,
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: TextField(
                                  controller: _controller,
                                  autofocus: true,
                                  onChanged: _onSearchChanged,
                                  decoration: InputDecoration(
                                    hintText: t.doctors.searchHint,
                                    hintStyle: context.regular14TextPlaceholder,
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                              if (_controller.text.isNotEmpty)
                                GestureDetector(
                                  onTap: () {
                                    _controller.clear();
                                    context.read<DoctorsCubit>().searchDoctors('');
                                    setState(() {});
                                  },
                                  child: Icon(
                                    Icons.close,
                                    color: palette.textSub,
                                    size: 18.sp,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Results / States
                Expanded(
                  child: BlocBuilder<DoctorsCubit, DoctorsState>(
                    builder: (context, state) {
                      if (state.isSearching) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: palette.primary,
                          ),
                        );
                      }

                      if (_controller.text.trim().isNotEmpty &&
                          state.searchResults.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(24.r),
                            child: Text(
                              t.doctors.noDoctors,
                              style: context.regular16TextSub,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }

                      if (_controller.text.trim().isEmpty) {
                        return Center(
                          child: Text(
                            t.doctors.searchHint,
                            style: context.regular14TextPlaceholder,
                          ),
                        );
                      }

                      return ListView.separated(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 12.h,
                        ),
                        itemCount: state.searchResults.length,
                        separatorBuilder: (_, __) => Gaps.h12,
                        itemBuilder: (context, index) {
                          final doctor = state.searchResults[index];
                          return PopularDoctorListCard(
                            doctor: doctor,
                            onTap: () {
                              context.pushNamed(
                                Routes.doctorDetails,
                                pathParameters: {'doctorId': doctor.id},
                                extra: doctor,
                              );
                            },
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
