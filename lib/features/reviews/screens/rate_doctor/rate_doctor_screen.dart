import 'package:doctor_hunt/core/di/injector.dart';
import 'package:doctor_hunt/core/session/session_service.dart';
import 'package:doctor_hunt/features/appointments/models/appointment_model.dart';
import 'package:doctor_hunt/features/appointments/repo/appointment_repo.dart';
import 'package:doctor_hunt/features/home/screens/popular_doctors/widgets/popular_doctors_background_glow.dart';
import 'package:doctor_hunt/features/reviews/models/review_model.dart';
import 'package:doctor_hunt/features/reviews/repo/review_repo.dart';
import 'package:doctor_hunt/shared/generated/app_colors.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'widgets/rate_doctor_header.dart';
import 'widgets/star_rating_selector.dart';

class RateDoctorScreen extends StatefulWidget {
  final String appointmentId;
  final AppointmentModel? appointment;

  const RateDoctorScreen({
    super.key,
    required this.appointmentId,
    this.appointment,
  });

  @override
  State<RateDoctorScreen> createState() => _RateDoctorScreenState();
}

class _RateDoctorScreenState extends State<RateDoctorScreen> {
  late int _selectedRating;
  late final TextEditingController _commentController;
  bool _isSubmitting = false;
  AppointmentModel? _appointment;
  bool _isLoadingAppointment = false;

  @override
  void initState() {
    super.initState();
    _selectedRating = widget.appointment?.rating ?? 5;
    _commentController = TextEditingController(
      text: widget.appointment?.reviewComment ?? '',
    );
    _appointment = widget.appointment;

    if (_appointment == null) {
      _isLoadingAppointment = true;
      _fetchAppointment();
    }
  }

  Future<void> _fetchAppointment() async {
    try {
      final session = sl<SessionService>();
      final patientId = session.currentUserId;
      if (patientId == null || patientId.isEmpty) {
        if (mounted) setState(() => _isLoadingAppointment = false);
        return;
      }
      final repo = sl<AppointmentRepo>();
      final result = await repo.getPatientAppointments(patientId);
      final list = result.getOrElse(() => []);
      final found =
          list.where((a) => a.id == widget.appointmentId).firstOrNull;

      if (mounted) {
        setState(() {
          _appointment = found;
          if (found != null) {
            if (found.rating != null) {
              _selectedRating = found.rating!;
            }
            if (found.reviewComment != null && _commentController.text.isEmpty) {
              _commentController.text = found.reviewComment!;
            }
          }
          _isLoadingAppointment = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoadingAppointment = false);
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    final session = sl<SessionService>();
    final doctorId = _appointment?.doctorId ?? '';
    final patientId = session.currentUserId ?? _appointment?.patientId;
    if (patientId == null || patientId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.errors.auth.unknown),
          backgroundColor: context.palette.danger,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    final patientName = (session.currentUser?.userMetadata?['name'] as String?) ??
        _appointment?.patientName ??
        'Patient';

    setState(() => _isSubmitting = true);

    final review = ReviewModel(
      id: '',
      appointmentId: widget.appointmentId,
      patientId: patientId,
      doctorId: doctorId,
      rating: _selectedRating,
      comment: _commentController.text.trim().isNotEmpty
          ? _commentController.text.trim()
          : null,
      createdAt: DateTime.now(),
      patientName: patientName,
    );

    final repo = sl<ReviewRepo>();
    final result = await repo.addReview(review);

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.errors.server),
            backgroundColor: context.palette.danger,
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.appointments.reviewSubmitted),
            backgroundColor: FigmaRaw.green500,
            behavior: SnackBarBehavior.floating,
          ),
        );
        if (context.canPop()) {
          context.pop(true);
        }
      },
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
            child: _isLoadingAppointment
                ? const Center(
                    child: CircularProgressIndicator(color: FigmaRaw.green500),
                  )
                : SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Doctor info & back button
                        RateDoctorHeader(appointment: _appointment),

                        SizedBox(height: 32.h),

                        Text(
                          t.appointments.howWasYourExperience,
                          style: context.medium16TextMain,
                        ),
                        SizedBox(height: 14.h),

                        // Interactive Star Rating
                        StarRatingSelector(
                          rating: _selectedRating,
                          onRatingChanged: (newRating) {
                            setState(() => _selectedRating = newRating);
                          },
                        ),

                        SizedBox(height: 32.h),

                        // Comment Field
                        TextField(
                          controller: _commentController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: t.appointments.writeReviewHint,
                            hintStyle: context.regular14TextSub.copyWith(
                              color: palette.textSub.withValues(alpha: 0.6),
                            ),
                            filled: true,
                            fillColor: palette.surface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide(
                                color: palette.textBorders,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide(
                                color: palette.textBorders,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: const BorderSide(
                                color: FigmaRaw.green500,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 32.h),

                        // Submit Button
                        SizedBox(
                          width: double.infinity,
                          height: 52.h,
                          child: ElevatedButton(
                            onPressed: _isSubmitting ? null : _submitReview,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: FigmaRaw.green500,
                              foregroundColor: FigmaRaw.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                            ),
                            child: _isSubmitting
                                ? SizedBox(
                                    width: 22.w,
                                    height: 22.w,
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : Text(
                                    t.common.confirm,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: FigmaRaw.white,
                                    ),
                                  ),
                          ),
                        ),

                        SizedBox(height: 40.h),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
