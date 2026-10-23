import 'package:dartz/dartz.dart';
import 'package:doctor_hunt/core/error/failures.dart';
import 'package:doctor_hunt/core/network/network_info.dart';
import 'package:doctor_hunt/features/favorites/repo/favorites_repo_impl.dart';
import 'package:doctor_hunt/features/favorites/service/favorites_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFavoritesService extends Mock implements FavoritesService {}
class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late MockFavoritesService mockService;
  late MockNetworkInfo mockNetworkInfo;
  late FavoritesRepoImpl repo;

  setUp(() {
    mockService = MockFavoritesService();
    mockNetworkInfo = MockNetworkInfo();
    repo = FavoritesRepoImpl(service: mockService, networkInfo: mockNetworkInfo);
  });

  group('FavoritesRepoImpl - Network Connectivity', () {
    setUp(() {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    });

    test('getFavoriteDoctorIds returns NetworkFailure when offline', () async {
      final result = await repo.getFavoriteDoctorIds();
      expect(result, const Left(NetworkFailure()));
      verifyZeroInteractions(mockService);
    });

    test('addFavorite returns NetworkFailure when offline', () async {
      final result = await repo.addFavorite('doc-1');
      expect(result, const Left(NetworkFailure()));
      verifyZeroInteractions(mockService);
    });

    test('removeFavorite returns NetworkFailure when offline', () async {
      final result = await repo.removeFavorite('doc-1');
      expect(result, const Left(NetworkFailure()));
      verifyZeroInteractions(mockService);
    });
  });

  group('FavoritesRepoImpl - Successful Operations', () {
    setUp(() {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });

    test('getFavoriteDoctorIds returns Right(ids)', () async {
      when(() => mockService.getFavoriteDoctorIds())
          .thenAnswer((_) async => ['doc-1', 'doc-2']);

      final result = await repo.getFavoriteDoctorIds();
      expect(result.isRight(), isTrue);
      expect(result.getOrElse(() => []), ['doc-1', 'doc-2']);
      verify(() => mockService.getFavoriteDoctorIds()).called(1);
    });

    test('addFavorite returns Right(null)', () async {
      when(() => mockService.addFavorite('doc-1')).thenAnswer((_) async {});

      final result = await repo.addFavorite('doc-1');
      expect(result, const Right(null));
      verify(() => mockService.addFavorite('doc-1')).called(1);
    });

    test('removeFavorite returns Right(null)', () async {
      when(() => mockService.removeFavorite('doc-1')).thenAnswer((_) async {});

      final result = await repo.removeFavorite('doc-1');
      expect(result, const Right(null));
      verify(() => mockService.removeFavorite('doc-1')).called(1);
    });
  });

  group('FavoritesRepoImpl - Exception Handling', () {
    setUp(() {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });

    test('getFavoriteDoctorIds maps exception to ServerFailure', () async {
      when(() => mockService.getFavoriteDoctorIds()).thenThrow(Exception('DB error'));

      final result = await repo.getFavoriteDoctorIds();
      expect(result, const Left(ServerFailure()));
    });

    test('addFavorite maps exception to ServerFailure', () async {
      when(() => mockService.addFavorite('doc-1')).thenThrow(Exception('DB error'));

      final result = await repo.addFavorite('doc-1');
      expect(result, const Left(ServerFailure()));
    });

    test('removeFavorite maps exception to ServerFailure', () async {
      when(() => mockService.removeFavorite('doc-1')).thenThrow(Exception('DB error'));

      final result = await repo.removeFavorite('doc-1');
      expect(result, const Left(ServerFailure()));
    });
  });
}
