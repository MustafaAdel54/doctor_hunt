import 'package:doctor_hunt/core/session/session_service.dart';
import 'package:doctor_hunt/features/appointments/models/appointment_model.dart';
import 'package:doctor_hunt/features/appointments/repo/appointment_repo.dart';
import 'package:doctor_hunt/features/doctors/models/doctor_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final AppointmentRepo repo;
  final SessionService sessionService;

  BookingCubit({
    required this.repo,
    required this.sessionService,
  }) : super(_initialState());

  static BookingState _initialState() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    final dates = _generateDates(today);

    // Initial selected date is tomorrow (has slots available per Figma 1:741)
    final afternoon = [
      '1:00 PM',
      '1:30 PM',
      '2:00 PM',
      '2:30 PM',
      '3:00 PM',
      '3:30 PM',
      '4:00 PM',
    ];
    final evening = [
      '5:00 PM',
      '5:30 PM',
      '6:00 PM',
      '6:30 PM',
      '7:00 PM',
    ];

    return BookingState(
      selectedDate: tomorrow,
      selectedSlot: '2:00 PM', // Default selected slot matching Figma
      availableDates: dates,
      afternoonSlots: afternoon,
      eveningSlots: evening,
    );
  }

  static List<BookingDateItem> _generateDates(DateTime today) {
    final dates = <BookingDateItem>[];

    // Today (0 slots - Figma 1:671)
    dates.add(BookingDateItem(
      date: today,
      slotsCount: 0,
      label: 'Today, ${DateFormat('d MMM').format(today)}',
    ));

    // Tomorrow (12 slots - Figma 1:741)
    final tomorrow = today.add(const Duration(days: 1));
    dates.add(BookingDateItem(
      date: tomorrow,
      slotsCount: 12,
      label: 'Tomorrow, ${DateFormat('d MMM').format(tomorrow)}',
    ));

    // Next 5 days
    for (int i = 2; i <= 6; i++) {
      final nextDay = today.add(Duration(days: i));
      final weekdayName = DateFormat('EEE').format(nextDay);
      final dayMonth = DateFormat('d MMM').format(nextDay);
      dates.add(BookingDateItem(
        date: nextDay,
        slotsCount: i % 2 == 0 ? 10 : 8,
        label: '$weekdayName, $dayMonth',
      ));
    }

    return dates;
  }

  void selectDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final isToday = date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;

    if (isToday) {
      // Empty state per Figma 1:671
      emit(state.copyWith(
        selectedDate: date,
        clearSelectedSlot: true,
        afternoonSlots: const [],
        eveningSlots: const [],
        clearError: true,
      ));
    } else {
      // Available slots per Figma 1:741
      final afternoon = [
        '1:00 PM',
        '1:30 PM',
        '2:00 PM',
        '2:30 PM',
        '3:00 PM',
        '3:30 PM',
        '4:00 PM',
      ];
      final evening = [
        '5:00 PM',
        '5:30 PM',
        '6:00 PM',
        '6:30 PM',
        '7:00 PM',
      ];

      emit(state.copyWith(
        selectedDate: date,
        selectedSlot: state.selectedSlot ?? '2:00 PM',
        afternoonSlots: afternoon,
        eveningSlots: evening,
        clearError: true,
      ));
    }
  }

  void selectSlot(String slot) {
    emit(state.copyWith(
      selectedSlot: slot,
      clearError: true,
    ));
  }

  Future<void> confirmBooking({
    required DoctorModel doctor,
    required String doctorId,
    String? notes,
  }) async {
    if (state.selectedSlot == null) {
      emit(state.copyWith(errorMessage: 'Please select a time slot'));
      return;
    }

    emit(state.copyWith(isBooking: true, clearError: true));

    final parsedTime = _parseSlotTime(state.selectedDate, state.selectedSlot!);
    final patientId = sessionService.currentUserId ?? 'guest_patient';
    final patientName = (sessionService.currentUser?.userMetadata?['name'] as String?) ?? 'Patient';

    final appointment = AppointmentModel(
      id: '',
      patientId: patientId,
      doctorId: doctorId,
      doctorName: doctor.name,
      status: 'pending',
      startTime: parsedTime,
      patientName: patientName,
      notes: notes ?? 'Consultation booking',
    );

    final result = await repo.bookAppointment(appointment);

    result.fold(
      (failure) {
        if (!isClosed) {
          emit(state.copyWith(
            isBooking: false,
            errorMessage: 'Failed to book appointment. Please try again.',
          ));
        }
      },
      (booked) {
        if (!isClosed) {
          emit(state.copyWith(
            isBooking: false,
            isSuccess: true,
            bookedAppointment: booked,
          ));
        }
      },
    );
  }

  DateTime _parseSlotTime(DateTime date, String slot) {
    try {
      // slot is e.g. "2:00 PM"
      final format = DateFormat('h:mm a');
      final time = format.parse(slot);
      return DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    } catch (_) {
      return DateTime(date.year, date.month, date.day, 14, 0);
    }
  }
}
