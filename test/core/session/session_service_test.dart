import 'dart:async';

import 'package:doctor_hunt/core/constants/supabase_constants.dart';
import 'package:doctor_hunt/core/session/session_service.dart';
import 'package:doctor_hunt/core/session/session_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}
class MockGoTrueClient extends Mock implements GoTrueClient {}
class MockUser extends Mock implements User {}
class MockSession extends Mock implements Session {}
class MockSupabaseQueryBuilder extends Mock implements SupabaseQueryBuilder {}
class MockPostgrestFilterBuilder extends Mock implements PostgrestFilterBuilder<List<Map<String, dynamic>>> {}

class FakeTransformBuilder<T> extends Fake implements PostgrestTransformBuilder<T> {
  FakeTransformBuilder(this._future);
  final Future<T> _future;

  @override
  Future<R> then<R>(FutureOr<R> Function(T value) onValue, {Function? onError}) {
    return _future.then(onValue, onError: onError);
  }
}

void main() {
  late MockSupabaseClient mockSupabase;
  late MockGoTrueClient mockAuth;
  late MockSupabaseQueryBuilder mockQueryBuilder;
  late MockPostgrestFilterBuilder mockFilterBuilder;
  late StreamController<AuthState> authController;

  setUp(() {
    mockSupabase = MockSupabaseClient();
    mockAuth = MockGoTrueClient();
    mockQueryBuilder = MockSupabaseQueryBuilder();
    mockFilterBuilder = MockPostgrestFilterBuilder();
    authController = StreamController<AuthState>.broadcast();

    when(() => mockSupabase.auth).thenReturn(mockAuth);
    when(() => mockAuth.onAuthStateChange).thenAnswer((_) => authController.stream);
    when(() => mockSupabase.from(SbC.profiles)).thenAnswer((_) => mockQueryBuilder);
    when(() => mockQueryBuilder.select()).thenAnswer((_) => mockFilterBuilder);
  });

  tearDown(() {
    authController.close();
  });

  group('SessionService - Initial State and Properties', () {
    test('initializes with SessionState.initial', () {
      final service = SessionService(supabase: mockSupabase);
      expect(service.value, const SessionState.initial());
      expect(service.isPasswordRecovery, isFalse);
      service.dispose();
    });

    test('exposes currentUser and currentUserId from Supabase auth', () {
      final mockUser = MockUser();
      when(() => mockUser.id).thenReturn('user-abc');
      when(() => mockAuth.currentUser).thenReturn(mockUser);

      final service = SessionService(supabase: mockSupabase);
      expect(service.currentUser, mockUser);
      expect(service.currentUserId, 'user-abc');
      service.dispose();
    });

    test('setting isPasswordRecovery notifies listeners when changed', () {
      final service = SessionService(supabase: mockSupabase);
      int notificationCount = 0;
      service.addListener(() => notificationCount++);

      service.isPasswordRecovery = true;
      expect(notificationCount, 1);
      expect(service.isPasswordRecovery, isTrue);

      // Setting same value should not notify
      service.isPasswordRecovery = true;
      expect(notificationCount, 1);

      service.isPasswordRecovery = false;
      expect(notificationCount, 2);
      expect(service.isPasswordRecovery, isFalse);

      service.dispose();
    });
  });

  group('SessionService - Authentication State Transitions', () {
    test('emits unauthenticated when session/user is null (sign out)', () async {
      final service = SessionService(supabase: mockSupabase);

      authController.add(const AuthState(AuthChangeEvent.signedOut, null));
      await pumpEventQueue();

      expect(service.value, const SessionState.unauthenticated());
      service.dispose();
    });

    test('emits authenticated with patient role when profile exists and is active', () async {
      final mockUser = MockUser();
      when(() => mockUser.id).thenReturn('patient-001');
      final mockSession = MockSession();
      when(() => mockSession.user).thenReturn(mockUser);

      when(() => mockFilterBuilder.eq('id', 'patient-001')).thenAnswer((_) => mockFilterBuilder);
      when(() => mockFilterBuilder.maybeSingle()).thenAnswer(
        (_) => FakeTransformBuilder<Map<String, dynamic>?>(
          Future.value({
            'id': 'patient-001',
            SbC.isActive: true,
            SbC.role: 'patient',
          }),
        ),
      );

      final service = SessionService(supabase: mockSupabase);
      authController.add(AuthState(AuthChangeEvent.signedIn, mockSession));
      await pumpEventQueue();

      expect(
        service.value,
        const SessionState.authenticated(userId: 'patient-001', role: 'patient'),
      );
      service.dispose();
    });

    test('emits authenticated with doctor role when profile exists and is active', () async {
      final mockUser = MockUser();
      when(() => mockUser.id).thenReturn('doctor-001');
      final mockSession = MockSession();
      when(() => mockSession.user).thenReturn(mockUser);

      when(() => mockFilterBuilder.eq('id', 'doctor-001')).thenAnswer((_) => mockFilterBuilder);
      when(() => mockFilterBuilder.maybeSingle()).thenAnswer(
        (_) => FakeTransformBuilder<Map<String, dynamic>?>(
          Future.value({
            'id': 'doctor-001',
            SbC.isActive: true,
            SbC.role: 'doctor',
          }),
        ),
      );

      final service = SessionService(supabase: mockSupabase);
      authController.add(AuthState(AuthChangeEvent.signedIn, mockSession));
      await pumpEventQueue();

      expect(
        service.value,
        const SessionState.authenticated(userId: 'doctor-001', role: 'doctor'),
      );
      service.dispose();
    });

    test('emits authenticatedWithoutProfile when user exists in auth but has no profile row', () async {
      final mockUser = MockUser();
      when(() => mockUser.id).thenReturn('new-user-001');
      final mockSession = MockSession();
      when(() => mockSession.user).thenReturn(mockUser);

      when(() => mockFilterBuilder.eq('id', 'new-user-001')).thenAnswer((_) => mockFilterBuilder);
      when(() => mockFilterBuilder.maybeSingle()).thenAnswer(
        (_) => FakeTransformBuilder<Map<String, dynamic>?>(Future.value(null)),
      );

      final service = SessionService(supabase: mockSupabase);
      authController.add(AuthState(AuthChangeEvent.signedIn, mockSession));
      await pumpEventQueue();

      expect(
        service.value,
        const SessionState.authenticatedWithoutProfile(userId: 'new-user-001'),
      );
      service.dispose();
    });

    test('emits authenticatedWithoutProfile when profile exists but role is missing', () async {
      final mockUser = MockUser();
      when(() => mockUser.id).thenReturn('incomplete-user-001');
      final mockSession = MockSession();
      when(() => mockSession.user).thenReturn(mockUser);

      when(() => mockFilterBuilder.eq('id', 'incomplete-user-001')).thenAnswer((_) => mockFilterBuilder);
      when(() => mockFilterBuilder.maybeSingle()).thenAnswer(
        (_) => FakeTransformBuilder<Map<String, dynamic>?>(
          Future.value({
            'id': 'incomplete-user-001',
            SbC.isActive: true,
            SbC.role: null,
          }),
        ),
      );

      final service = SessionService(supabase: mockSupabase);
      authController.add(AuthState(AuthChangeEvent.signedIn, mockSession));
      await pumpEventQueue();

      expect(
        service.value,
        const SessionState.authenticatedWithoutProfile(userId: 'incomplete-user-001'),
      );
      service.dispose();
    });

    test('emits authenticatedInactive when profile isActive is false', () async {
      final mockUser = MockUser();
      when(() => mockUser.id).thenReturn('deactivated-user-001');
      final mockSession = MockSession();
      when(() => mockSession.user).thenReturn(mockUser);

      when(() => mockFilterBuilder.eq('id', 'deactivated-user-001')).thenAnswer((_) => mockFilterBuilder);
      when(() => mockFilterBuilder.maybeSingle()).thenAnswer(
        (_) => FakeTransformBuilder<Map<String, dynamic>?>(
          Future.value({
            'id': 'deactivated-user-001',
            SbC.isActive: false,
            SbC.role: 'patient',
          }),
        ),
      );

      final service = SessionService(supabase: mockSupabase);
      authController.add(AuthState(AuthChangeEvent.signedIn, mockSession));
      await pumpEventQueue();

      expect(
        service.value,
        const SessionState.authenticatedInactive(userId: 'deactivated-user-001'),
      );
      service.dispose();
    });

    test('passwordRecovery event sets isPasswordRecovery and suppresses auth redirection', () async {
      final service = SessionService(supabase: mockSupabase);

      authController.add(const AuthState(AuthChangeEvent.passwordRecovery, null));
      await pumpEventQueue();

      expect(service.isPasswordRecovery, isTrue);
      // State remains initial since password recovery suppresses redirect
      expect(service.value, const SessionState.initial());
      service.dispose();
    });

    test('refreshProfile re-evaluates currentUser session state', () async {
      final mockUser = MockUser();
      when(() => mockUser.id).thenReturn('refresh-user-001');
      when(() => mockAuth.currentUser).thenReturn(mockUser);

      when(() => mockFilterBuilder.eq('id', 'refresh-user-001')).thenAnswer((_) => mockFilterBuilder);
      when(() => mockFilterBuilder.maybeSingle()).thenAnswer(
        (_) => FakeTransformBuilder<Map<String, dynamic>?>(
          Future.value({
            'id': 'refresh-user-001',
            SbC.isActive: true,
            SbC.role: 'patient',
          }),
        ),
      );

      final service = SessionService(supabase: mockSupabase);
      expect(service.value, const SessionState.initial());

      await service.refreshProfile();

      expect(
        service.value,
        const SessionState.authenticated(userId: 'refresh-user-001', role: 'patient'),
      );
      service.dispose();
    });
  });

  group('SessionService - Error, Retry, and Concurrency', () {
    testWidgets('retries on profile query failure and succeeds on subsequent attempt', (tester) async {
      final mockUser = MockUser();
      when(() => mockUser.id).thenReturn('retry-user-001');
      final mockSession = MockSession();
      when(() => mockSession.user).thenReturn(mockUser);

      when(() => mockFilterBuilder.eq('id', 'retry-user-001')).thenAnswer((_) => mockFilterBuilder);

      int attempts = 0;
      when(() => mockFilterBuilder.maybeSingle()).thenAnswer((_) {
        attempts++;
        if (attempts == 1) {
          return FakeTransformBuilder<Map<String, dynamic>?>(
            Future.error(Exception('Network glitch')),
          );
        }
        return FakeTransformBuilder<Map<String, dynamic>?>(
          Future.value({
            'id': 'retry-user-001',
            SbC.isActive: true,
            SbC.role: 'patient',
          }),
        );
      });

      final service = SessionService(supabase: mockSupabase);
      authController.add(AuthState(AuthChangeEvent.signedIn, mockSession));

      await tester.pump();
      expect(attempts, 1);
      expect(service.value, const SessionState.initial());

      // Advance retry delay of 1 second
      await tester.pump(const Duration(seconds: 1, milliseconds: 100));
      expect(attempts, 2);
      expect(
        service.value,
        const SessionState.authenticated(userId: 'retry-user-001', role: 'patient'),
      );
      service.dispose();
    });

    testWidgets('emits error state after 3 failed profile query attempts', (tester) async {
      final mockUser = MockUser();
      when(() => mockUser.id).thenReturn('failing-user-001');
      final mockSession = MockSession();
      when(() => mockSession.user).thenReturn(mockUser);

      when(() => mockFilterBuilder.eq('id', 'failing-user-001')).thenAnswer((_) => mockFilterBuilder);
      when(() => mockFilterBuilder.maybeSingle()).thenAnswer(
        (_) => FakeTransformBuilder<Map<String, dynamic>?>(
          Future.error(Exception('Persistent connection failure')),
        ),
      );

      final service = SessionService(supabase: mockSupabase);
      authController.add(AuthState(AuthChangeEvent.signedIn, mockSession));

      await tester.pump();
      // Attempt 1 fails, waits 1 second
      await tester.pump(const Duration(seconds: 1));
      // Attempt 2 fails, waits 1 second
      await tester.pump(const Duration(seconds: 1));
      // Attempt 3 fails, emits error
      await tester.pump(const Duration(milliseconds: 100));

      expect(
        service.value,
        const SessionState.error('Failed to load profile. Please check your connection.'),
      );
      service.dispose();
    });

    testWidgets('handles consecutive pending user changes gracefully during evaluation', (tester) async {
      final mockUser1 = MockUser();
      when(() => mockUser1.id).thenReturn('user-one');
      final mockUser2 = MockUser();
      when(() => mockUser2.id).thenReturn('user-two');

      final mockSession1 = MockSession();
      when(() => mockSession1.user).thenReturn(mockUser1);
      final mockSession2 = MockSession();
      when(() => mockSession2.user).thenReturn(mockUser2);

      when(() => mockFilterBuilder.eq('id', 'user-one')).thenAnswer((_) => mockFilterBuilder);
      when(() => mockFilterBuilder.eq('id', 'user-two')).thenAnswer((_) => mockFilterBuilder);

      when(() => mockFilterBuilder.maybeSingle()).thenAnswer((_) {
        return FakeTransformBuilder<Map<String, dynamic>?>(
          Future.delayed(const Duration(milliseconds: 200), () => {
            'id': 'user-two',
            SbC.isActive: true,
            SbC.role: 'doctor',
          }),
        );
      });

      final service = SessionService(supabase: mockSupabase);
      authController.add(AuthState(AuthChangeEvent.signedIn, mockSession1));
      // Immediately trigger second user while first is in-flight
      authController.add(AuthState(AuthChangeEvent.signedIn, mockSession2));

      await tester.pump(const Duration(milliseconds: 500));

      expect(
        service.value,
        const SessionState.authenticated(userId: 'user-two', role: 'doctor'),
      );
      service.dispose();
    });
  });
}
