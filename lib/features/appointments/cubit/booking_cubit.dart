import 'package:doctor_hunt/core/error/failures.dart';
import 'package:doctor_hunt/core/session/session_service.dart';
import 'package:doctor_hunt/features/appointments/cubit/appointments_cubit.dart';
import 'package:doctor_hunt/features/appointments/models/appointment_model.dart';
import 'package:doctor_hunt/features/appointments/repo/appointment_repo.dart';
import 'package:doctor_hunt/features/doctors/models/doctor_model.dart';
import 'package:doctor_hunt/features/home/models/home_mock_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final AppointmentRepo repo;
  final SessionService sessionService;
  String? _currentDoctorId;

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
      selectedSlot: '2:00 PM',
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

  void initDoctor(String doctorId) {
    _currentDoctorId = HomeMockData.getRealDoctorId(doctorId);
    loadBookedSlots(_currentDoctorId!, state.selectedDate);
  }

  Future<void> loadBookedSlots(String doctorId, DateTime date) async {
    final realDoctorId = HomeMockData.getRealDoctorId(doctorId);
    emit(state.copyWith(isLoadingSlots: true));

    final result = await repo.getBookedSlots(realDoctorId, date);
    result.fold(
      (_) {
        if (!isClosed) emit(state.copyWith(isLoadingSlots: false));
      },
      (bookedTimes) {
        if (!isClosed) {
          final bookedSet = bookedTimes
              .map((dt) => DateFormat('h:mm a', 'en_US').format(dt))
              .toSet();

          String? newSelected = state.selectedSlot;
          if (newSelected != null && bookedSet.contains(newSelected)) {
            // Find first available slot
            final allSlots = [...state.afternoonSlots, ...state.eveningSlots];
            newSelected = allSlots.where((s) => !bookedSet.contains(s)).firstOrNull;
          }

          final updatedDates = state.availableDates.map((item) {
            if (item.date.year == date.year &&
                item.date.month == date.month &&
                item.date.day == date.day) {
              final total = state.afternoonSlots.length + state.eveningSlots.length;
              final remaining = (total - bookedSet.length).clamp(0, total);
              return BookingDateItem(
                date: item.date,
                slotsCount: remaining,
                label: item.label,
              );
            }
            return item;
          }).toList();

          emit(state.copyWith(
            bookedSlots: bookedSet,
            selectedSlot: newSelected,
            clearSelectedSlot: newSelected == null,
            availableDates: updatedDates,
            isLoadingSlots: false,
          ));
        }
      },
    );
  }

  void selectDate(DateTime date, {String? doctorId}) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final isToday = date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;

    final docId = doctorId ?? _currentDoctorId;

    if (isToday) {
      // Empty state per Figma 1:671
      emit(state.copyWith(
        selectedDate: date,
        clearSelectedSlot: true,
        afternoonSlots: const [],
        eveningSlots: const [],
        bookedSlots: const {},
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

      if (docId != null && docId.isNotEmpty) {
        loadBookedSlots(docId, date);
      }
    }
  }

  void selectSlot(String slot) {
    if (state.isSlotBooked(slot)) return;
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

    if (state.isSlotBooked(state.selectedSlot!)) {
      emit(state.copyWith(
        errorMessage: 'This slot is already booked. Please choose another slot.',
      ));
      return;
    }

    emit(state.copyWith(isBooking: true, clearError: true));

    final realDoctorId = HomeMockData.getRealDoctorId(
      doctorId.isNotEmpty ? doctorId : doctor.id,
    );
    final parsedTime = _parseSlotTime(state.selectedDate, state.selectedSlot!);
    final patientId = sessionService.currentUserId ?? 'guest_patient';
    final patientName =
        (sessionService.currentUser?.userMetadata?['name'] as String?) ??
            'Patient';

    final appointment = AppointmentModel(
      id: '',
      patientId: patientId,
      doctorId: realDoctorId,
      doctorName: doctor.name,
      status: 'pending',
      startTime: parsedTime,
      patientName: patientName,
      notes: notes ?? 'Consultation booking',
    );

    final start = DateTime.now();
    final result = await repo.bookAppointment(appointment);
    final elapsed = DateTime.now().difference(start);
    if (elapsed.inMilliseconds < 800) {
      await Future.delayed(
        Duration(milliseconds: 800 - elapsed.inMilliseconds),
      );
    }

    result.fold(
      (failure) {
        if (!isClosed) {
          final msg = failure is SlotTakenFailure
              ? 'This time slot was just booked by another user. Please choose another.'
              : failure is NetworkFailure
                  ? 'No internet connection. Please check your network and try again.'
                  : 'Failed to book appointment. Please try again.';
          emit(state.copyWith(
            isBooking: false,
            errorMessage: msg,
          ));
          loadBookedSlots(realDoctorId, state.selectedDate);
        }
      },
      (booked) {
        if (!isClosed) {
          final updatedBooked = Set<String>.from(state.bookedSlots)
            ..add(state.selectedSlot!);
          emit(state.copyWith(
            isBooking: false,
            isSuccess: true,
            bookedAppointment: booked,
            bookedSlots: updatedBooked,
          ));

          // Immediately push to AppointmentsCubit so it is available without refreshing
          if (GetIt.instance.isRegistered<AppointmentsCubit>()) {
            final apptCubit = GetIt.instance<AppointmentsCubit>();
            apptCubit.addAppointment(booked);
            apptCubit.refreshAppointments();
          }
        }
      },
    );
  }

  DateTime _parseSlotTime(DateTime date, String slot) {
    try {
      final format = DateFormat('h:mm a', 'en_US');
      final time = format.parse(slot);
      return DateTime.utc(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    } catch (_) {
      return DateTime.utc(date.year, date.month, date.day, 14, 0);
    }
  }
}
