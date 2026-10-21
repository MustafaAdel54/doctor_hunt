import 'package:doctor_hunt/features/appointments/models/appointment_model.dart';
import 'package:equatable/equatable.dart';

class BookingDateItem extends Equatable {
  final DateTime date;
  final int slotsCount;
  final String label;

  const BookingDateItem({
    required this.date,
    required this.slotsCount,
    required this.label,
  });

  bool get hasSlots => slotsCount > 0;

  BookingDateItem copyWith({
    DateTime? date,
    int? slotsCount,
    String? label,
  }) {
    return BookingDateItem(
      date: date ?? this.date,
      slotsCount: slotsCount ?? this.slotsCount,
      label: label ?? this.label,
    );
  }

  @override
  List<Object?> get props => [date, slotsCount, label];
}

class BookingState extends Equatable {
  final DateTime selectedDate;
  final String? selectedSlot;
  final List<BookingDateItem> availableDates;
  final List<String> morningSlots;
  final List<String> afternoonSlots;
  final List<String> eveningSlots;
  final Set<String> bookedSlots;
  final bool isLoadingAvailability;
  final bool isLoadingSlots;
  final bool isBooking;
  final bool isSuccess;
  final AppointmentModel? bookedAppointment;
  final String? errorMessage;

  const BookingState({
    required this.selectedDate,
    this.selectedSlot,
    this.availableDates = const [],
    this.morningSlots = const [],
    this.afternoonSlots = const [],
    this.eveningSlots = const [],
    this.bookedSlots = const {},
    this.isLoadingAvailability = false,
    this.isLoadingSlots = false,
    this.isBooking = false,
    this.isSuccess = false,
    this.bookedAppointment,
    this.errorMessage,
  });

  bool get hasSlotsOnSelectedDate {
    return morningSlots.isNotEmpty ||
        afternoonSlots.isNotEmpty ||
        eveningSlots.isNotEmpty;
  }

  int get totalAvailableSlotsOnSelectedDate {
    return morningSlots.length + afternoonSlots.length + eveningSlots.length;
  }

  bool isSlotBooked(String slot) => bookedSlots.contains(slot);

  BookingState copyWith({
    DateTime? selectedDate,
    String? selectedSlot,
    bool clearSelectedSlot = false,
    List<BookingDateItem>? availableDates,
    List<String>? morningSlots,
    List<String>? afternoonSlots,
    List<String>? eveningSlots,
    Set<String>? bookedSlots,
    bool? isLoadingAvailability,
    bool? isLoadingSlots,
    bool? isBooking,
    bool? isSuccess,
    AppointmentModel? bookedAppointment,
    String? errorMessage,
    bool clearError = false,
  }) {
    return BookingState(
      selectedDate: selectedDate ?? this.selectedDate,
      selectedSlot:
          clearSelectedSlot ? null : (selectedSlot ?? this.selectedSlot),
      availableDates: availableDates ?? this.availableDates,
      morningSlots: morningSlots ?? this.morningSlots,
      afternoonSlots: afternoonSlots ?? this.afternoonSlots,
      eveningSlots: eveningSlots ?? this.eveningSlots,
      bookedSlots: bookedSlots ?? this.bookedSlots,
      isLoadingAvailability:
          isLoadingAvailability ?? this.isLoadingAvailability,
      isLoadingSlots: isLoadingSlots ?? this.isLoadingSlots,
      isBooking: isBooking ?? this.isBooking,
      isSuccess: isSuccess ?? this.isSuccess,
      bookedAppointment: bookedAppointment ?? this.bookedAppointment,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        selectedDate,
        selectedSlot,
        availableDates,
        morningSlots,
        afternoonSlots,
        eveningSlots,
        bookedSlots,
        isLoadingAvailability,
        isLoadingSlots,
        isBooking,
        isSuccess,
        bookedAppointment,
        errorMessage,
      ];
}
