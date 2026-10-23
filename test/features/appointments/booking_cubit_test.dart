import 'package:dartz/dartz.dart';
import 'package:doctor_hunt/core/error/failures.dart';
import 'package:doctor_hunt/core/session/session_service.dart';
import 'package:doctor_hunt/features/appointments/cubit/booking_cubit.dart';
import 'package:doctor_hunt/features/appointments/models/appointment_model.dart';
import 'package:doctor_hunt/features/appointments/repo/appointment_repo.dart';
import 'package:doctor_hunt/features/availability/models/availability_model.dart';
import 'package:doctor_hunt/features/availability/repo/availability_repo.dart';
import 'package:doctor_hunt/features/doctors/models/doctor_model.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAppointmentRepo extends Mock implements AppointmentRepo {}

class MockAvailabilityRepo extends Mock implements AvailabilityRepo {}

class MockSessionService extends Mock implements SessionService {}

class FakeAppointmentModel extends Fake implements AppointmentModel {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeAppointmentModel());
    registerFallbackValue(DateTime.now());
  });

  group('BookingCubit', () {
    late MockAppointmentRepo appointmentRepo;
    late MockAvailabilityRepo availabilityRepo;
    late MockSessionService sessionService;
    late BookingCubit cubit;

    // Fixed test clock: Monday, 2026-10-26 08:00 UTC (ISO weekday 1)
    final fixedClock = DateTime.utc(2026, 10, 26, 8, 0);

    const testDoctor = DoctorModel(
      id: 'doctor-uuid-1',
      name: {'en': 'Dr. Test'},
      image: null,
      phone: '+1234567890',
      ratingSum: 100,
      ratingCount: 20,
      specialization: 'Cardiologist',
      yearsExperience: 5,
      patientsCount: 200,
      runningCount: 10,
      ongoingCount: 20,
      hourlyRate: 30,
      services: [],
    );

    const standardAvailability = AvailabilityModel(
      doctorId: 'doctor-uuid-1',
      slotDurationMinutes: 30,
      days: [
        DayAvailability(
          weekday: 1, // Monday
          ranges: [
            TimeRange(start: '13:00', end: '17:00'),
            TimeRange(start: '17:00', end: '20:00'),
          ],
        ),
        DayAvailability(
          weekday: 2, // Tuesday
          ranges: [
            TimeRange(start: '13:00', end: '17:00'),
          ],
        ),
      ],
    );

    setUp(() {
      appointmentRepo = MockAppointmentRepo();
      availabilityRepo = MockAvailabilityRepo();
      sessionService = MockSessionService();

      when(() => sessionService.currentUserId).thenReturn('test-patient-id');
      when(() => sessionService.currentUser).thenReturn(null);

      cubit = BookingCubit(
        appointmentRepo: appointmentRepo,
        availabilityRepo: availabilityRepo,
        sessionService: sessionService,
        clock: () => fixedClock,
      );
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state does not contain hardcoded slots', () {
      expect(cubit.state.afternoonSlots, isEmpty);
      expect(cubit.state.eveningSlots, isEmpty);
      expect(cubit.state.morningSlots, isEmpty);
      expect(cubit.state.selectedSlot, isNull);
      expect(cubit.state.isLoadingSlots, isFalse);
      expect(cubit.state.isLoadingAvailability, isFalse);
    });

    test('initDoctor loads availability, computes date tabs, and loads slots for the date', () async {
      when(() => availabilityRepo.getDoctorAvailability('doctor-uuid-1'))
          .thenAnswer((_) async => const Right(standardAvailability));

      when(() => appointmentRepo.getBookedSlots(any(), any()))
          .thenAnswer((_) async => const Right([]));

      await cubit.initDoctor('doctor-uuid-1');

      // Monday 2026-10-26 should be selected because it has slots
      expect(cubit.state.isLoadingAvailability, isFalse);
      expect(cubit.state.isLoadingSlots, isFalse);
      expect(cubit.state.selectedDate, DateTime.utc(2026, 10, 26));

      // Afternoon slots: 13:00 to 17:00 (8 slots)
      expect(cubit.state.afternoonSlots.length, 8);
      expect(cubit.state.afternoonSlots.first, '1:00 PM');
      expect(cubit.state.afternoonSlots.last, '4:30 PM');

      // Evening slots: 17:00 to 20:00 (6 slots)
      expect(cubit.state.eveningSlots.length, 6);
      expect(cubit.state.eveningSlots.first, '5:00 PM');
      expect(cubit.state.eveningSlots.last, '7:30 PM');

      // First available slot is selected by default
      expect(cubit.state.selectedSlot, '1:00 PM');
    });

    test('initDoctor handles doctor with no configured availability', () async {
      const emptyAvailability = AvailabilityModel(
        doctorId: 'doctor-uuid-1',
        slotDurationMinutes: 30,
        days: [],
      );

      when(() => availabilityRepo.getDoctorAvailability('doctor-uuid-1'))
          .thenAnswer((_) async => const Right(emptyAvailability));

      when(() => appointmentRepo.getBookedSlots(any(), any()))
          .thenAnswer((_) async => const Right([]));

      await cubit.initDoctor('doctor-uuid-1');

      expect(cubit.state.isLoadingAvailability, isFalse);
      expect(cubit.state.hasSlotsOnSelectedDate, isFalse);
      expect(cubit.state.afternoonSlots, isEmpty);
      expect(cubit.state.eveningSlots, isEmpty);
      expect(cubit.state.selectedSlot, isNull);
    });

    test('initDoctor handles availability fetch failure', () async {
      when(() => availabilityRepo.getDoctorAvailability('doctor-uuid-1'))
          .thenAnswer((_) async => const Left(ServerFailure()));

      await cubit.initDoctor('doctor-uuid-1');

      expect(cubit.state.isLoadingAvailability, isFalse);
      expect(cubit.state.isLoadingSlots, isFalse);
      expect(cubit.state.errorMessage, isNotNull);
    });

    test('selectDate updates selectedDate and loads slots for the new date', () async {
      when(() => availabilityRepo.getDoctorAvailability('doctor-uuid-1'))
          .thenAnswer((_) async => const Right(standardAvailability));

      when(() => appointmentRepo.getBookedSlots(any(), any()))
          .thenAnswer((_) async => const Right([]));

      await cubit.initDoctor('doctor-uuid-1');

      // Select Tuesday, 2026-10-27
      final tuesday = DateTime.utc(2026, 10, 27);
      cubit.selectDate(tuesday);

      await pumpEventQueue();

      expect(cubit.state.selectedDate, tuesday);
      // Tuesday only has afternoon range 13:00 to 17:00 (8 slots)
      expect(cubit.state.afternoonSlots.length, 8);
      expect(cubit.state.eveningSlots, isEmpty);
      expect(cubit.state.selectedSlot, '1:00 PM');
    });

    test('selectDate handles booked slots retrieval failure gracefully', () async {
      when(() => availabilityRepo.getDoctorAvailability('doctor-uuid-1'))
          .thenAnswer((_) async => const Right(standardAvailability));

      when(() => appointmentRepo.getBookedSlots('doctor-uuid-1', any()))
          .thenAnswer((_) async => const Right([]));

      await cubit.initDoctor('doctor-uuid-1');

      // Now Tuesday getBookedSlots fails
      final tuesday = DateTime.utc(2026, 10, 27);
      when(() => appointmentRepo.getBookedSlots('doctor-uuid-1', tuesday))
          .thenAnswer((_) async => const Left(ServerFailure()));

      cubit.selectDate(tuesday);
      await pumpEventQueue();

      expect(cubit.state.isLoadingSlots, isFalse);
      expect(cubit.state.errorMessage, t.errors.server);
    });

    test('selectDate avoids redundant network calls when re-selecting the current date', () async {
      when(() => availabilityRepo.getDoctorAvailability('doctor-uuid-1'))
          .thenAnswer((_) async => const Right(standardAvailability));

      when(() => appointmentRepo.getBookedSlots(any(), any()))
          .thenAnswer((_) async => const Right([]));

      await cubit.initDoctor('doctor-uuid-1');
      final monday = DateTime.utc(2026, 10, 26);
      expect(cubit.state.selectedDate, monday);

      // Clear interaction history for booked slots
      clearInteractions(appointmentRepo);

      // Re-selecting the already selected date
      cubit.selectDate(monday);
      await pumpEventQueue();

      verifyNever(() => appointmentRepo.getBookedSlots(any(), any()));
    });

    test('selectSlot selects a valid slot and ignores booked slots', () async {
      when(() => availabilityRepo.getDoctorAvailability('doctor-uuid-1'))
          .thenAnswer((_) async => const Right(standardAvailability));

      // Book 2:00 PM (14:00 UTC)
      when(() => appointmentRepo.getBookedSlots(any(), any()))
          .thenAnswer((_) async => Right([DateTime.utc(2026, 10, 26, 14, 0)]));

      await cubit.initDoctor('doctor-uuid-1');

      // 2:00 PM is booked, so it is in bookedSlots and excluded from available afternoonSlots
      expect(cubit.state.isSlotBooked('2:00 PM'), isTrue);

      // Attempt to select 2:00 PM
      cubit.selectSlot('2:00 PM');
      // Selection should remain unchanged (default was '1:00 PM')
      expect(cubit.state.selectedSlot, '1:00 PM');

      // Selecting an available slot succeeds
      cubit.selectSlot('3:00 PM');
      expect(cubit.state.selectedSlot, '3:00 PM');
    });

    test('confirmBooking succeeds and emits isSuccess with booked appointment', () async {
      when(() => availabilityRepo.getDoctorAvailability('doctor-uuid-1'))
          .thenAnswer((_) async => const Right(standardAvailability));

      when(() => appointmentRepo.getBookedSlots(any(), any()))
          .thenAnswer((_) async => const Right([]));

      final confirmedAppt = AppointmentModel(
        id: 'new-appt-123',
        patientId: 'test-patient-id',
        doctorId: 'doctor-uuid-1',
        doctorName: testDoctor.name,
        status: 'pending',
        startTime: DateTime.utc(2026, 10, 26, 13, 0),
        patientName: 'Patient',
      );

      when(() => appointmentRepo.bookAppointment(any()))
          .thenAnswer((_) async => Right(confirmedAppt));

      await cubit.initDoctor('doctor-uuid-1');

      await cubit.confirmBooking(
        doctor: testDoctor,
        doctorId: 'doctor-uuid-1',
      );

      expect(cubit.state.isBooking, isFalse);
      expect(cubit.state.isSuccess, isTrue);
      expect(cubit.state.bookedAppointment, confirmedAppt);
      expect(cubit.state.bookedSlots.contains('1:00 PM'), isTrue);
    });

    test('confirmBooking handles SlotTakenFailure gracefully by showing error and refreshing slots', () async {
      when(() => availabilityRepo.getDoctorAvailability('doctor-uuid-1'))
          .thenAnswer((_) async => const Right(standardAvailability));

      when(() => appointmentRepo.getBookedSlots(any(), any()))
          .thenAnswer((_) async => const Right([]));

      // Simulate concurrent booking failure: another user booked the slot first
      when(() => appointmentRepo.bookAppointment(any()))
          .thenAnswer((_) async => const Left(SlotTakenFailure()));

      await cubit.initDoctor('doctor-uuid-1');

      // Booking the slot fails with SlotTakenFailure
      await cubit.confirmBooking(
        doctor: testDoctor,
        doctorId: 'doctor-uuid-1',
      );

      expect(cubit.state.isBooking, isFalse);
      expect(cubit.state.isSuccess, isFalse);
      expect(cubit.state.errorMessage, t.errors.slotTaken);
      expect(cubit.state.selectedSlot, isNull);

      // Verify booked slots were re-queried to refresh frontend display
      verify(() => appointmentRepo.getBookedSlots('doctor-uuid-1', DateTime.utc(2026, 10, 26))).called(greaterThanOrEqualTo(2));
    });

    test('confirmBooking prevents duplicate submissions when isBooking is true', () async {
      when(() => availabilityRepo.getDoctorAvailability('doctor-uuid-1'))
          .thenAnswer((_) async => const Right(standardAvailability));

      when(() => appointmentRepo.getBookedSlots(any(), any()))
          .thenAnswer((_) async => const Right([]));

      final confirmedAppt = AppointmentModel(
        id: 'new-appt-123',
        patientId: 'test-patient-id',
        doctorId: 'doctor-uuid-1',
        doctorName: testDoctor.name,
        status: 'pending',
        startTime: DateTime.utc(2026, 10, 26, 13, 0),
        patientName: 'Patient',
      );

      when(() => appointmentRepo.bookAppointment(any()))
          .thenAnswer((_) async {
            await Future.delayed(const Duration(milliseconds: 100));
            return Right(confirmedAppt);
          });

      await cubit.initDoctor('doctor-uuid-1');

      // Launch first booking
      final future1 = cubit.confirmBooking(
        doctor: testDoctor,
        doctorId: 'doctor-uuid-1',
      );

      // Instantly trigger a second booking while isBooking is true
      final future2 = cubit.confirmBooking(
        doctor: testDoctor,
        doctorId: 'doctor-uuid-1',
      );

      await Future.wait([future1, future2]);

      // bookAppointment should only have been called ONCE
      verify(() => appointmentRepo.bookAppointment(any())).called(1);
    });

    test('confirmBooking validates that a slot is selected', () async {
      when(() => availabilityRepo.getDoctorAvailability('doctor-uuid-1'))
          .thenAnswer((_) async => const Right(AvailabilityModel(
                doctorId: 'doctor-uuid-1',
                slotDurationMinutes: 30,
                days: [],
              )));

      when(() => appointmentRepo.getBookedSlots(any(), any()))
          .thenAnswer((_) async => const Right([]));

      await cubit.initDoctor('doctor-uuid-1');

      // No slot selected
      expect(cubit.state.selectedSlot, isNull);

      await cubit.confirmBooking(
        doctor: testDoctor,
        doctorId: 'doctor-uuid-1',
      );

      expect(cubit.state.errorMessage, t.appointments.selectSlotPrompt);
      verifyNever(() => appointmentRepo.bookAppointment(any()));
    });
  });
}
