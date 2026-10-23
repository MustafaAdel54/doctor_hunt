import 'package:dartz/dartz.dart';
import 'package:doctor_hunt/core/error/failures.dart';
import 'package:doctor_hunt/features/doctors/cubit/doctors_cubit.dart';
import 'package:doctor_hunt/features/doctors/cubit/doctors_state.dart';
import 'package:doctor_hunt/features/doctors/models/doctor_model.dart';
import 'package:doctor_hunt/features/doctors/repo/doctor_repo.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDoctorRepo extends Mock implements DoctorRepo {}

void main() {
  group('DoctorsCubit', () {
    late MockDoctorRepo mockDoctorRepo;
    late DoctorsCubit cubit;

    const testDoctor1 = DoctorModel(
      id: 'd1111111-1111-1111-1111-111111111111',
      name: {'en': 'Dr. Fillerup Grab', 'ar': 'د. فيليروب'},
      image: 'assets/images/home/pop_doc_1.png',
      phone: '+1234567890',
      ratingSum: 190,
      ratingCount: 40,
      specialization: 'Specialist Cardiologist',
      yearsExperience: 9,
      patientsCount: 1200,
      runningCount: 150,
      ongoingCount: 850,
      hourlyRate: 35.0,
      services: ['Cardiology'],
    );

    const testDoctor2 = DoctorModel(
      id: 'd2222222-2222-2222-2222-222222222222',
      name: {'en': 'Dr. Blessing', 'ar': 'د. بليسينج'},
      image: 'https://example.com/doc2.png',
      phone: '+1987654321',
      ratingSum: 160,
      ratingCount: 35,
      specialization: 'Specialist Dentist',
      yearsExperience: 6,
      patientsCount: 900,
      runningCount: 100,
      ongoingCount: 600,
      hourlyRate: 30.0,
      services: ['Dentistry'],
    );

    setUp(() {
      mockDoctorRepo = MockDoctorRepo();
      when(() => mockDoctorRepo.getDoctors(
            limit: any(named: 'limit'),
            specialization: any(named: 'specialization'),
          )).thenAnswer((_) async => const Right([]));
      cubit = DoctorsCubit(doctorRepo: mockDoctorRepo);
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state does not contain fake mock doctors and is not loading', () {
      final initial = DoctorsState.initial();
      expect(initial.doctors, isEmpty);
      expect(initial.popularDoctors, isEmpty);
      expect(initial.featureDoctors, isEmpty);
      expect(initial.searchResults, isEmpty);
      expect(initial.isLoading, isFalse);
      expect(initial.isSearching, isFalse);
      expect(initial.errorMessage, isNull);
    });

    test('loadDoctors emits loading and updates popularDoctors with live Supabase data', () async {
      when(() => mockDoctorRepo.getDoctors(
            limit: any(named: 'limit'),
            specialization: any(named: 'specialization'),
          )).thenAnswer((_) async => const Right([testDoctor1, testDoctor2]));

      final future = cubit.loadDoctors();
      expect(cubit.state.isLoading, isTrue);

      await future;

      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.doctors, equals([testDoctor1, testDoctor2]));
      expect(cubit.state.popularDoctors, equals([testDoctor1, testDoctor2]));
      expect(cubit.state.errorMessage, isNull);
    });

    test('loadDoctors handles empty doctor results from Supabase correctly', () async {
      when(() => mockDoctorRepo.getDoctors(
            limit: any(named: 'limit'),
            specialization: any(named: 'specialization'),
          )).thenAnswer((_) async => const Right([]));

      await cubit.loadDoctors();

      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.doctors, isEmpty);
      expect(cubit.state.popularDoctors, isEmpty);
      expect(cubit.state.errorMessage, isNull);
    });

    test('loadDoctors handles NetworkFailure with localized error message', () async {
      when(() => mockDoctorRepo.getDoctors(
            limit: any(named: 'limit'),
            specialization: any(named: 'specialization'),
          )).thenAnswer((_) async => const Left(NetworkFailure()));

      await cubit.loadDoctors();

      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.doctors, isEmpty);
      expect(cubit.state.errorMessage, equals(t.errors.network));
    });

    test('loadDoctors handles ServerFailure with localized error message', () async {
      when(() => mockDoctorRepo.getDoctors(
            limit: any(named: 'limit'),
            specialization: any(named: 'specialization'),
          )).thenAnswer((_) async => const Left(ServerFailure()));

      await cubit.loadDoctors();

      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.doctors, isEmpty);
      expect(cubit.state.errorMessage, equals(t.errors.server));
    });

    test('retry behavior clears error and successfully populates doctors', () async {
      // 1. Initial attempt fails
      when(() => mockDoctorRepo.getDoctors(
            limit: any(named: 'limit'),
            specialization: any(named: 'specialization'),
          )).thenAnswer((_) async => const Left(ServerFailure()));

      await cubit.loadDoctors();
      expect(cubit.state.errorMessage, equals(t.errors.server));
      expect(cubit.state.doctors, isEmpty);

      // 2. Retry succeeds
      when(() => mockDoctorRepo.getDoctors(
            limit: any(named: 'limit'),
            specialization: any(named: 'specialization'),
          )).thenAnswer((_) async => const Right([testDoctor1]));

      await cubit.loadDoctors();
      expect(cubit.state.errorMessage, isNull);
      expect(cubit.state.doctors, equals([testDoctor1]));
      expect(cubit.state.popularDoctors, equals([testDoctor1]));
    });

    test('searchDoctors queries DoctorRepo and populates searchResults', () async {
      when(() => mockDoctorRepo.searchDoctors('Dentist'))
          .thenAnswer((_) async => const Right([testDoctor2]));

      await cubit.searchDoctors('Dentist');

      expect(cubit.state.isSearching, isFalse);
      expect(cubit.state.searchResults, equals([testDoctor2]));
      expect(cubit.state.errorMessage, isNull);
    });

    test('searchDoctors with empty query clears searchResults without network call', () async {
      await cubit.searchDoctors('   ');

      expect(cubit.state.isSearching, isFalse);
      expect(cubit.state.searchResults, isEmpty);
      verifyNever(() => mockDoctorRepo.searchDoctors(any()));
    });

    test('findDoctorById locates doctor by real database UUID', () async {
      when(() => mockDoctorRepo.getDoctors(
            limit: any(named: 'limit'),
            specialization: any(named: 'specialization'),
          )).thenAnswer((_) async => const Right([testDoctor1, testDoctor2]));

      await cubit.loadDoctors();

      final found = cubit.getDoctorById(testDoctor1.id);
      expect(found, equals(testDoctor1));

      final notFound = cubit.getDoctorById('unknown-id');
      expect(notFound, isNull);
    });

    test('featureDoctors remains empty due to schema limitation (deferred)', () async {
      when(() => mockDoctorRepo.getDoctors(
            limit: any(named: 'limit'),
            specialization: any(named: 'specialization'),
          )).thenAnswer((_) async => const Right([testDoctor1, testDoctor2]));

      await cubit.loadDoctors();

      // Feature categorization is deferred without inventing UUID rules
      expect(cubit.state.featureDoctors, isEmpty);
    });
  });
}
