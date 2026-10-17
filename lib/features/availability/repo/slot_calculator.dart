import 'package:doctor_hunt/features/appointments/models/appointment_model.dart';
import 'package:doctor_hunt/features/availability/models/availability_model.dart';

abstract final class SlotCalculator {
  static List<TimeSlot> calculate(
    DateTime date,
    AvailabilityModel availability,
    List<AppointmentModel> existingAppointments,
  ) {
    final dayAvailability = availability.days
        .where((d) => d.weekday == date.weekday)
        .firstOrNull;
    if (dayAvailability == null) return [];

    final slots = <TimeSlot>[];
    final duration = Duration(minutes: availability.slotDurationMinutes);

    for (final range in dayAvailability.ranges) {
      final partsStart = range.start.split(':');
      final partsEnd = range.end.split(':');

      var current = DateTime(
        date.year,
        date.month,
        date.day,
        int.parse(partsStart[0]),
        int.parse(partsStart[1]),
      );

      final end = DateTime(
        date.year,
        date.month,
        date.day,
        int.parse(partsEnd[0]),
        int.parse(partsEnd[1]),
      );

      while (current.add(duration).isBefore(end) ||
          current.add(duration).isAtSameMomentAs(end)) {
        final slotEnd = current.add(duration);

        final isAvailable = !existingAppointments.any((app) {
          if (app.status == 'cancelled') return false;
          // if appointment overlaps with this slot
          return app.startTime.isBefore(slotEnd) &&
              (app.startTime.add(duration)).isAfter(current);
        });

        slots.add(
          TimeSlot(start: current, end: slotEnd, isAvailable: isAvailable),
        );

        current = slotEnd;
      }
    }

    return slots;
  }
}
