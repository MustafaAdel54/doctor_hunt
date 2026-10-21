import 'package:doctor_hunt/features/availability/models/availability_model.dart';
import 'package:doctor_hunt/features/availability/repo/slot_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SlotCalculator', () {
    // Reference date: Monday, 2026-10-26 (ISO weekday = 1)
    final mondayDate = DateTime.utc(2026, 10, 26);
    // Tuesday, 2026-10-27 (ISO weekday = 2)
    final tuesdayDate = DateTime.utc(2026, 10, 27);

    const standardAvailability = AvailabilityModel(
      doctorId: 'test-doctor-id',
      slotDurationMinutes: 30,
      days: [
        DayAvailability(
          weekday: 1, // Monday
          ranges: [
            TimeRange(start: '13:00', end: '17:00'),
            TimeRange(start: '17:00', end: '20:00'),
          ],
        ),
      ],
    );

    test('generates slots from valid availability matching doctor working ranges', () {
      final slots = SlotCalculator.generateSlotsForDate(
        date: mondayDate,
        availability: standardAvailability,
        now: DateTime.utc(2026, 10, 26, 8, 0), // Early morning before slots start
      );

      // 13:00 to 17:00 has 8 slots of 30 mins: 13:00, 13:30, 14:00, 14:30, 15:00, 15:30, 16:00, 16:30
      // 17:00 to 20:00 has 6 slots of 30 mins: 17:00, 17:30, 18:00, 18:30, 19:00, 19:30
      // Total = 14 slots
      expect(slots.length, 14);
      expect(slots.first.start, DateTime.utc(2026, 10, 26, 13, 0));
      expect(slots.first.end, DateTime.utc(2026, 10, 26, 13, 30));
      expect(slots.last.start, DateTime.utc(2026, 10, 26, 19, 30));
      expect(slots.last.end, DateTime.utc(2026, 10, 26, 20, 0));
      expect(slots.every((s) => s.isAvailable), isTrue);
    });

    test('returns empty list for a day where the doctor does not work', () {
      // tuesdayDate is weekday 2, but standardAvailability only configures weekday 1
      final slots = SlotCalculator.generateSlotsForDate(
        date: tuesdayDate,
        availability: standardAvailability,
      );

      expect(slots, isEmpty);
    });

    test('respects different slot durations (15 minutes and 60 minutes)', () {
      const availability15Min = AvailabilityModel(
        doctorId: 'test-doctor-id',
        slotDurationMinutes: 15,
        days: [
          DayAvailability(
            weekday: 1,
            ranges: [TimeRange(start: '09:00', end: '10:00')],
          ),
        ],
      );

      final slots15 = SlotCalculator.generateSlotsForDate(
        date: mondayDate,
        availability: availability15Min,
        now: DateTime.utc(2026, 10, 26, 7, 0),
      );

      expect(slots15.length, 4);
      expect(slots15[0].start, DateTime.utc(2026, 10, 26, 9, 0));
      expect(slots15[1].start, DateTime.utc(2026, 10, 26, 9, 15));
      expect(slots15[2].start, DateTime.utc(2026, 10, 26, 9, 30));
      expect(slots15[3].start, DateTime.utc(2026, 10, 26, 9, 45));

      const availability60Min = AvailabilityModel(
        doctorId: 'test-doctor-id',
        slotDurationMinutes: 60,
        days: [
          DayAvailability(
            weekday: 1,
            ranges: [TimeRange(start: '13:00', end: '17:00')],
          ),
        ],
      );

      final slots60 = SlotCalculator.generateSlotsForDate(
        date: mondayDate,
        availability: availability60Min,
        now: DateTime.utc(2026, 10, 26, 7, 0),
      );

      expect(slots60.length, 4);
      expect(slots60[0].start, DateTime.utc(2026, 10, 26, 13, 0));
      expect(slots60[1].start, DateTime.utc(2026, 10, 26, 14, 0));
      expect(slots60[2].start, DateTime.utc(2026, 10, 26, 15, 0));
      expect(slots60[3].start, DateTime.utc(2026, 10, 26, 16, 0));
    });

    test('handles empty and missing availability gracefully', () {
      const emptyAvailability = AvailabilityModel(
        doctorId: 'empty-doc',
        slotDurationMinutes: 30,
        days: [],
      );

      final slotsEmpty = SlotCalculator.generateSlotsForDate(
        date: mondayDate,
        availability: emptyAvailability,
      );
      expect(slotsEmpty, isEmpty);

      const emptyRangesAvailability = AvailabilityModel(
        doctorId: 'empty-ranges',
        slotDurationMinutes: 30,
        days: [DayAvailability(weekday: 1, ranges: [])],
      );

      final slotsEmptyRanges = SlotCalculator.generateSlotsForDate(
        date: mondayDate,
        availability: emptyRangesAvailability,
      );
      expect(slotsEmptyRanges, isEmpty);
    });

    test('filters out past slots when date is today', () {
      // Clock is at 14:15 UTC on the same Monday
      final nowUtc = DateTime.utc(2026, 10, 26, 14, 15);

      final allSlots = SlotCalculator.generateSlotsForDate(
        date: mondayDate,
        availability: standardAvailability,
        now: nowUtc,
      );

      // Total slots generated: 14
      expect(allSlots.length, 14);

      // Slots at 13:00, 13:30, 14:00 are in the past (isAvailable = false)
      expect(allSlots[0].isAvailable, isFalse); // 13:00
      expect(allSlots[1].isAvailable, isFalse); // 13:30
      expect(allSlots[2].isAvailable, isFalse); // 14:00

      // Slot at 14:30 and later are in the future (isAvailable = true)
      expect(allSlots[3].isAvailable, isTrue); // 14:30
      expect(allSlots[4].isAvailable, isTrue); // 15:00

      // getAvailableSlots returns only future slots (14 - 3 = 11)
      final availableSlots = SlotCalculator.getAvailableSlots(
        date: mondayDate,
        availability: standardAvailability,
        now: nowUtc,
      );

      expect(availableSlots.length, 11);
      expect(availableSlots.first.start, DateTime.utc(2026, 10, 26, 14, 30));
    });

    test('retains all slots for future dates even if clock time is late in the day', () {
      // Clock is late on Sunday: 2026-10-25 21:00 UTC
      final nowUtc = DateTime.utc(2026, 10, 25, 21, 0);

      // Querying Monday (tomorrow)
      final availableSlots = SlotCalculator.getAvailableSlots(
        date: mondayDate,
        availability: standardAvailability,
        now: nowUtc,
      );

      // All 14 slots remain available
      expect(availableSlots.length, 14);
      expect(availableSlots.first.start, DateTime.utc(2026, 10, 26, 13, 0));
    });

    test('excludes already-booked slots matching UTC start_time', () {
      // Slot at 15:00 and slot at 18:30 are booked
      final booked = [
        DateTime.utc(2026, 10, 26, 15, 0),
        DateTime.utc(2026, 10, 26, 18, 30),
      ];

      final allSlots = SlotCalculator.generateSlotsForDate(
        date: mondayDate,
        availability: standardAvailability,
        bookedSlots: booked,
        now: DateTime.utc(2026, 10, 26, 8, 0),
      );

      final slot1500 = allSlots.firstWhere(
        (s) => s.start == DateTime.utc(2026, 10, 26, 15, 0),
      );
      final slot1830 = allSlots.firstWhere(
        (s) => s.start == DateTime.utc(2026, 10, 26, 18, 30),
      );
      final slot1400 = allSlots.firstWhere(
        (s) => s.start == DateTime.utc(2026, 10, 26, 14, 0),
      );

      expect(slot1500.isAvailable, isFalse);
      expect(slot1830.isAvailable, isFalse);
      expect(slot1400.isAvailable, isTrue);

      final available = SlotCalculator.getAvailableSlots(
        date: mondayDate,
        availability: standardAvailability,
        bookedSlots: booked,
        now: DateTime.utc(2026, 10, 26, 8, 0),
      );

      expect(available.length, 12); // 14 - 2 booked = 12
      expect(available.any((s) => s.start == DateTime.utc(2026, 10, 26, 15, 0)), isFalse);
      expect(available.any((s) => s.start == DateTime.utc(2026, 10, 26, 18, 30)), isFalse);
    });

    test('partitions slots into morning, afternoon, and evening categories', () {
      const multiRangeAvailability = AvailabilityModel(
        doctorId: 'multi-doc',
        slotDurationMinutes: 60,
        days: [
          DayAvailability(
            weekday: 1,
            ranges: [
              TimeRange(start: '09:00', end: '11:00'), // Morning: 9:00, 10:00
              TimeRange(start: '13:00', end: '15:00'), // Afternoon: 1:00 PM, 2:00 PM
              TimeRange(start: '18:00', end: '20:00'), // Evening: 6:00 PM, 7:00 PM
            ],
          ),
        ],
      );

      final available = SlotCalculator.getAvailableSlots(
        date: mondayDate,
        availability: multiRangeAvailability,
        now: DateTime.utc(2026, 10, 26, 7, 0),
      );

      final partitioned = SlotCalculator.partitionSlots(available);

      expect(partitioned.morning, ['9:00 AM', '10:00 AM']);
      expect(partitioned.afternoon, ['1:00 PM', '2:00 PM']);
      expect(partitioned.evening, ['6:00 PM', '7:00 PM']);
    });
  });
}
