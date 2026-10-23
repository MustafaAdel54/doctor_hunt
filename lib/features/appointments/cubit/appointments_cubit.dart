import 'package:doctor_hunt/core/error/failures.dart';
import 'package:doctor_hunt/core/session/session_service.dart';
import 'package:doctor_hunt/features/appointments/models/appointment_model.dart';
import 'package:doctor_hunt/features/appointments/repo/appointment_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'appointments_state.dart';

class AppointmentsCubit extends Cubit<AppointmentsState> {
  final AppointmentRepo repo;
  final SessionService sessionService;

  AppointmentsCubit({
    required this.repo,
    required this.sessionService,
  }) : super(const AppointmentsState()) {
    loadAppointments();
  }

  Future<void> loadAppointments({bool isSilent = false}) async {
    if (!isSilent) {
      emit(state.copyWith(isLoading: true, clearError: true));
    }

    final patientId = sessionService.currentUserId;
    if (patientId == null || patientId.isEmpty) {
      if (!isClosed) {
        emit(state.copyWith(
          isLoading: false,
          appointments: const [],
          errorMessage: 'unauthenticated',
        ));
      }
      return;
    }

    final result = await repo.getPatientAppointments(patientId);

    result.fold(
      (failure) {
        if (!isClosed) {
          emit(state.copyWith(
            isLoading: false,
            errorMessage: failure is NetworkFailure ? 'network' : 'server',
          ));
        }
      },
      (list) {
        if (!isClosed) {
          emit(state.copyWith(
            appointments: list,
            isLoading: false,
            clearError: true,
          ));
        }
      },
    );
  }

  void switchTab(AppointmentTab tab) {
    if (state.selectedTab == tab) return;
    emit(state.copyWith(selectedTab: tab, clearError: true));
  }

  Future<bool> cancelAppointment(String appointmentId) async {
    emit(state.copyWith(
      cancellingAppointmentId: appointmentId,
      clearError: true,
    ));

    final result = await repo.updateStatus(appointmentId, 'cancelled');

    return result.fold(
      (failure) {
        if (!isClosed) {
          emit(state.copyWith(
            clearCancellingId: true,
            errorMessage: failure is NetworkFailure ? 'network' : 'server',
          ));
        }
        return false;
      },
      (_) {
        if (!isClosed) {
          // Optimistically update status to cancelled
          final updated = state.appointments.map((appt) {
            if (appt.id == appointmentId) {
              return appt.copyWith(
                status: 'cancelled',
                cancelledAt: DateTime.now(),
              );
            }
            return appt;
          }).toList();

          emit(state.copyWith(
            appointments: updated,
            clearCancellingId: true,
            clearError: true,
          ));
        }
        return true;
      },
    );
  }

  void addAppointment(AppointmentModel appointment) {
    if (state.appointments.any((a) => a.id == appointment.id)) return;
    final updated = [appointment, ...state.appointments];
    emit(state.copyWith(
      appointments: updated,
      selectedTab: AppointmentTab.upcoming,
      clearError: true,
    ));
  }

  void updateAppointmentRating(String appointmentId, int rating, String? comment) {
    final updated = state.appointments.map((appt) {
      if (appt.id == appointmentId) {
        return appt.copyWith(rating: rating, reviewComment: comment);
      }
      return appt;
    }).toList();

    emit(state.copyWith(appointments: updated));
  }

  Future<void> refreshAppointments() => loadAppointments(isSilent: true);
}
