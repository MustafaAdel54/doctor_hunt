import 'package:dartz/dartz.dart';
import 'package:doctor_hunt/core/error/failures.dart';
import 'package:doctor_hunt/core/session/session_service.dart';
import 'package:doctor_hunt/features/auth/models/user_model.dart';
import 'package:doctor_hunt/features/profile/cubit/profile_cubit.dart';
import 'package:doctor_hunt/features/profile/cubit/profile_state.dart';
import 'package:doctor_hunt/features/profile/repo/profile_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRepo extends Mock implements ProfileRepo {}

class MockSessionService extends Mock implements SessionService {}

void main() {
  setUpAll(() {
    registerFallbackValue(const UserModel(
      uid: 'fallback',
      email: 'fallback@test.com',
      role: 'patient',
    ));
  });

  group('ProfileCubit Unit Tests', () {
    late MockProfileRepo mockRepo;
    late MockSessionService mockSession;
    late ProfileCubit cubit;

    const testUser = UserModel(
      uid: 'p1111111-1111-1111-1111-111111111111',
      email: 'patient@example.com',
      role: 'patient',
      name: 'Abdullah Mamun',
      phone: '+8801800000000',
      photoUrl: 'https://example.com/avatar.jpg',
    );

    setUp(() {
      mockRepo = MockProfileRepo();
      mockSession = MockSessionService();
      when(() => mockSession.currentUserId).thenReturn(testUser.uid);
      when(() => mockSession.refreshProfile()).thenAnswer((_) async {});

      cubit = ProfileCubit(repo: mockRepo, sessionService: mockSession);
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state is ProfileInitial', () {
      expect(cubit.state, isA<ProfileInitial>());
      expect(cubit.currentUser, isNull);
      expect(cubit.isUpdating, isFalse);
    });

    test('loadProfile emits [ProfileLoading, ProfileLoaded] on success', () async {
      when(() => mockRepo.getProfile(testUser.uid))
          .thenAnswer((_) async => const Right(testUser));

      final states = <ProfileState>[];
      cubit.stream.listen(states.add);

      await cubit.loadProfile();
      await Future<void>.delayed(Duration.zero);

      expect(states.length, 2);
      expect(states[0], isA<ProfileLoading>());
      expect(states[1], isA<ProfileLoaded>());
      final loaded = states[1] as ProfileLoaded;
      expect(loaded.user.name, 'Abdullah Mamun');
      expect(loaded.user.phone, '+8801800000000');
      expect(cubit.currentUser, testUser);
    });

    test('loadProfile emits [ProfileLoading, ProfileError] on failure', () async {
      when(() => mockRepo.getProfile(testUser.uid))
          .thenAnswer((_) async => const Left(ServerFailure()));

      final states = <ProfileState>[];
      cubit.stream.listen(states.add);

      await cubit.loadProfile();
      await Future<void>.delayed(Duration.zero);

      expect(states.length, 2);
      expect(states[0], isA<ProfileLoading>());
      expect(states[1], isA<ProfileError>());
      expect((states[1] as ProfileError).code, 'server');
    });

    test('loadProfile emits ProfileError unauthenticated when currentUserId is null', () async {
      when(() => mockSession.currentUserId).thenReturn(null);

      final states = <ProfileState>[];
      cubit.stream.listen(states.add);

      await cubit.loadProfile();
      await Future<void>.delayed(Duration.zero);

      expect(states.length, 1);
      expect(states[0], isA<ProfileError>());
      expect((states[0] as ProfileError).code, 'unauthenticated');
    });

    test('updateProfile succeeds, updates user, calls session refresh and emits loaded', () async {
      when(() => mockRepo.getProfile(testUser.uid))
          .thenAnswer((_) async => const Right(testUser));
      when(() => mockRepo.updateProfile(any()))
          .thenAnswer((_) async => const Right(null));

      await cubit.loadProfile();

      final states = <ProfileState>[];
      cubit.stream.listen(states.add);

      final result = await cubit.updateProfile(
        name: 'New Name',
        phone: '+1234567890',
      );
      await Future<void>.delayed(Duration.zero);

      expect(result, isTrue);
      expect(states.length, 3);
      expect(states[0], isA<ProfileUpdating>());
      expect(states[1], isA<ProfileUpdateSuccess>());
      expect(states[2], isA<ProfileLoaded>());

      final finalUser = (states[2] as ProfileLoaded).user;
      expect(finalUser.name, 'New Name');
      expect(finalUser.phone, '+1234567890');
      expect(finalUser.email, testUser.email); // Unrelated fields preserved
      verify(() => mockSession.refreshProfile()).called(1);
    });

    test('updateProfile fails and preserves existing user data in ProfileUpdateError', () async {
      when(() => mockRepo.getProfile(testUser.uid))
          .thenAnswer((_) async => const Right(testUser));
      when(() => mockRepo.updateProfile(any()))
          .thenAnswer((_) async => const Left(NetworkFailure()));

      await cubit.loadProfile();

      final states = <ProfileState>[];
      cubit.stream.listen(states.add);

      final result = await cubit.updateProfile(
        name: 'Failed Name',
        phone: '+999999',
      );
      await Future<void>.delayed(Duration.zero);

      expect(result, isFalse);
      expect(states.length, 2);
      expect(states[0], isA<ProfileUpdating>());
      expect(states[1], isA<ProfileUpdateError>());

      final errorState = states[1] as ProfileUpdateError;
      expect(errorState.code, 'network');
      expect(errorState.user.name, 'Abdullah Mamun'); // Preserves previous user
    });

    test('updateProfile prevents duplicate submissions when active save is in progress', () async {
      when(() => mockRepo.getProfile(testUser.uid))
          .thenAnswer((_) async => const Right(testUser));
      when(() => mockRepo.updateProfile(any())).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 50));
        return const Right(null);
      });

      await cubit.loadProfile();

      final future1 = cubit.updateProfile(name: 'Update 1', phone: '111111');
      final future2 = cubit.updateProfile(name: 'Update 2', phone: '222222');

      final results = await Future.wait([future1, future2]);

      expect(results[0], isTrue);
      expect(results[1], isFalse); // Rejected due to duplicate execution guard
      verify(() => mockRepo.updateProfile(any())).called(1);
    });
  });
}
