import 'package:dartz/dartz.dart';
import 'package:doctor_hunt/core/error/failures.dart';
import 'package:doctor_hunt/core/session/session_service.dart';
import 'package:doctor_hunt/features/appointments/cubit/appointments_cubit.dart';
import 'package:doctor_hunt/features/appointments/cubit/appointments_state.dart';
import 'package:doctor_hunt/features/appointments/models/appointment_model.dart';
import 'package:doctor_hunt/features/appointments/repo/appointment_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAppointmentRepo extends Mock implements AppointmentRepo {}
class MockSessionService extends Mock implements SessionService {}

void main() {
  late MockAppointmentRepo mockRepo;
  late MockSessionService mockSessionService;

  final now = DateTime.utc(2026, 10, 26, 10, 0);

  final apptUpcoming1 = AppointmentModel(
    id: 'u-1',
    patientId: 'patient-123',
    doctorId: 'doc-1',
    doctorName: const {'en': 'Dr. First'},
    status: 'confirmed',
    startTime: now.add(const Duration(days: 2)),
    createdAt: now.subtract(const Duration(days: 1)),
  );

  final apptUpcoming2 = AppointmentModel(
    id: 'u-2',
    patientId: 'patient-123',
    doctorId: 'doc-2',
    doctorName: const {'en': 'Dr. Earlier'},
    status: 'pending',
    startTime: now.add(const Duration(days: 1)),
    createdAt: now.subtract(const Duration(days: 2)),
  );

  final apptCompleted1 = AppointmentModel(
    id: 'c-1',
    patientId: 'patient-123',
    doctorId: 'doc-3',
    doctorName: const {'en': 'Dr. Past Earlier'},
    status: 'completed',
    startTime: now.subtract(const Duration(days: 5)),
    createdAt: now.subtract(const Duration(days: 10)),
  );

  final apptCompleted2 = AppointmentModel(
    id: 'c-2',
    patientId: 'patient-123',
    doctorId: 'doc-4',
    doctorName: const {'en': 'Dr. Past Recent'},
    status: 'completed',
    startTime: now.subtract(const Duration(days: 1)),
    createdAt: now.subtract(const Duration(days: 3)),
  );

  final apptCancelled1 = AppointmentModel(
    id: 'x-1',
    patientId: 'patient-123',
    doctorId: 'doc-5',
    doctorName: const {'en': 'Dr. Cancelled Old'},
    status: 'cancelled',
    startTime: now.add(const Duration(days: 3)),
    cancelledAt: now.subtract(const Duration(days: 2)),
    createdAt: now.subtract(const Duration(days: 3)),
  );

  final apptCancelled2 = AppointmentModel(
    id: 'x-2',
    patientId: 'patient-123',
    doctorId: 'doc-6',
    doctorName: const {'en': 'Dr. Cancelled Recent'},
    status: 'cancelled',
    startTime: now.add(const Duration(days: 4)),
    cancelledAt: now.subtract(const Duration(hours: 1)),
    createdAt: now.subtract(const Duration(days: 1)),
  );

  setUp(() {
    mockRepo = MockAppointmentRepo();
    mockSessionService = MockSessionService();
    when(() => mockSessionService.currentUserId).thenReturn('patient-123');
  });

  group('AppointmentsCubit - Loading Appointments', () {
    test('loads appointments successfully on creation using session userId', () async {
      when(() => mockRepo.getPatientAppointments('patient-123'))
          .thenAnswer((_) async => Right([apptUpcoming1, apptCompleted1]));

      final cubit = AppointmentsCubit(repo: mockRepo, sessionService: mockSessionService);
      await pumpEventQueue();

      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.appointments.length, 2);
      expect(cubit.state.errorMessage, isNull);

      cubit.close();
    });

    test('emits unauthenticated error without calling repository when session userId is null', () async {
      when(() => mockSessionService.currentUserId).thenReturn(null);

      final cubit = AppointmentsCubit(repo: mockRepo, sessionService: mockSessionService);
      await pumpEventQueue();

      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.appointments, isEmpty);
      expect(cubit.state.errorMessage, 'unauthenticated');
      verifyZeroInteractions(mockRepo);

      cubit.close();
    });

    test('sets error message when loading fails with NetworkFailure', () async {
      when(() => mockRepo.getPatientAppointments('patient-123'))
          .thenAnswer((_) async => const Left(NetworkFailure()));

      final cubit = AppointmentsCubit(repo: mockRepo, sessionService: mockSessionService);
      await pumpEventQueue();

      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.errorMessage, 'network');

      cubit.close();
    });

    test('sets error message when loading fails with ServerFailure', () async {
      when(() => mockRepo.getPatientAppointments('patient-123'))
          .thenAnswer((_) async => const Left(ServerFailure()));

      final cubit = AppointmentsCubit(repo: mockRepo, sessionService: mockSessionService);
      await pumpEventQueue();

      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.errorMessage, 'server');

      cubit.close();
    });

    test('refreshAppointments performs silent refresh without setting isLoading', () async {
      when(() => mockRepo.getPatientAppointments('patient-123'))
          .thenAnswer((_) async => Right([apptUpcoming1]));

      final cubit = AppointmentsCubit(repo: mockRepo, sessionService: mockSessionService);
      await pumpEventQueue();

      when(() => mockRepo.getPatientAppointments('patient-123'))
          .thenAnswer((_) async => Right([apptUpcoming1, apptUpcoming2]));

      final future = cubit.refreshAppointments();
      expect(cubit.state.isLoading, isFalse); // Silent refresh must not trigger full-screen loading

      await future;
      await pumpEventQueue();

      expect(cubit.state.appointments.length, 2);
      expect(cubit.state.isLoading, isFalse);

      cubit.close();
    });
  });

  group('AppointmentsState - Filtering and Sorting', () {
    late AppointmentsState testState;

    setUp(() {
      testState = AppointmentsState(
        appointments: [
          apptUpcoming1, // startTime +2 days
          apptUpcoming2, // startTime +1 day
          apptCompleted1, // startTime -5 days
          apptCompleted2, // startTime -1 day
          apptCancelled1, // cancelled -2 days
          apptCancelled2, // cancelled -1 hour
        ],
      );
    });

    test('upcomingAppointments filters pending/confirmed and sorts by startTime ASC (earliest first)', () {
      final upcoming = testState.upcomingAppointments;
      expect(upcoming.length, 2);
      // apptUpcoming2 (+1 day) is earlier than apptUpcoming1 (+2 days)
      expect(upcoming[0].id, 'u-2');
      expect(upcoming[1].id, 'u-1');
    });

    test('completedAppointments filters completed and sorts by startTime DESC (most recent first)', () {
      final completed = testState.completedAppointments;
      expect(completed.length, 2);
      // apptCompleted2 (-1 day) is more recent than apptCompleted1 (-5 days)
      expect(completed[0].id, 'c-2');
      expect(completed[1].id, 'c-1');
    });

    test('cancelledAppointments filters cancelled and sorts by cancelledAt DESC (latest cancelled first)', () {
      final cancelled = testState.cancelledAppointments;
      expect(cancelled.length, 2);
      // apptCancelled2 (-1 hour) was cancelled more recently than apptCancelled1 (-2 days)
      expect(cancelled[0].id, 'x-2');
      expect(cancelled[1].id, 'x-1');
    });

    test('cancelledAppointments sorting handles null cancelledAt falling back to createdAt and startTime', () {
      final apptWithoutCancelledAt = AppointmentModel(
        id: 'x-fallback',
        patientId: 'patient-123',
        doctorId: 'doc-9',
        doctorName: const {'en': 'Dr. No Cancel Date'},
        status: 'cancelled',
        startTime: now.add(const Duration(days: 5)),
        cancelledAt: null,
        createdAt: now.subtract(const Duration(hours: 2)),
      );

      final apptWithNoDates = AppointmentModel(
        id: 'x-nodates',
        patientId: 'patient-123',
        doctorId: 'doc-10',
        doctorName: const {'en': 'Dr. No Dates'},
        status: 'cancelled',
        startTime: now.add(const Duration(days: 6)),
        cancelledAt: null,
        createdAt: null,
      );

      final state = AppointmentsState(
        appointments: [apptCancelled1, apptWithoutCancelledAt, apptWithNoDates],
      );

      final sorted = state.cancelledAppointments;
      expect(sorted.length, 3);
      // x-fallback createdAt is -2 hours, which is newer than x-1 cancelledAt (-2 days)
      expect(sorted[0].id, 'x-fallback');
      expect(sorted[1].id, 'x-1');
      expect(sorted[2].id, 'x-nodates');
    });

    test('currentTabAppointments returns matching list for selectedTab', () {
      final upcomingState = testState.copyWith(selectedTab: AppointmentTab.upcoming);
      expect(upcomingState.currentTabAppointments.length, 2);
      expect(upcomingState.currentTabAppointments.first.id, 'u-2');

      final completedState = testState.copyWith(selectedTab: AppointmentTab.completed);
      expect(completedState.currentTabAppointments.length, 2);
      expect(completedState.currentTabAppointments.first.id, 'c-2');

      final cancelledState = testState.copyWith(selectedTab: AppointmentTab.cancelled);
      expect(cancelledState.currentTabAppointments.length, 2);
      expect(cancelledState.currentTabAppointments.first.id, 'x-2');
    });
  });

  group('AppointmentsCubit - Tab Switching', () {
    test('switchTab changes selected tab and clears error', () async {
      when(() => mockRepo.getPatientAppointments('patient-123'))
          .thenAnswer((_) async => const Right([]));

      final cubit = AppointmentsCubit(repo: mockRepo, sessionService: mockSessionService);
      await pumpEventQueue();

      expect(cubit.state.selectedTab, AppointmentTab.upcoming);

      cubit.switchTab(AppointmentTab.completed);
      expect(cubit.state.selectedTab, AppointmentTab.completed);

      // Switching to same tab should be a no-op
      cubit.switchTab(AppointmentTab.completed);
      expect(cubit.state.selectedTab, AppointmentTab.completed);

      cubit.close();
    });
  });

  group('AppointmentsCubit - Cancellation Flow', () {
    test('cancelAppointment optimistic update succeeds and marks appointment cancelled', () async {
      when(() => mockRepo.getPatientAppointments('patient-123'))
          .thenAnswer((_) async => Right([apptUpcoming1]));

      final cubit = AppointmentsCubit(repo: mockRepo, sessionService: mockSessionService);
      await pumpEventQueue();

      when(() => mockRepo.updateStatus('u-1', 'cancelled'))
          .thenAnswer((_) async => const Right(null));

      final success = await cubit.cancelAppointment('u-1');

      expect(success, isTrue);
      expect(cubit.state.cancellingAppointmentId, isNull);
      expect(cubit.state.errorMessage, isNull);

      final updatedAppt = cubit.state.appointments.firstWhere((a) => a.id == 'u-1');
      expect(updatedAppt.status, 'cancelled');
      expect(updatedAppt.cancelledAt, isNotNull);

      // It should now appear under cancelledAppointments and disappear from upcomingAppointments
      expect(cubit.state.upcomingAppointments, isEmpty);
      expect(cubit.state.cancelledAppointments.length, 1);

      cubit.close();
    });

    test('cancelAppointment failure preserves original state and sets error message', () async {
      when(() => mockRepo.getPatientAppointments('patient-123'))
          .thenAnswer((_) async => Right([apptUpcoming1]));

      final cubit = AppointmentsCubit(repo: mockRepo, sessionService: mockSessionService);
      await pumpEventQueue();

      when(() => mockRepo.updateStatus('u-1', 'cancelled'))
          .thenAnswer((_) async => const Left(ServerFailure()));

      final success = await cubit.cancelAppointment('u-1');

      expect(success, isFalse);
      expect(cubit.state.cancellingAppointmentId, isNull);
      expect(cubit.state.errorMessage, 'server');

      // State is preserved - still confirmed
      final appt = cubit.state.appointments.firstWhere((a) => a.id == 'u-1');
      expect(appt.status, 'confirmed');
      expect(cubit.state.upcomingAppointments.length, 1);

      cubit.close();
    });

    test('cancelAppointment network failure sets specific network error message', () async {
      when(() => mockRepo.getPatientAppointments('patient-123'))
          .thenAnswer((_) async => Right([apptUpcoming1]));

      final cubit = AppointmentsCubit(repo: mockRepo, sessionService: mockSessionService);
      await pumpEventQueue();

      when(() => mockRepo.updateStatus('u-1', 'cancelled'))
          .thenAnswer((_) async => const Left(NetworkFailure()));

      final success = await cubit.cancelAppointment('u-1');

      expect(success, isFalse);
      expect(cubit.state.errorMessage, 'network');

      cubit.close();
    });
  });

  group('AppointmentsCubit - addAppointment and updateRating', () {
    test('addAppointment prepends appointment, switches to upcoming tab, and prevents duplicates', () async {
      when(() => mockRepo.getPatientAppointments('patient-123'))
          .thenAnswer((_) async => Right([apptUpcoming1]));

      final cubit = AppointmentsCubit(repo: mockRepo, sessionService: mockSessionService);
      await pumpEventQueue();

      cubit.switchTab(AppointmentTab.completed);
      expect(cubit.state.selectedTab, AppointmentTab.completed);

      // Add a new appointment
      cubit.addAppointment(apptUpcoming2);
      expect(cubit.state.appointments.length, 2);
      expect(cubit.state.appointments.first.id, 'u-2');
      expect(cubit.state.selectedTab, AppointmentTab.upcoming);

      // Attempt duplicate addition
      cubit.addAppointment(apptUpcoming2);
      expect(cubit.state.appointments.length, 2);

      cubit.close();
    });

    test('updateAppointmentRating updates rating and reviewComment on the matching appointment', () async {
      when(() => mockRepo.getPatientAppointments('patient-123'))
          .thenAnswer((_) async => Right([apptCompleted1]));

      final cubit = AppointmentsCubit(repo: mockRepo, sessionService: mockSessionService);
      await pumpEventQueue();

      cubit.updateAppointmentRating('c-1', 5, 'Great consultation!');

      final appt = cubit.state.appointments.firstWhere((a) => a.id == 'c-1');
      expect(appt.rating, 5);
      expect(appt.reviewComment, 'Great consultation!');

      cubit.close();
    });
  });
}
