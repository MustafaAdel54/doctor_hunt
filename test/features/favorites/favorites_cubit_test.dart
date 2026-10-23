import 'package:dartz/dartz.dart';
import 'package:doctor_hunt/core/error/failures.dart';
import 'package:doctor_hunt/features/favorites/cubit/favorites_cubit.dart';
import 'package:doctor_hunt/features/favorites/repo/favorites_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFavoritesRepo extends Mock implements FavoritesRepo {}

void main() {
  late MockFavoritesRepo mockRepo;

  setUp(() {
    mockRepo = MockFavoritesRepo();
  });

  group('FavoritesCubit - loadFavorites', () {
    test('loads favorite doctor ids on instantiation', () async {
      when(() => mockRepo.getFavoriteDoctorIds())
          .thenAnswer((_) async => const Right(['doc-1', 'doc-2']));

      final cubit = FavoritesCubit(repo: mockRepo);
      await pumpEventQueue();

      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.favoriteDoctorIds, {'doc-1', 'doc-2'});
      expect(cubit.state.isFavorite('doc-1'), isTrue);
      expect(cubit.state.isFavorite('doc-3'), isFalse);
      expect(cubit.state.errorMessage, isNull);

      cubit.close();
    });

    test('emits error message when loading favorites fails', () async {
      when(() => mockRepo.getFavoriteDoctorIds())
          .thenAnswer((_) async => const Left(ServerFailure()));

      final cubit = FavoritesCubit(repo: mockRepo);
      await pumpEventQueue();

      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.favoriteDoctorIds, isEmpty);
      expect(cubit.state.errorMessage, 'server');

      cubit.close();
    });
  });

  group('FavoritesCubit - toggleFavorite', () {
    test('optimistically adds favorite doctor id and persists on success', () async {
      when(() => mockRepo.getFavoriteDoctorIds())
          .thenAnswer((_) async => const Right([]));

      final cubit = FavoritesCubit(repo: mockRepo);
      await pumpEventQueue();

      when(() => mockRepo.addFavorite('doc-new'))
          .thenAnswer((_) async => const Right(null));

      final future = cubit.toggleFavorite('doc-new');

      // Optimistic check immediately reflects addition
      expect(cubit.state.isFavorite('doc-new'), isTrue);

      await future;
      await pumpEventQueue();

      expect(cubit.state.isFavorite('doc-new'), isTrue);
      expect(cubit.state.errorMessage, isNull);
      verify(() => mockRepo.addFavorite('doc-new')).called(1);

      cubit.close();
    });

    test('optimistically removes favorite doctor id and persists on success', () async {
      when(() => mockRepo.getFavoriteDoctorIds())
          .thenAnswer((_) async => const Right(['doc-fav']));

      final cubit = FavoritesCubit(repo: mockRepo);
      await pumpEventQueue();
      expect(cubit.state.isFavorite('doc-fav'), isTrue);

      when(() => mockRepo.removeFavorite('doc-fav'))
          .thenAnswer((_) async => const Right(null));

      final future = cubit.toggleFavorite('doc-fav');

      // Optimistic check immediately reflects removal
      expect(cubit.state.isFavorite('doc-fav'), isFalse);

      await future;
      await pumpEventQueue();

      expect(cubit.state.isFavorite('doc-fav'), isFalse);
      expect(cubit.state.errorMessage, isNull);
      verify(() => mockRepo.removeFavorite('doc-fav')).called(1);

      cubit.close();
    });

    test('reverts optimistic addition when addFavorite fails', () async {
      when(() => mockRepo.getFavoriteDoctorIds())
          .thenAnswer((_) async => const Right([]));

      final cubit = FavoritesCubit(repo: mockRepo);
      await pumpEventQueue();

      when(() => mockRepo.addFavorite('doc-fail'))
          .thenAnswer((_) async => const Left(ServerFailure()));

      final future = cubit.toggleFavorite('doc-fail');
      // Initially optimistically added
      expect(cubit.state.isFavorite('doc-fail'), isTrue);

      await future;
      await pumpEventQueue();

      // Reverted back to not favorite
      expect(cubit.state.isFavorite('doc-fail'), isFalse);
      expect(cubit.state.errorMessage, 'server');

      cubit.close();
    });

    test('reverts optimistic removal when removeFavorite fails', () async {
      when(() => mockRepo.getFavoriteDoctorIds())
          .thenAnswer((_) async => const Right(['doc-persist']));

      final cubit = FavoritesCubit(repo: mockRepo);
      await pumpEventQueue();
      expect(cubit.state.isFavorite('doc-persist'), isTrue);

      when(() => mockRepo.removeFavorite('doc-persist'))
          .thenAnswer((_) async => const Left(ServerFailure()));

      final future = cubit.toggleFavorite('doc-persist');
      // Initially optimistically removed
      expect(cubit.state.isFavorite('doc-persist'), isFalse);

      await future;
      await pumpEventQueue();

      // Reverted back to favorite
      expect(cubit.state.isFavorite('doc-persist'), isTrue);
      expect(cubit.state.errorMessage, 'server');

      cubit.close();
    });
  });
}
