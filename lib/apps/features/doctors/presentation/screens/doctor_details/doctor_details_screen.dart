import 'package:doctor_hunt/apps/core/di/injector.dart';
import 'package:doctor_hunt/apps/features/doctors/data/models/doctor_model.dart';
import 'package:doctor_hunt/apps/features/doctors/data/repo/doctor_repo.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';
import 'package:flutter/material.dart';

import 'widgets/doctor_details_header.dart';
import 'widgets/doctor_details_shimmer.dart';
import 'widgets/doctor_profile_card.dart';
import 'widgets/doctor_services_list.dart';
import 'widgets/doctor_stats_row.dart';

class DoctorDetailsScreen extends StatefulWidget {
  final String doctorId;

  const DoctorDetailsScreen({super.key, required this.doctorId});

  @override
  State<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen>
    with SingleTickerProviderStateMixin {
  late Future<DoctorModel> _doctorFuture;

  @override
  void initState() {
    super.initState();
    _doctorFuture = _fetchDoctor();
  }

  Future<DoctorModel> _fetchDoctor() async {
    // Artificial delay to show shimmer animation
    await Future.delayed(const Duration(seconds: 1));

    final repo = sl<DoctorRepo>();
    final result = await repo.getDoctorById(widget.doctorId);

    return result.fold((failure) {
      // Fallback to dummy data if not in Firestore yet
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
          'That\'s why some of appointment reminder system.',
        ],
      );
    }, (doctor) => doctor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              context.palette.primaryLight, // Light cyan
              context.palette.white,
            ],
            stops: const [0.0, 0.3],
          ),
        ),
        child: SafeArea(
          child: FutureBuilder<DoctorModel>(
            future: _doctorFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const DoctorDetailsShimmer();
              }

              if (snapshot.hasError) {
                return const Center(child: Text('Error loading doctor details'));
              }

              final doctor = snapshot.data!;

              return _AnimatedContent(
                doctor: doctor,
                doctorId: widget.doctorId,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _AnimatedContent extends StatelessWidget {
  final DoctorModel doctor;
  final String doctorId;

  const _AnimatedContent({required this.doctor, required this.doctorId});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DoctorDetailsHeader(),

              // Profile Card animates in slightly later/faster
              Transform.translate(
                offset: Offset(0, 30 * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: DoctorProfileCard(doctor: doctor, doctorId: doctorId),
                ),
              ),

              const SizedBox(height: 20),

              Transform.translate(
                offset: Offset(0, 40 * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: DoctorStatsRow(doctor: doctor),
                ),
              ),

              const SizedBox(height: 30),

              Transform.translate(
                offset: Offset(0, 50 * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: DoctorServicesList(doctor: doctor),
                ),
              ),

              const SizedBox(height: 30),

              Transform.translate(
                offset: Offset(0, 60 * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        color: context.palette.surfaceAlt,
                        // Placeholder for Map
                        child: Center(
                          child: Icon(
                            Icons.map,
                            size: 60,
                            color: context.palette.textPlaceholder,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }
}
