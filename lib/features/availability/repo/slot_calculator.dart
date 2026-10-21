import 'package:doctor_hunt/features/appointments/models/appointment_model.dart';
import 'package:doctor_hunt/features/availability/models/availability_model.dart';
import 'package:intl/intl.dart';

abstract final class SlotCalculator {
  /// Core slot generation method for a specific date in UTC.
  /// Generates all valid time slots based on the doctor's weekly availability,
  /// respecting slot_duration_minutes, filtering out past slots (if [now] is provided
  /// or using UTC current time), and checking against [bookedSlots].
  static List<TimeSlot> generateSlotsForDate({
    required DateTime date,
    required AvailabilityModel availability,
    List<DateTime> bookedSlots = const [],
    DateTime? now,
  }) {
    if (availability.days.isEmpty) return const [];

    // Normalize date to UTC
    final utcDate = DateTime.utc(date.year, date.month, date.day);
    final weekday = utcDate.weekday; // 1 = Monday, 7 = Sunday (ISO 8601)

    final dayAvailability = availability.days
        .where((d) => d.weekday == weekday)
        .firstOrNull;
    if (dayAvailability == null || dayAvailability.ranges.isEmpty) {
      return const [];
    }

    final durationMinutes = availability.slotDurationMinutes > 0
        ? availability.slotDurationMinutes
        : 30;
    final duration = Duration(minutes: durationMinutes);
    final effectiveNow = (now ?? DateTime.now()).toUtc();

    // Map booked slots to UTC
    final bookedSet = bookedSlots.map((b) => b.toUtc()).toSet();

    final slots = <TimeSlot>[];

    for (final range in dayAvailability.ranges) {
      final partsStart = range.start.split(':');
      final partsEnd = range.end.split(':');
      if (partsStart.length < 2 || partsEnd.length < 2) continue;

      final startH = int.tryParse(partsStart[0]);
      final startM = int.tryParse(partsStart[1]);
      final endH = int.tryParse(partsEnd[0]);
      final endM = int.tryParse(partsEnd[1]);

      if (startH == null || startM == null || endH == null || endM == null) {
        continue;
      }

      var current = DateTime.utc(
        utcDate.year,
        utcDate.month,
        utcDate.day,
        startH,
        startM,
      );

      final end = DateTime.utc(
        utcDate.year,
        utcDate.month,
        utcDate.day,
        endH,
        endM,
      );

      while (current.add(duration).isBefore(end) ||
          current.add(duration).isAtSameMomentAs(end)) {
        final slotEnd = current.add(duration);

        // A slot is past if its start time is not in the future relative to effectiveNow
        final isPast = !current.isAfter(effectiveNow);
        final isBooked = bookedSet.any((b) => b.isAtSameMomentAs(current));
        final isAvailable = !isPast && !isBooked;

        slots.add(TimeSlot(
          start: current,
          end: slotEnd,
          isAvailable: isAvailable,
        ));

        current = slotEnd;
      }
    }

    return slots;
  }

  /// Returns only slots that are available (not in the past, not booked).
  static List<TimeSlot> getAvailableSlots({
    required DateTime date,
    required AvailabilityModel availability,
    List<DateTime> bookedSlots = const [],
    DateTime? now,
  }) {
    return generateSlotsForDate(
      date: date,
      availability: availability,
      bookedSlots: bookedSlots,
      now: now,
    ).where((s) => s.isAvailable).toList();
  }

  /// Partitions slots into Morning (< 12:00), Afternoon (12:00..16:59),
  /// and Evening (>= 17:00) formatted strings.
  static ({
    List<String> morning,
    List<String> afternoon,
    List<String> evening,
  }) partitionSlots(List<TimeSlot> slots) {
    final morning = <String>[];
    final afternoon = <String>[];
    final evening = <String>[];

    for (final slot in slots) {
      final label = DateFormat('h:mm a', 'en_US').format(slot.start);
      if (slot.start.hour < 12) {
        morning.add(label);
      } else if (slot.start.hour < 17) {
        afternoon.add(label);
      } else {
        evening.add(label);
      }
    }

    return (morning: morning, afternoon: afternoon, evening: evening);
  }

  /// Legacy compatibility method for AvailabilityRepoImpl.
  static List<TimeSlot> calculate(
    DateTime date,
    AvailabilityModel availability,
    List<AppointmentModel> existingAppointments, {
    DateTime? now,
  }) {
    final booked = existingAppointments
        .where((a) => a.status != 'cancelled')
        .map((a) => a.startTime)
        .toList();
    return generateSlotsForDate(
      date: date,
      availability: availability,
      bookedSlots: booked,
      now: now,
    );
  }
}
