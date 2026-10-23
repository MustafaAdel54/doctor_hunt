import 'package:doctor_hunt/core/error/failures.dart';
import 'package:doctor_hunt/core/session/session_service.dart';
import 'package:doctor_hunt/features/appointments/models/appointment_model.dart';
import 'package:doctor_hunt/features/appointments/repo/appointment_repo.dart';
import 'package:doctor_hunt/features/availability/models/availability_model.dart';
import 'package:doctor_hunt/features/availability/repo/availability_repo.dart';
import 'package:doctor_hunt/features/availability/repo/slot_calculator.dart';
import 'package:doctor_hunt/features/doctors/models/doctor_model.dart';
import 'package:doctor_hunt/features/home/models/home_mock_data.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final AppointmentRepo appointmentRepo;
  final AvailabilityRepo availabilityRepo;
  final SessionService sessionService;
  final DateTime Function() _clock;

  String? _currentDoctorId;
  AvailabilityModel? _availability;

  BookingCubit({
    required this.appointmentRepo,
    required this.availabilityRepo,
    required this.sessionService,
    DateTime Function()? clock,
  })  : _clock = clock ?? DateTime.now,
        super(_createInitialState(clock ?? DateTime.now));

  DateTime get _nowUtc => _clock().toUtc();

  static BookingState _createInitialState(DateTime Function() clock) {
    final nowUtc = clock().toUtc();
    final todayUtc = DateTime.utc(nowUtc.year, nowUtc.month, nowUtc.day);
    final tomorrowUtc = todayUtc.add(const Duration(days: 1));

    final initialDates = _generateInitialDates(todayUtc);

    return BookingState(
      selectedDate: tomorrowUtc,
      availableDates: initialDates,
    );
  }

  static List<BookingDateItem> _generateInitialDates(DateTime todayUtc) {
    final dates = <BookingDateItem>[];

    // Today
    dates.add(BookingDateItem(
      date: todayUtc,
      slotsCount: 0,
      label: 'Today, ${DateFormat('d MMM').format(todayUtc)}',
    ));

    // Tomorrow
    final tomorrowUtc = todayUtc.add(const Duration(days: 1));
    dates.add(BookingDateItem(
      date: tomorrowUtc,
      slotsCount: 0,
      label: 'Tomorrow, ${DateFormat('d MMM').format(tomorrowUtc)}',
    ));

    // Next 5 days (total 7 days)
    for (int i = 2; i <= 6; i++) {
      final nextDay = todayUtc.add(Duration(days: i));
      final weekday = DateFormat('EEE').format(nextDay);
      final dayMonth = DateFormat('d MMM').format(nextDay);
      dates.add(BookingDateItem(
        date: nextDay,
        slotsCount: 0,
        label: '$weekday, $dayMonth',
      ));
    }

    return dates;
  }

  /// Initializes booking flow for [doctorId]. Loads doctor's weekly availability
  /// from Supabase and sets up dynamic slot schedule.
  Future<void> initDoctor(String doctorId) async {
    final realDoctorId = HomeMockData.getRealDoctorId(doctorId);
    _currentDoctorId = realDoctorId;

    emit(state.copyWith(
      isLoadingAvailability: true,
      isLoadingSlots: true,
      clearError: true,
    ));

    final result = await availabilityRepo.getDoctorAvailability(realDoctorId);

    if (isClosed) return;

    await result.fold(
      (failure) async {
        final message = failure is NetworkFailure
            ? t.errors.network
            : t.appointments.loadAvailabilityError;
        emit(state.copyWith(
          isLoadingAvailability: false,
          isLoadingSlots: false,
          errorMessage: message,
        ));
      },
      (availability) async {
        _availability = availability;

        final now = _nowUtc;
        final todayUtc = DateTime.utc(now.year, now.month, now.day);
        final dateTabs = _buildDateTabs(todayUtc, availability);

        // Pick initial selected date:
        // If today has available slots, start with today.
        // Otherwise, prefer tomorrow (matching Figma standard flow) or first day with slots.
        DateTime chosenDate = state.selectedDate;
        final todayItem = dateTabs.firstOrNull;
        final tomorrowItem =
            dateTabs.length > 1 ? dateTabs[1] : null;

        if (todayItem != null && todayItem.hasSlots) {
          chosenDate = todayItem.date;
        } else if (tomorrowItem != null && tomorrowItem.hasSlots) {
          chosenDate = tomorrowItem.date;
        } else {
          final firstWithSlots =
              dateTabs.where((d) => d.hasSlots).firstOrNull;
          if (firstWithSlots != null) {
            chosenDate = firstWithSlots.date;
          } else {
            chosenDate = tomorrowItem?.date ?? todayUtc;
          }
        }

        emit(state.copyWith(
          isLoadingAvailability: false,
          availableDates: dateTabs,
          selectedDate: chosenDate,
        ));

        // Load slots for the selected date
        await _loadSlotsForDate(chosenDate);

        // In parallel, prefetch booked slots for the remaining days so tab counters are exact
        _prefetchRemainingDaysBookedSlots(realDoctorId, availability, chosenDate);
      },
    );
  }

  List<BookingDateItem> _buildDateTabs(
    DateTime todayUtc,
    AvailabilityModel availability,
  ) {
    final tabs = <BookingDateItem>[];

    for (int i = 0; i < 7; i++) {
      final date = todayUtc.add(Duration(days: i));
      final potentialSlots = SlotCalculator.getAvailableSlots(
        date: date,
        availability: availability,
        bookedSlots: const [],
        now: _nowUtc,
      );

      final label = i == 0
          ? 'Today, ${DateFormat('d MMM').format(date)}'
          : i == 1
              ? 'Tomorrow, ${DateFormat('d MMM').format(date)}'
              : '${DateFormat('EEE').format(date)}, ${DateFormat('d MMM').format(date)}';

      tabs.add(BookingDateItem(
        date: date,
        slotsCount: potentialSlots.length,
        label: label,
      ));
    }

    return tabs;
  }

  Future<void> _prefetchRemainingDaysBookedSlots(
    String doctorId,
    AvailabilityModel availability,
    DateTime selectedDate,
  ) async {
    final remainingDates = state.availableDates
        .where((item) => !_isSameDay(item.date, selectedDate) && item.hasSlots)
        .toList();

    if (remainingDates.isEmpty) return;

    final futures = remainingDates.map((item) async {
      final res = await appointmentRepo.getBookedSlots(doctorId, item.date);
      return res.fold(
        (_) => item,
        (bookedTimes) {
          final available = SlotCalculator.getAvailableSlots(
            date: item.date,
            availability: availability,
            bookedSlots: bookedTimes,
            now: _nowUtc,
          );
          return item.copyWith(slotsCount: available.length);
        },
      );
    });

    final updatedItems = await Future.wait(futures);

    if (isClosed) return;

    final map = {for (final item in updatedItems) item.date: item};
    final updatedList = state.availableDates.map((item) {
      return map[item.date] ?? item;
    }).toList();

    emit(state.copyWith(availableDates: updatedList));
  }

  /// Selects a date and refreshes the slots for that date.
  void selectDate(DateTime date) {
    final utcDate = DateTime.utc(date.year, date.month, date.day);

    if (_isSameDay(state.selectedDate, utcDate) &&
        !state.isLoadingSlots &&
        state.hasSlotsOnSelectedDate) {
      return;
    }

    if (_availability == null && _currentDoctorId != null) {
      initDoctor(_currentDoctorId!);
      return;
    }

    _loadSlotsForDate(utcDate);
  }

  Future<void> _loadSlotsForDate(
    DateTime utcDate, {
    bool keepError = false,
  }) async {
    final doctorId = _currentDoctorId;
    if (doctorId == null || _availability == null) return;

    emit(state.copyWith(
      selectedDate: utcDate,
      isLoadingSlots: true,
      clearSelectedSlot: true,
      clearError: !keepError,
    ));

    final result = await appointmentRepo.getBookedSlots(doctorId, utcDate);

    if (isClosed) return;

    result.fold(
      (failure) {
        emit(state.copyWith(
          isLoadingSlots: false,
          errorMessage: failure is NetworkFailure
              ? t.errors.network
              : t.errors.server,
        ));
      },
      (bookedTimes) {
        final bookedSet = bookedTimes
            .map((dt) => DateFormat('h:mm a', 'en_US').format(dt.toUtc()))
            .toSet();

        final availableSlots = SlotCalculator.getAvailableSlots(
          date: utcDate,
          availability: _availability!,
          bookedSlots: bookedTimes,
          now: _nowUtc,
        );

        final partitioned = SlotCalculator.partitionSlots(availableSlots);

        // Automatically select the first available slot if one exists
        final allAvailableStrings = [
          ...partitioned.morning,
          ...partitioned.afternoon,
          ...partitioned.evening,
        ];
        final defaultSelection = allAvailableStrings.firstOrNull;

        // Update slotsCount in the tab for this date
        final updatedDates = state.availableDates.map((item) {
          if (_isSameDay(item.date, utcDate)) {
            return item.copyWith(slotsCount: availableSlots.length);
          }
          return item;
        }).toList();

        emit(state.copyWith(
          selectedDate: utcDate,
          selectedSlot: defaultSelection,
          clearSelectedSlot: defaultSelection == null,
          morningSlots: partitioned.morning,
          afternoonSlots: partitioned.afternoon,
          eveningSlots: partitioned.evening,
          bookedSlots: bookedSet,
          availableDates: updatedDates,
          isLoadingSlots: false,
          clearError: !keepError,
        ));
      },
    );
  }

  /// Selects a specific slot string (e.g. '2:00 PM').
  void selectSlot(String slot) {
    if (state.isSlotBooked(slot)) return;

    final allAvailable = [
      ...state.morningSlots,
      ...state.afternoonSlots,
      ...state.eveningSlots,
    ];

    if (!allAvailable.contains(slot)) return;

    emit(state.copyWith(
      selectedSlot: slot,
      clearError: true,
    ));
  }

  /// Submits the appointment booking request to Supabase.
  Future<void> confirmBooking({
    required DoctorModel doctor,
    required String doctorId,
    String? notes,
  }) async {
    // Prevent duplicate submissions
    if (state.isBooking) return;

    if (state.selectedSlot == null) {
      emit(state.copyWith(errorMessage: t.appointments.selectSlotPrompt));
      return;
    }

    if (state.isSlotBooked(state.selectedSlot!)) {
      emit(state.copyWith(errorMessage: t.errors.slotTaken));
      return;
    }

    emit(state.copyWith(isBooking: true, clearError: true));

    final realDoctorId = _currentDoctorId ??
        HomeMockData.getRealDoctorId(
          doctorId.isNotEmpty ? doctorId : doctor.id,
        );

    final parsedTimeUtc =
        _parseSlotTimeToUtc(state.selectedDate, state.selectedSlot!);
    final patientId = sessionService.currentUserId;
    if (patientId == null || patientId.isEmpty) {
      emit(state.copyWith(
        isBooking: false,
        errorMessage: t.errors.auth.unknown,
      ));
      return;
    }

    final patientName =
        (sessionService.currentUser?.userMetadata?['name'] as String?) ??
            'Patient';

    final appointment = AppointmentModel(
      id: '',
      patientId: patientId,
      doctorId: realDoctorId,
      doctorName: doctor.name,
      status: 'pending',
      startTime: parsedTimeUtc,
      patientName: patientName,
      notes: notes ?? 'Consultation booking',
    );

    final startTime = DateTime.now();
    final result = await appointmentRepo.bookAppointment(appointment);
    final elapsed = DateTime.now().difference(startTime);

    if (elapsed.inMilliseconds < 600) {
      await Future.delayed(
        Duration(milliseconds: 600 - elapsed.inMilliseconds),
      );
    }

    if (isClosed) return;

    result.fold(
      (failure) {
        if (failure is SlotTakenFailure) {
          emit(state.copyWith(
            isBooking: false,
            errorMessage: t.errors.slotTaken,
            clearSelectedSlot: true,
          ));
          // Refresh slots while preserving the slot-taken error message
          _loadSlotsForDate(state.selectedDate, keepError: true);
        } else if (failure is NetworkFailure) {
          emit(state.copyWith(
            isBooking: false,
            errorMessage: t.errors.network,
          ));
        } else {
          emit(state.copyWith(
            isBooking: false,
            errorMessage: t.errors.server,
          ));
        }
      },
      (booked) {
        final updatedBooked = Set<String>.from(state.bookedSlots)
          ..add(state.selectedSlot!);

        emit(state.copyWith(
          isBooking: false,
          isSuccess: true,
          bookedAppointment: booked,
          bookedSlots: updatedBooked,
        ));
      },
    );
  }

  /// Retries loading availability or slots.
  void retry() {
    if (_currentDoctorId != null) {
      if (_availability == null) {
        initDoctor(_currentDoctorId!);
      } else {
        _loadSlotsForDate(state.selectedDate);
      }
    }
  }

  DateTime _parseSlotTimeToUtc(DateTime date, String slot) {
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
      return DateTime.utc(date.year, date.month, date.day, 12, 0);
    }
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
