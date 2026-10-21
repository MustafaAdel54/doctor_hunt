import 'package:doctor_hunt/features/appointments/cubit/appointments_cubit.dart';
import 'package:doctor_hunt/features/appointments/cubit/appointments_state.dart';
import 'package:doctor_hunt/features/appointments/models/appointment_model.dart';
import 'package:doctor_hunt/shared/generated/app_colors.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppointmentCardActions extends StatelessWidget {
  final AppointmentModel appointment;
  final AppointmentTab tab;
  final VoidCallback onViewDetails;
  final VoidCallback onCancel;
  final VoidCallback onRate;

  const AppointmentCardActions({
    super.key,
    required this.appointment,
    required this.tab,
    required this.onViewDetails,
    required this.onCancel,
    required this.onRate,
  });

  @override
  Widget build(BuildContext context) {
    if (tab == AppointmentTab.upcoming) {
      return BlocBuilder<AppointmentsCubit, AppointmentsState>(
        buildWhen: (prev, curr) =>
            prev.cancellingAppointmentId != curr.cancellingAppointmentId,
        builder: (context, state) {
          final isCancellingThis =
              state.cancellingAppointmentId == appointment.id;

          return Row(
            children: [
              Expanded(
                child: _buildDetailsButton(onPressed: onViewDetails),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: SizedBox(
                  height: 36.h,
                  child: OutlinedButton(
                    onPressed: isCancellingThis ? null : onCancel,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFF0F0),
                      side: const BorderSide(
                        color: Color(0xFFF15B5D),
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: isCancellingThis
                        ? SizedBox(
                            width: 16.w,
                            height: 16.w,
                            child: const CircularProgressIndicator(
                              color: Color(0xFFF15B5D),
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            t.appointments.cancelAppointment,
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFFF15B5D),
                            ),
                          ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    if (tab == AppointmentTab.completed) {
      final isRated = appointment.rating != null && appointment.rating! > 0;

      return Row(
        children: [
          Expanded(
            child: _buildDetailsButton(onPressed: onViewDetails),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: SizedBox(
              height: 36.h,
              child: isRated
                  ? OutlinedButton(
                      onPressed: onRate,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: FigmaRaw.green500,
                          width: 1,
                        ),
                        backgroundColor: const Color(0xFFE8F8F3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_outline_rounded,
                            size: 14.sp,
                            color: FigmaRaw.green500,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            t.appointments.editReview,
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                              color: FigmaRaw.green500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ElevatedButton(
                      onPressed: onRate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: FigmaRaw.green500,
                        foregroundColor: FigmaRaw.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        t.appointments.rateDoctor,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                          color: FigmaRaw.white,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      );
    }

    // Cancelled Tab: Full-width Details Button
    return SizedBox(
      width: double.infinity,
      child: _buildDetailsButton(onPressed: onViewDetails),
    );
  }

  Widget _buildDetailsButton({required VoidCallback onPressed}) {
    return SizedBox(
      height: 36.h,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: FigmaRaw.green500, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.r),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Text(
          t.appointments.viewDetails,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
            color: FigmaRaw.green500,
          ),
        ),
      ),
    );
  }
}
