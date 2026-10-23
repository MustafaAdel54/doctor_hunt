import 'package:dartz/dartz.dart';
import 'package:doctor_hunt/core/error/failures.dart';
import 'package:doctor_hunt/core/network/network_info.dart';
import 'package:doctor_hunt/features/auth/models/user_model.dart';
import 'package:doctor_hunt/features/auth/repo/auth_repo_impl.dart';
import 'package:doctor_hunt/features/auth/service/auth_service.dart';
import 'package:doctor_hunt/features/profile/service/profile_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockAuthService extends Mock implements AuthService {}
class MockProfileService extends Mock implements ProfileService {}
class MockNetworkInfo extends Mock implements NetworkInfo {}
class MockUser extends Mock implements User {}

void main() {
  late MockAuthService mockAuthService;
  late MockProfileService mockProfileService;
  late MockNetworkInfo mockNetworkInfo;
  late AuthRepoImpl authRepo;

  const testUser = UserModel(
    uid: 'user-001',
    email: 'test@example.com',
    name: 'Test Patient',
    role: 'patient',
  );

  setUp(() {
    mockAuthService = MockAuthService();
    mockProfileService = MockProfileService();
    mockNetworkInfo = MockNetworkInfo();
    authRepo = AuthRepoImpl(
      service: mockAuthService,
      profileService: mockProfileService,
      networkInfo: mockNetworkInfo,
    );
  });

  group('AuthRepoImpl - Network Connectivity Failure', () {
    setUp(() {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    });

    test('loginWithEmail returns NetworkFailure when offline', () async {
      final result = await authRepo.loginWithEmail('test@example.com', 'password123');
      expect(result, const Left(NetworkFailure()));
      verifyZeroInteractions(mockAuthService);
    });

    test('registerWithEmailOnly returns NetworkFailure when offline', () async {
      final result = await authRepo.registerWithEmailOnly('test@example.com', 'password123', 'Name');
      expect(result, const Left(NetworkFailure()));
      verifyZeroInteractions(mockAuthService);
    });

    test('loginWithGoogle returns NetworkFailure when offline', () async {
      final result = await authRepo.loginWithGoogle();
      expect(result, const Left(NetworkFailure()));
      verifyZeroInteractions(mockAuthService);
    });

    test('resetPassword returns NetworkFailure when offline', () async {
      final result = await authRepo.resetPassword('test@example.com');
      expect(result, const Left(NetworkFailure()));
      verifyZeroInteractions(mockAuthService);
    });

    test('verifyOtp returns NetworkFailure when offline', () async {
      final result = await authRepo.verifyOtp(email: 'test@example.com', token: '123456');
      expect(result, const Left(NetworkFailure()));
      verifyZeroInteractions(mockAuthService);
    });

    test('updatePassword returns NetworkFailure when offline', () async {
      final result = await authRepo.updatePassword('newPassword123');
      expect(result, const Left(NetworkFailure()));
      verifyZeroInteractions(mockAuthService);
    });

    test('logout returns NetworkFailure when offline', () async {
      final result = await authRepo.logout();
      expect(result, const Left(NetworkFailure()));
      verifyZeroInteractions(mockAuthService);
    });
  });

  group('AuthRepoImpl - Successful Operations', () {
    setUp(() {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });

    test('loginWithEmail returns Right(UserModel) on success', () async {
      when(() => mockAuthService.loginWithEmail('test@example.com', 'password123'))
          .thenAnswer((_) async => testUser);

      final result = await authRepo.loginWithEmail('test@example.com', 'password123');

      expect(result, const Right(testUser));
      verify(() => mockAuthService.loginWithEmail('test@example.com', 'password123')).called(1);
    });

    test('registerWithEmailOnly returns Right(null) on success', () async {
      final mockUser = MockUser();
      when(() => mockAuthService.registerWithEmailOnly('test@example.com', 'pass123', 'Test Patient'))
          .thenAnswer((_) async => mockUser);

      final result = await authRepo.registerWithEmailOnly('test@example.com', 'pass123', 'Test Patient');

      expect(result, const Right(null));
      verify(() => mockAuthService.registerWithEmailOnly('test@example.com', 'pass123', 'Test Patient')).called(1);
    });

    test('loginWithGoogle returns Right(null) on success', () async {
      final mockUser = MockUser();
      when(() => mockAuthService.loginWithGoogle()).thenAnswer((_) async => mockUser);

      final result = await authRepo.loginWithGoogle();

      expect(result, const Right(null));
      verify(() => mockAuthService.loginWithGoogle()).called(1);
    });

    test('resetPassword returns Right(null) on success', () async {
      when(() => mockAuthService.resetPassword('test@example.com')).thenAnswer((_) async {});

      final result = await authRepo.resetPassword('test@example.com');

      expect(result, const Right(null));
      verify(() => mockAuthService.resetPassword('test@example.com')).called(1);
    });

    test('verifyOtp returns Right(null) on success', () async {
      when(() => mockAuthService.verifyOtp(email: 'test@example.com', token: '654321'))
          .thenAnswer((_) async {});

      final result = await authRepo.verifyOtp(email: 'test@example.com', token: '654321');

      expect(result, const Right(null));
      verify(() => mockAuthService.verifyOtp(email: 'test@example.com', token: '654321')).called(1);
    });

    test('updatePassword returns Right(null) on success', () async {
      when(() => mockAuthService.updatePassword('newPass456')).thenAnswer((_) async {});

      final result = await authRepo.updatePassword('newPass456');

      expect(result, const Right(null));
      verify(() => mockAuthService.updatePassword('newPass456')).called(1);
    });

    test('logout returns Right(null) on success', () async {
      when(() => mockAuthService.logout()).thenAnswer((_) async {});

      final result = await authRepo.logout();

      expect(result, const Right(null));
      verify(() => mockAuthService.logout()).called(1);
    });
  });

  group('AuthRepoImpl - Supabase Exception Mapping', () {
    setUp(() {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });

    test('maps invalid login credentials to AuthFailure(invalid-credential)', () async {
      when(() => mockAuthService.loginWithEmail('bad@example.com', 'wrong'))
          .thenThrow(const AuthException('Invalid login credentials'));

      final result = await authRepo.loginWithEmail('bad@example.com', 'wrong');

      expect(result, const Left(AuthFailure(code: 'invalid-credential')));
    });

    test('maps user already registered to AuthFailure(email-already-in-use)', () async {
      when(() => mockAuthService.registerWithEmailOnly('exists@example.com', 'pass', 'Name'))
          .thenThrow(const AuthException('User already registered'));

      final result = await authRepo.registerWithEmailOnly('exists@example.com', 'pass', 'Name');

      expect(result, const Left(AuthFailure(code: 'email-already-in-use')));
    });

    test('maps expired/invalid token to AuthFailure(invalid-otp)', () async {
      when(() => mockAuthService.verifyOtp(email: 'test@example.com', token: '000000'))
          .thenThrow(const AuthException('Token has expired or is invalid', code: 'otp_expired'));

      final result = await authRepo.verifyOtp(email: 'test@example.com', token: '000000');

      expect(result, const Left(AuthFailure(code: 'invalid-otp')));
    });

    test('maps rate limit to AuthFailure(too-many-requests)', () async {
      when(() => mockAuthService.resetPassword('test@example.com'))
          .thenThrow(const AuthException('For security purposes, you can only request this once every 60 seconds', code: 'rate_limit'));

      final result = await authRepo.resetPassword('test@example.com');

      expect(result, const Left(AuthFailure(code: 'too-many-requests')));
    });

    test('maps user disabled to AuthFailure(user-disabled)', () async {
      when(() => mockAuthService.loginWithEmail('disabled@example.com', 'pass'))
          .thenThrow(const AuthException('User account is disabled'));

      final result = await authRepo.loginWithEmail('disabled@example.com', 'pass');

      expect(result, const Left(AuthFailure(code: 'user-disabled')));
    });

    test('maps weak password to AuthFailure(weak-password)', () async {
      when(() => mockAuthService.updatePassword('123'))
          .thenThrow(const AuthException('Password should be at least 6 characters (weak password)'));

      final result = await authRepo.updatePassword('123');

      expect(result, const Left(AuthFailure(code: 'weak-password')));
    });

    test('maps cancelled Google sign-in to AuthFailure(cancelled)', () async {
      when(() => mockAuthService.loginWithGoogle())
          .thenThrow(const AuthException('Google sign in cancelled'));

      final result = await authRepo.loginWithGoogle();

      expect(result, const Left(AuthFailure(code: 'cancelled')));
    });

    test('maps Postgrest 23505 unique violation to AuthFailure(account-already-setup)', () async {
      when(() => mockAuthService.loginWithEmail('test@example.com', 'pass'))
          .thenThrow(const PostgrestException(message: 'duplicate key value violates unique constraint', code: '23505'));

      final result = await authRepo.loginWithEmail('test@example.com', 'pass');

      expect(result, const Left(AuthFailure(code: 'account-already-setup')));
    });

    test('maps unexpected PostgrestException to ServerFailure', () async {
      when(() => mockAuthService.loginWithEmail('test@example.com', 'pass'))
          .thenThrow(const PostgrestException(message: 'Relation does not exist', code: '42P01'));

      final result = await authRepo.loginWithEmail('test@example.com', 'pass');

      expect(result, const Left(ServerFailure()));
    });

    test('maps unexpected generic exception to ServerFailure', () async {
      when(() => mockAuthService.logout())
          .thenThrow(Exception('Socket connection aborted'));

      final result = await authRepo.logout();

      expect(result, const Left(ServerFailure()));
    });
  });
}
