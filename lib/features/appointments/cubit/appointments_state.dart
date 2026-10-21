import 'package:doctor_hunt/features/appointments/models/appointment_model.dart';
import 'package:equatable/equatable.dart';

enum AppointmentTab {
  upcoming,
  completed,
  cancelled,
}

class AppointmentsState extends Equatable {
  final AppointmentTab selectedTab;
  final List<AppointmentModel> appointments;
  final bool isLoading;
  final String? cancellingAppointmentId;
  final String? errorMessage;

  const AppointmentsState({
    this.selectedTab = AppointmentTab.upcoming,
    this.appointments = const [],
    this.isLoading = false,
    this.cancellingAppointmentId,
    this.errorMessage,
  });

  List<AppointmentModel> get upcomingAppointments {
    final list = appointments
        .where((a) => a.status == 'pending' || a.status == 'confirmed')
        .toList();
    list.sort((a, b) => a.startTime.compareTo(b.startTime));
    return list;
  }

  List<AppointmentModel> get completedAppointments {
    final list = appointments
        .where((a) => a.status == 'completed')
        .toList();
    list.sort((a, b) => b.startTime.compareTo(a.startTime));
    return list;
  }

  List<AppointmentModel> get cancelledAppointments {
    final list = appointments
        .where((a) => a.status == 'cancelled')
        .toList();
    list.sort((a, b) {
      final aTime = a.cancelledAt ?? a.createdAt;
      final bTime = b.cancelledAt ?? b.createdAt;
      if (aTime != null && bTime != null) {
        final cmp = bTime.compareTo(aTime); // Latest cancelled first
        if (cmp != 0) return cmp;
      }
      if (aTime != null) return -1;
      if (bTime != null) return 1;
      return b.startTime.compareTo(a.startTime);
    });
    return list;
  }

  List<AppointmentModel> get currentTabAppointments {
    switch (selectedTab) {
      case AppointmentTab.upcoming:
        return upcomingAppointments;
      case AppointmentTab.completed:
        return completedAppointments;
      case AppointmentTab.cancelled:
        return cancelledAppointments;
    }
  }

  AppointmentsState copyWith({
    AppointmentTab? selectedTab,
    List<AppointmentModel>? appointments,
    bool? isLoading,
    String? cancellingAppointmentId,
    bool clearCancellingId = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AppointmentsState(
      selectedTab: selectedTab ?? this.selectedTab,
      appointments: appointments ?? this.appointments,
      isLoading: isLoading ?? this.isLoading,
      cancellingAppointmentId: clearCancellingId
          ? null
          : (cancellingAppointmentId ?? this.cancellingAppointmentId),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        selectedTab,
        appointments,
        isLoading,
        cancellingAppointmentId,
        errorMessage,
      ];
}
