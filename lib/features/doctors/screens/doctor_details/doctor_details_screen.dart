import 'package:doctor_hunt/core/di/injector.dart';
import 'package:doctor_hunt/features/doctors/cubit/doctors_cubit.dart';
import 'package:doctor_hunt/features/doctors/models/doctor_model.dart';
import 'package:doctor_hunt/features/doctors/repo/doctor_repo.dart';
import 'package:doctor_hunt/features/home/screens/popular_doctors/widgets/popular_doctors_background_glow.dart';
import 'package:doctor_hunt/shared/constants/app_constants.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'widgets/doctor_details_animated_content.dart';
import 'widgets/doctor_details_shimmer.dart';

class DoctorDetailsScreen extends StatefulWidget {
  final String doctorId;
  final Object? extra;

  const DoctorDetailsScreen({
    super.key,
    required this.doctorId,
    this.extra,
  });

  @override
  State<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
  DoctorModel? _doctor;
  Future<DoctorModel>? _doctorFuture;

  @override
  void initState() {
    super.initState();
    _initDoctor();
  }

  void _initDoctor() {
    // 1. Direct model passed from navigation
    if (widget.extra is DoctorModel) {
      _doctor = widget.extra as DoctorModel;
      return;
    }
    if (widget.extra is Map<String, dynamic>) {
      _doctor = DoctorModel.fromJson(widget.extra as Map<String, dynamic>);
      return;
    }

    // 2. Check cached online DoctorsCubit
    final cubitDoc = sl<DoctorsCubit>().getDoctorById(widget.doctorId);
    if (cubitDoc != null) {
      _doctor = cubitDoc;
      return;
    }

    // 3. Fallback: Fetch remotely from Supabase repo if deep-linked
    _doctorFuture = _fetchRemoteDoctor();
  }

  Future<DoctorModel> _fetchRemoteDoctor() async {
    final repo = sl<DoctorRepo>();
    final result = await repo.getDoctorById(widget.doctorId);

    return result.fold(
      (failure) => throw Exception(failure.toString()),
      (doctor) => doctor,
    );
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
            child: _doctor != null
                ? DoctorDetailsAnimatedContent(
                    doctor: _doctor!,
                    doctorId: widget.doctorId,
                  )
                : FutureBuilder<DoctorModel>(
                    future: _doctorFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const DoctorDetailsShimmer();
                      }

                      if (snapshot.hasError ||
                          !snapshot.hasData ||
                          snapshot.data == null) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(24.r),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: palette.danger,
                                  size: 40.sp,
                                ),
                                Gaps.h12,
                                Text(
                                  t.errors.loadDoctor,
                                  style: context.regular14TextSub,
                                  textAlign: TextAlign.center,
                                ),
                                Gaps.h16,
                                ElevatedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      _doctorFuture = _fetchRemoteDoctor();
                                    });
                                  },
                                  icon: const Icon(Icons.refresh),
                                  label: Text(t.common.retry),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: palette.primary,
                                    foregroundColor: palette.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return DoctorDetailsAnimatedContent(
                        doctor: snapshot.data!,
                        doctorId: widget.doctorId,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
