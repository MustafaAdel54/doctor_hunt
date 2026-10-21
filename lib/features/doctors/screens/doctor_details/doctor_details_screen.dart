import 'package:doctor_hunt/core/di/injector.dart';
import 'package:doctor_hunt/features/doctors/cubit/doctors_cubit.dart';
import 'package:doctor_hunt/features/doctors/models/doctor_model.dart';
import 'package:doctor_hunt/features/doctors/repo/doctor_repo.dart';
import 'package:doctor_hunt/features/home/models/home_mock_data.dart';
import 'package:doctor_hunt/features/home/screens/popular_doctors/widgets/popular_doctors_background_glow.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';

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
    if (widget.extra is HomeDoctor) {
      _doctor = (widget.extra as HomeDoctor).toDoctorModel();
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

    // 3. Mock fallback by ID
    final allMock = [
      ...HomeMockData.popularDoctors,
      ...HomeMockData.featureDoctors,
    ];
    for (final d in allMock) {
      if (d.id == widget.doctorId) {
        _doctor = d.toDoctorModel();
        return;
      }
    }

    // 3. Fallback: Fetch remotely from Supabase repo if deep-linked
    _doctorFuture = _fetchRemoteDoctor();
  }

  Future<DoctorModel> _fetchRemoteDoctor() async {
    try {
      final repo = sl<DoctorRepo>();
      final result = await repo.getDoctorById(widget.doctorId);

      return result.fold(
        (failure) => _defaultDoctorModel(),
        (doctor) => doctor,
      );
    } catch (_) {
      return _defaultDoctorModel();
    }
  }

  DoctorModel _defaultDoctorModel() {
    return const DoctorModel(
      name: {'en': 'Dr. Pediatrician'},
      image: null,
      phone: '+1234567890',
      ratingSum: 200,
      ratingCount: 50,
      specialization: 'Specialist Cardiologist',
      yearsExperience: 7,
      patientsCount: 700,
      runningCount: 100,
      ongoingCount: 500,
      hourlyRate: 28.0,
      services: [
        'Patient care should be the number one priority.',
        'If you run your practice you know how frustrating.',
        "That's why some of appointment reminder system.",
      ],
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

                      if (snapshot.hasError || !snapshot.hasData) {
                        return Center(
                          child: Text(
                            t.errors.loadDoctor,
                            style: context.regular14TextSub,
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
