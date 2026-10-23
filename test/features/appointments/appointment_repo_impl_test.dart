import 'package:dartz/dartz.dart';
import 'package:doctor_hunt/core/error/exceptions.dart';
import 'package:doctor_hunt/core/error/failures.dart';
import 'package:doctor_hunt/core/network/network_info.dart';
import 'package:doctor_hunt/features/appointments/models/appointment_model.dart';
import 'package:doctor_hunt/features/appointments/repo/appointment_repo_impl.dart';
import 'package:doctor_hunt/features/appointments/service/appointment_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAppointmentService extends Mock implements AppointmentService {}
class MockNetworkInfo extends Mock implements NetworkInfo {}
class FakeAppointmentModel extends Fake implements AppointmentModel {}

void main() {
  late MockAppointmentService mockService;
  late MockNetworkInfo mockNetworkInfo;
  late AppointmentRepoImpl repo;

  final testAppt = AppointmentModel(
    id: 'appt-1',
    patientId: 'patient-1',
    doctorId: 'doc-uuid-1',
    doctorName: const {'en': 'Dr. Test'},
    status: 'pending',
    startTime: DateTime.utc(2026, 10, 26, 10, 0),
  );

  setUpAll(() {
    registerFallbackValue(FakeAppointmentModel());
    registerFallbackValue(DateTime.now());
  });

  setUp(() {
    mockService = MockAppointmentService();
    mockNetworkInfo = MockNetworkInfo();
    repo = AppointmentRepoImpl(service: mockService, networkInfo: mockNetworkInfo);
  });

  group('AppointmentRepoImpl - Connectivity checks', () {
    setUp(() {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    });

    test('getPatientAppointments returns NetworkFailure when offline', () async {
      final result = await repo.getPatientAppointments('patient-1');
      expect(result, const Left(NetworkFailure()));
    });

    test('getDoctorAppointments returns NetworkFailure when offline', () async {
      final result = await repo.getDoctorAppointments('doc-1');
      expect(result, const Left(NetworkFailure()));
    });

    test('bookAppointment returns NetworkFailure when offline', () async {
      final result = await repo.bookAppointment(testAppt);
      expect(result, const Left(NetworkFailure()));
    });

    test('getBookedSlots returns Right([]) gracefully when offline', () async {
      final result = await repo.getBookedSlots('doc-1', DateTime.utc(2026, 10, 26));
      expect(result.isRight(), isTrue);
      expect(result.getOrElse(() => [DateTime.now()]), isEmpty);
    });

    test('updateStatus returns NetworkFailure when offline', () async {
      final result = await repo.updateStatus('appt-1', 'cancelled');
      expect(result, const Left(NetworkFailure()));
    });
  });

  group('AppointmentRepoImpl - Successful Operations', () {
    setUp(() {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });

    test('getPatientAppointments returns Right(appointments)', () async {
      when(() => mockService.getPatientAppointments('patient-1'))
          .thenAnswer((_) async => [testAppt]);

      final result = await repo.getPatientAppointments('patient-1');
      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should succeed'),
        (list) {
          expect(list.length, 1);
          expect(list.first.id, testAppt.id);
        },
      );
    });

    test('getDoctorAppointments returns Right(appointments)', () async {
      when(() => mockService.getDoctorAppointments('doc-1'))
          .thenAnswer((_) async => [testAppt]);

      final result = await repo.getDoctorAppointments('doc-1');
      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should succeed'),
        (list) {
          expect(list.length, 1);
          expect(list.first.id, testAppt.id);
        },
      );
    });

    test('bookAppointment returns Right(bookedAppointment)', () async {
      when(() => mockService.bookAppointment(any()))
          .thenAnswer((_) async => testAppt);

      final result = await repo.bookAppointment(testAppt);
      expect(result, Right(testAppt));
    });

    test('getBookedSlots returns Right(slots)', () async {
      final slots = [DateTime.utc(2026, 10, 26, 10, 0)];
      when(() => mockService.getBookedSlots(any(), any()))
          .thenAnswer((_) async => slots);

      final result = await repo.getBookedSlots('doc-1', DateTime.utc(2026, 10, 26));
      expect(result, Right(slots));
    });

    test('updateStatus returns Right(null)', () async {
      when(() => mockService.updateStatus('appt-1', 'cancelled'))
          .thenAnswer((_) async {});

      final result = await repo.updateStatus('appt-1', 'cancelled');
      expect(result, const Right(null));
    });
  });

  group('AppointmentRepoImpl - Exception Handling', () {
    setUp(() {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });

    test('bookAppointment converts SlotTakenException to SlotTakenFailure', () async {
      when(() => mockService.bookAppointment(any()))
          .thenThrow(const SlotTakenException());

      final result = await repo.bookAppointment(testAppt);
      expect(result, const Left(SlotTakenFailure()));
    });

    test('getPatientAppointments maps unexpected exception to ServerFailure', () async {
      when(() => mockService.getPatientAppointments('patient-1'))
          .thenThrow(Exception('RPC failed'));

      final result = await repo.getPatientAppointments('patient-1');
      expect(result, const Left(ServerFailure()));
    });

    test('updateStatus maps unexpected exception to ServerFailure', () async {
      when(() => mockService.updateStatus('appt-1', 'cancelled'))
          .thenThrow(Exception('Database error'));

      final result = await repo.updateStatus('appt-1', 'cancelled');
      expect(result, const Left(ServerFailure()));
    });
  });
}
