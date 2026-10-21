import 'package:doctor_hunt/core/router/routes.dart';
import 'package:doctor_hunt/features/appointments/cubit/appointments_cubit.dart';
import 'package:doctor_hunt/features/appointments/cubit/appointments_state.dart';
import 'package:doctor_hunt/features/appointments/models/appointment_model.dart';
import 'package:doctor_hunt/features/doctors/cubit/doctors_cubit.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import 'appointment_card_actions.dart';
import 'appointment_details_bottom_sheet.dart';
import 'appointment_doctor_header.dart';
import 'appointment_rating_bar.dart';
import 'appointment_schedule_info.dart';
import 'cancel_appointment_dialog.dart';

class AppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;
  final AppointmentTab tab;

  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.tab,
  });

  Future<void> _onRateDoctor(BuildContext context) async {
    final rated = await context.pushNamed<bool>(
      Routes.rateDoctor,
      pathParameters: {'appointmentId': appointment.id},
      extra: appointment,
    );

    if (rated == true && context.mounted) {
      await context.read<AppointmentsCubit>().refreshAppointments();
      if (GetIt.instance.isRegistered<DoctorsCubit>()) {
        GetIt.instance<DoctorsCubit>().refresh();
      }
    }
  }

  void _onViewDetails(BuildContext context) {
    AppointmentDetailsBottomSheet.show(context, appointment);
  }

  void _onCancel(BuildContext context) {
    CancelAppointmentDialog.show(
      context,
      onConfirm: () {
        context.read<AppointmentsCubit>().cancelAppointment(appointment.id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final doctor =
        GetIt.instance<DoctorsCubit>().getDoctorById(appointment.doctorId);

    final isCompleted =
        appointment.status == 'completed' || tab == AppointmentTab.completed;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      padding: EdgeInsets.all(12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Doctor avatar, name, specialty, and status badge
          AppointmentDoctorHeader(
            appointment: appointment,
            tab: tab,
            doctor: doctor,
          ),

          SizedBox(height: 10.h),
          Divider(color: palette.textBorders.withValues(alpha: 0.3), height: 1, thickness: 1),
          SizedBox(height: 10.h),

          // Date, time, and fee details
          AppointmentScheduleInfo(
            appointment: appointment,
            doctor: doctor,
          ),

          // Completed Tab: Rating display or prompt
          if (isCompleted) ...[
            SizedBox(height: 10.h),
            AppointmentRatingBar(
              appointment: appointment,
              onTap: () => _onRateDoctor(context),
            ),
          ],

          SizedBox(height: 12.h),

          // Action buttons per tab
          AppointmentCardActions(
            appointment: appointment,
            tab: tab,
            onViewDetails: () => _onViewDetails(context),
            onCancel: () => _onCancel(context),
            onRate: () => _onRateDoctor(context),
          ),
        ],
      ),
    );
  }
}
