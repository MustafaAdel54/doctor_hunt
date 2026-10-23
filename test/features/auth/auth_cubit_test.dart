import 'package:dartz/dartz.dart';
import 'package:doctor_hunt/core/error/failures.dart';
import 'package:doctor_hunt/core/session/session_service.dart';
import 'package:doctor_hunt/features/auth/cubit/auth_cubit.dart';
import 'package:doctor_hunt/features/auth/cubit/auth_state.dart';
import 'package:doctor_hunt/features/auth/models/user_model.dart';
import 'package:doctor_hunt/features/auth/repo/auth_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepo extends Mock implements AuthRepo {}
class MockSessionService extends Mock implements SessionService {}

void main() {
  late MockAuthRepo mockRepo;
  late MockSessionService mockSessionService;
  late AuthCubit cubit;

  const testUser = UserModel(
    uid: 'u-123',
    email: 'patient@example.com',
    role: 'patient',
  );

  setUp(() {
    mockRepo = MockAuthRepo();
    mockSessionService = MockSessionService();
    cubit = AuthCubit(repo: mockRepo, sessionService: mockSessionService);
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state is AuthState.initial()', () {
    expect(cubit.state, const AuthState.initial());
  });

  group('loginWithEmail', () {
    test('emits [loading, success] on successful sign-in', () async {
      when(() => mockRepo.loginWithEmail('test@example.com', 'password123'))
          .thenAnswer((_) async => const Right(testUser));

      final states = <AuthState>[];
      cubit.stream.listen(states.add);

      await cubit.loginWithEmail('test@example.com', 'password123');
      await pumpEventQueue();

      expect(states.length, 2);
      expect(states[0], isA<AuthLoading>());
      expect(states[1], isA<AuthSuccess>());
      expect(cubit.state, isA<AuthSuccess>());
    });

    test('emits [loading, error] with failure code when sign-in fails', () async {
      when(() => mockRepo.loginWithEmail('test@example.com', 'wrong'))
          .thenAnswer((_) async => const Left(AuthFailure(code: 'invalid-credential')));

      final states = <AuthState>[];
      cubit.stream.listen(states.add);

      await cubit.loginWithEmail('test@example.com', 'wrong');
      await pumpEventQueue();

      expect(states.length, 2);
      expect(states[0], isA<AuthLoading>());
      expect(states[1], isA<AuthError>());
      expect((states[1] as AuthError).message, 'invalid-credential');
    });

    test('maps NetworkFailure to "network" error code', () async {
      when(() => mockRepo.loginWithEmail(any(), any()))
          .thenAnswer((_) async => const Left(NetworkFailure()));

      final states = <AuthState>[];
      cubit.stream.listen(states.add);

      await cubit.loginWithEmail('test@example.com', 'pass');
      await pumpEventQueue();

      expect(states.length, 2);
      expect((states[1] as AuthError).message, 'network');
    });

    test('maps ServerFailure to "server" error code', () async {
      when(() => mockRepo.loginWithEmail(any(), any()))
          .thenAnswer((_) async => const Left(ServerFailure()));

      final states = <AuthState>[];
      cubit.stream.listen(states.add);

      await cubit.loginWithEmail('test@example.com', 'pass');
      await pumpEventQueue();

      expect(states.length, 2);
      expect((states[1] as AuthError).message, 'server');
    });
  });

  group('registerWithEmailOnly', () {
    test('emits [loading, success] on successful registration', () async {
      when(() => mockRepo.registerWithEmailOnly('new@example.com', 'pass', 'Name'))
          .thenAnswer((_) async => const Right(null));

      final states = <AuthState>[];
      cubit.stream.listen(states.add);

      await cubit.registerWithEmailOnly('new@example.com', 'pass', 'Name');
      await pumpEventQueue();

      expect(states.length, 2);
      expect(states[0], isA<AuthLoading>());
      expect(states[1], isA<AuthSuccess>());
    });

    test('emits [loading, error] when registration fails with email-already-in-use', () async {
      when(() => mockRepo.registerWithEmailOnly('exists@example.com', 'pass', 'Name'))
          .thenAnswer((_) async => const Left(AuthFailure(code: 'email-already-in-use')));

      final states = <AuthState>[];
      cubit.stream.listen(states.add);

      await cubit.registerWithEmailOnly('exists@example.com', 'pass', 'Name');
      await pumpEventQueue();

      expect(states.length, 2);
      expect((states[1] as AuthError).message, 'email-already-in-use');
    });
  });

  group('loginWithGoogle', () {
    test('emits [loading, success] on successful Google login', () async {
      when(() => mockRepo.loginWithGoogle()).thenAnswer((_) async => const Right(null));

      final states = <AuthState>[];
      cubit.stream.listen(states.add);

      await cubit.loginWithGoogle();
      await pumpEventQueue();

      expect(states.length, 2);
      expect(states[0], isA<AuthLoading>());
      expect(states[1], isA<AuthSuccess>());
    });

    test('emits [loading, error] when Google login cancelled', () async {
      when(() => mockRepo.loginWithGoogle())
          .thenAnswer((_) async => const Left(AuthFailure(code: 'cancelled')));

      final states = <AuthState>[];
      cubit.stream.listen(states.add);

      await cubit.loginWithGoogle();
      await pumpEventQueue();

      expect(states.length, 2);
      expect((states[1] as AuthError).message, 'cancelled');
    });
  });

  group('resetPassword', () {
    test('emits [loading, success] on successful password reset request', () async {
      when(() => mockRepo.resetPassword('user@example.com')).thenAnswer((_) async => const Right(null));

      final states = <AuthState>[];
      cubit.stream.listen(states.add);

      await cubit.resetPassword('user@example.com');
      await pumpEventQueue();

      expect(states.length, 2);
      expect(states[0], isA<AuthLoading>());
      expect(states[1], isA<AuthSuccess>());
    });
  });

  group('logout', () {
    test('emits [loading, initial] on successful logout', () async {
      when(() => mockRepo.logout()).thenAnswer((_) async => const Right(null));

      final states = <AuthState>[];
      cubit.stream.listen(states.add);

      await cubit.logout();
      await pumpEventQueue();

      expect(states.length, 2);
      expect(states[0], isA<AuthLoading>());
      expect(states[1], isA<AuthInitial>());
    });

    test('emits [loading, error] when logout fails', () async {
      when(() => mockRepo.logout()).thenAnswer((_) async => const Left(ServerFailure()));

      final states = <AuthState>[];
      cubit.stream.listen(states.add);

      await cubit.logout();
      await pumpEventQueue();

      expect(states.length, 2);
      expect((states[1] as AuthError).message, 'server');
    });
  });
}
