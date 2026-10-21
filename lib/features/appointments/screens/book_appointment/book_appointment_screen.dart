import 'package:doctor_hunt/core/di/injector.dart';
import 'package:doctor_hunt/features/appointments/cubit/booking_cubit.dart';
import 'package:doctor_hunt/features/appointments/cubit/booking_state.dart';
import 'package:doctor_hunt/features/doctors/models/doctor_model.dart';
import 'package:doctor_hunt/features/home/models/home_mock_data.dart';
import 'package:doctor_hunt/features/home/screens/popular_doctors/widgets/popular_doctors_background_glow.dart';
import 'package:doctor_hunt/shared/generated/app_colors.dart';
import 'package:doctor_hunt/shared/generated/image_assets.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'widgets/booking_date_tabs.dart';
import 'widgets/booking_doctor_card.dart';
import 'widgets/booking_empty_slots.dart';
import 'widgets/booking_slots_view.dart';
import 'widgets/thank_you_dialog.dart';

class BookAppointmentScreen extends StatefulWidget {
  final String doctorId;
  final Object? extra;

  const BookAppointmentScreen({
    super.key,
    required this.doctorId,
    this.extra,
  });

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  late DoctorModel _doctor;

  @override
  void initState() {
    super.initState();
    _initDoctor();
  }

  void _initDoctor() {
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

    // Fallback: search HomeMockData
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

    // Default Doctor per Figma (Dr. Shruti Kedia)
    _doctor = const DoctorModel(
      name: {'en': 'Dr. Shruti Kedia', 'ar': 'د. شروتي كيديا'},
      image: null,
      phone: '+1234567890',
      ratingSum: 160,
      ratingCount: 40,
      specialization: 'Upasana Dental Clinic, salt lake',
      yearsExperience: 5,
      patientsCount: 500,
      runningCount: 80,
      ongoingCount: 300,
      hourlyRate: 28.0,
      services: [],
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final locale = Localizations.localeOf(context).languageCode;
    final doctorName = _doctor.name[locale] ?? _doctor.name.values.firstOrNull ?? 'Doctor';

    return BlocProvider(
      create: (_) => sl<BookingCubit>(),
      child: BlocConsumer<BookingCubit, BookingState>(
        listenWhen: (prev, curr) =>
            prev.isSuccess != curr.isSuccess ||
            prev.errorMessage != curr.errorMessage,
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: palette.danger,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }

          if (state.isSuccess) {
            final formattedDate = DateFormat('MMMM d').format(state.selectedDate);
            final formattedTime = state.selectedSlot ?? '02:00 PM';

            ThankYouDialog.show(
              context,
              doctorName: doctorName,
              formattedDate: formattedDate,
              formattedTime: formattedTime,
            );
          }
        },
        builder: (context, state) {
          final isToday = _isToday(state.selectedDate);
          final isTomorrow = _isTomorrow(state.selectedDate);

          final dateHeading = isToday
              ? '${t.appointments.today}, ${DateFormat('d MMM').format(state.selectedDate)}'
              : isTomorrow
                  ? '${t.appointments.tomorrow}, ${DateFormat('d MMM').format(state.selectedDate)}'
                  : DateFormat('EEE, d MMM').format(state.selectedDate);

          final canConfirm = state.hasSlotsOnSelectedDate && state.selectedSlot != null;

          return Scaffold(
            backgroundColor: palette.surface,
            body: Stack(
              children: [
                const PopularDoctorsBackgroundGlow(),
                SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header (Back button + "Select Time" title)
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 12.h,
                        ),
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
                                child: SvgPicture.asset(
                                  ImageAssets.backArrow,
                                  width: 30.w,
                                  height: 30.h,
                                ),
                              ),
                            ),
                            SizedBox(width: 20.w),
                            Text(
                              t.appointments.selectTime,
                              style: context.medium18TextMain,
                            ),
                          ],
                        ),
                      ),

                      // Compact Doctor Card
                      BookingDoctorCard(
                        doctor: _doctor,
                        doctorId: widget.doctorId,
                      ),

                      SizedBox(height: 10.h),

                      // Horizontal Date Tabs
                      const BookingDateTabs(),

                      SizedBox(height: 10.h),

                      // Slots or Empty State Content
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: state.hasSlotsOnSelectedDate
                              ? BookingSlotsView(dateHeading: dateHeading)
                              : BookingEmptySlots(dateHeading: dateHeading),
                        ),
                      ),

                      // Bottom Confirm Button (Figma 1:741)
                      if (state.hasSlotsOnSelectedDate)
                        Padding(
                          padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
                          child: SizedBox(
                            width: double.infinity,
                            height: 54.h,
                            child: ElevatedButton(
                              onPressed: canConfirm && !state.isBooking
                                  ? () {
                                      context.read<BookingCubit>().confirmBooking(
                                            doctor: _doctor,
                                            doctorId: widget.doctorId,
                                          );
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: FigmaRaw.green500,
                                disabledBackgroundColor:
                                    FigmaRaw.green500.withValues(alpha: 0.5),
                                foregroundColor: FigmaRaw.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                elevation: 0,
                              ),
                              child: state.isBooking
                                  ? SizedBox(
                                      width: 24.w,
                                      height: 24.w,
                                      child: const CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : Text(
                                      t.appointments.confirm,
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w500,
                                        color: FigmaRaw.white,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  bool _isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }
}
