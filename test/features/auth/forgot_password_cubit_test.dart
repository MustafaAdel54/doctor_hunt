import 'package:dartz/dartz.dart';
import 'package:doctor_hunt/core/error/failures.dart';
import 'package:doctor_hunt/core/session/session_service.dart';
import 'package:doctor_hunt/features/auth/cubit/forgot_password_cubit.dart';
import 'package:doctor_hunt/features/auth/cubit/forgot_password_state.dart';
import 'package:doctor_hunt/features/auth/repo/auth_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepo extends Mock implements AuthRepo {}

class MockSessionService extends Mock implements SessionService {}

void main() {
  late MockAuthRepo mockRepo;
  late MockSessionService mockSessionService;
  late ForgotPasswordCubit cubit;

  setUp(() {
    mockRepo = MockAuthRepo();
    mockSessionService = MockSessionService();
    cubit = ForgotPasswordCubit(
      repo: mockRepo,
      sessionService: mockSessionService,
    );
  });

  tearDown(() {
    // Avoid double close in tests that already closed the cubit
    if (!cubit.isClosed) {
      when(() => mockSessionService.isPasswordRecovery).thenReturn(false);
      cubit.close();
    }
  });

  test('initial state has default values', () {
    expect(cubit.state, const ForgotPasswordState());
    expect(cubit.state.step, ForgotPasswordStep.email);
    expect(cubit.state.email, '');
    expect(cubit.state.otp, '');
    expect(cubit.state.isLoading, false);
    expect(cubit.state.errorMessage, isNull);
    expect(cubit.state.isSuccess, false);
  });

  group('sendOtp', () {
    test('emits [loading, step: otp] on success', () async {
      when(() => mockRepo.resetPassword('test@example.com'))
          .thenAnswer((_) async => const Right(null));

      final states = <ForgotPasswordState>[];
      cubit.stream.listen(states.add);

      await cubit.sendOtp('  test@example.com  ');
      await pumpEventQueue();

      expect(states.length, 2);
      expect(states[0].isLoading, true);
      expect(states[0].errorMessage, isNull);

      expect(states[1].isLoading, false);
      expect(states[1].email, 'test@example.com');
      expect(states[1].step, ForgotPasswordStep.otp);
      expect(states[1].errorMessage, isNull);
    });

    test('emits [loading, error] with failure code on failure', () async {
      when(() => mockRepo.resetPassword('test@example.com')).thenAnswer(
          (_) async => const Left(AuthFailure(code: 'user-not-found')));

      final states = <ForgotPasswordState>[];
      cubit.stream.listen(states.add);

      await cubit.sendOtp('test@example.com');
      await pumpEventQueue();

      expect(states.length, 2);
      expect(states[0].isLoading, true);
      expect(states[1].isLoading, false);
      expect(states[1].errorMessage, 'user-not-found');
      expect(states[1].step, ForgotPasswordStep.email);
    });

    test('maps NetworkFailure to network code', () async {
      when(() => mockRepo.resetPassword('test@example.com'))
          .thenAnswer((_) async => const Left(NetworkFailure()));

      await cubit.sendOtp('test@example.com');

      expect(cubit.state.errorMessage, 'network');
    });

    test('maps ServerFailure to server code', () async {
      when(() => mockRepo.resetPassword('test@example.com'))
          .thenAnswer((_) async => const Left(ServerFailure()));

      await cubit.sendOtp('test@example.com');

      expect(cubit.state.errorMessage, 'server');
    });
  });

  group('resendOtp', () {
    test('does nothing when state email is empty', () async {
      await cubit.resendOtp();

      verifyNever(() => mockRepo.resetPassword(any()));
      expect(cubit.state.isLoading, false);
    });

    test('emits [loading, not loading] on success when email exists', () async {
      when(() => mockRepo.resetPassword('test@example.com'))
          .thenAnswer((_) async => const Right(null));

      await cubit.sendOtp('test@example.com');

      final states = <ForgotPasswordState>[];
      cubit.stream.listen(states.add);

      await cubit.resendOtp();
      await pumpEventQueue();

      expect(states.length, 2);
      expect(states[0].isLoading, true);
      expect(states[1].isLoading, false);
      expect(states[1].errorMessage, isNull);
    });

    test('emits [loading, error] on resend failure', () async {
      when(() => mockRepo.resetPassword('test@example.com'))
          .thenAnswer((_) async => const Right(null));
      await cubit.sendOtp('test@example.com');

      when(() => mockRepo.resetPassword('test@example.com'))
          .thenAnswer((_) async => const Left(ServerFailure()));

      final states = <ForgotPasswordState>[];
      cubit.stream.listen(states.add);

      await cubit.resendOtp();
      await pumpEventQueue();

      expect(states.length, 2);
      expect(states[0].isLoading, true);
      expect(states[1].isLoading, false);
      expect(states[1].errorMessage, 'server');
    });
  });

  group('verifyOtp', () {
    test('sets isPasswordRecovery to true and advances to resetPassword on success', () async {
      when(() => mockRepo.resetPassword('test@example.com'))
          .thenAnswer((_) async => const Right(null));
      await cubit.sendOtp('test@example.com');

      when(() => mockRepo.verifyOtp(email: 'test@example.com', token: '123456'))
          .thenAnswer((_) async => const Right(null));

      final states = <ForgotPasswordState>[];
      cubit.stream.listen(states.add);

      await cubit.verifyOtp(' 123456 ');
      await pumpEventQueue();

      verify(() => mockSessionService.isPasswordRecovery = true).called(1);
      expect(states.length, 2);
      expect(states[0].isLoading, true);
      expect(states[1].isLoading, false);
      expect(states[1].otp, '123456');
      expect(states[1].step, ForgotPasswordStep.resetPassword);
      expect(states[1].errorMessage, isNull);
    });

    test('resets isPasswordRecovery to false on failure', () async {
      when(() => mockRepo.resetPassword('test@example.com'))
          .thenAnswer((_) async => const Right(null));
      await cubit.sendOtp('test@example.com');

      when(() => mockRepo.verifyOtp(email: 'test@example.com', token: '000000'))
          .thenAnswer((_) async => const Left(AuthFailure(code: 'invalid-otp')));

      final states = <ForgotPasswordState>[];
      cubit.stream.listen(states.add);

      await cubit.verifyOtp('000000');
      await pumpEventQueue();

      verify(() => mockSessionService.isPasswordRecovery = true).called(1);
      verify(() => mockSessionService.isPasswordRecovery = false).called(1);
      expect(states.length, 2);
      expect(states[1].isLoading, false);
      expect(states[1].errorMessage, 'invalid-otp');
      expect(states[1].step, ForgotPasswordStep.otp);
    });
  });

  group('updatePassword', () {
    test('logs out, resets recovery flag, and emits isSuccess on success', () async {
      when(() => mockRepo.updatePassword('newPassword123'))
          .thenAnswer((_) async => const Right(null));
      when(() => mockRepo.logout()).thenAnswer((_) async => const Right(null));

      final states = <ForgotPasswordState>[];
      cubit.stream.listen(states.add);

      await cubit.updatePassword('newPassword123');
      await pumpEventQueue();

      verify(() => mockRepo.logout()).called(1);
      verify(() => mockSessionService.isPasswordRecovery = false).called(1);
      expect(states.length, 2);
      expect(states[0].isLoading, true);
      expect(states[1].isLoading, false);
      expect(states[1].isSuccess, true);
      expect(states[1].errorMessage, isNull);
    });

    test('emits error on update password failure', () async {
      when(() => mockRepo.updatePassword('short'))
          .thenAnswer((_) async => const Left(AuthFailure(code: 'weak-password')));

      final states = <ForgotPasswordState>[];
      cubit.stream.listen(states.add);

      await cubit.updatePassword('short');
      await pumpEventQueue();

      verifyNever(() => mockRepo.logout());
      expect(states.length, 2);
      expect(states[0].isLoading, true);
      expect(states[1].isLoading, false);
      expect(states[1].errorMessage, 'weak-password');
      expect(states[1].isSuccess, false);
    });
  });

  group('navigation and error helpers', () {
    test('backToEmail sets step to email and clears error', () {
      cubit.emit(cubit.state.copyWith(
        step: ForgotPasswordStep.otp,
        errorMessage: 'some-error',
      ));

      cubit.backToEmail();

      expect(cubit.state.step, ForgotPasswordStep.email);
      expect(cubit.state.errorMessage, isNull);
    });

    test('clearError resets errorMessage to null', () {
      cubit.emit(cubit.state.copyWith(errorMessage: 'err'));
      expect(cubit.state.errorMessage, 'err');

      cubit.clearError();

      expect(cubit.state.errorMessage, isNull);
    });
  });

  group('close', () {
    test('logs out and resets recovery flag if recovery was active on close', () async {
      when(() => mockSessionService.isPasswordRecovery).thenReturn(true);
      when(() => mockRepo.logout()).thenAnswer((_) async => const Right(null));

      await cubit.close();

      verify(() => mockSessionService.isPasswordRecovery = false).called(1);
      verify(() => mockRepo.logout()).called(1);
    });

    test('does not logout if recovery was not active on close', () async {
      when(() => mockSessionService.isPasswordRecovery).thenReturn(false);

      await cubit.close();

      verifyNever(() => mockRepo.logout());
    });
  });
}
