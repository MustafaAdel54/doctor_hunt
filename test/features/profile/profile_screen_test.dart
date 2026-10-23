import 'package:dartz/dartz.dart';
import 'package:doctor_hunt/core/di/injector.dart';
import 'package:doctor_hunt/core/session/session_service.dart';
import 'package:doctor_hunt/core/session/session_state.dart';
import 'package:doctor_hunt/features/auth/models/user_model.dart';
import 'package:doctor_hunt/features/profile/cubit/profile_cubit.dart';
import 'package:doctor_hunt/features/profile/repo/profile_repo.dart';
import 'package:doctor_hunt/features/profile/screens/edit_profile/edit_profile_screen.dart';
import 'package:doctor_hunt/features/profile/screens/profile/profile_screen.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    LocaleSettings.setLocale(AppLocale.en);
  });

  group('ProfileScreen & EditProfileScreen Widget Tests', () {
    late MockProfileRepo mockRepo;
    late MockSessionService mockSession;

    const testUser = UserModel(
      uid: 'p-1234',
      email: 'patient@example.com',
      role: 'patient',
      name: 'Abdullah Mamun',
      phone: '+8801800000000',
    );

    setUp(() {
      mockRepo = MockProfileRepo();
      mockSession = MockSessionService();

      when(() => mockSession.currentUserId).thenReturn(testUser.uid);
      when(() => mockSession.value).thenReturn(
        const SessionState.authenticated(userId: 'p-1234', role: 'patient'),
      );
      when(() => mockSession.refreshProfile()).thenAnswer((_) async {});
      when(() => mockRepo.getProfile(testUser.uid))
          .thenAnswer((_) async => const Right(testUser));

      if (sl.isRegistered<SessionService>()) {
        sl.unregister<SessionService>();
      }
      sl.registerLazySingleton<SessionService>(() => mockSession);

      if (sl.isRegistered<ProfileCubit>()) {
        sl.unregister<ProfileCubit>();
      }
      sl.registerFactory(() => ProfileCubit(repo: mockRepo, sessionService: mockSession));
    });

    tearDown(() {
      if (sl.isRegistered<SessionService>()) sl.unregister<SessionService>();
      if (sl.isRegistered<ProfileCubit>()) sl.unregister<ProfileCubit>();
    });

    testWidgets('ProfileScreen renders header, personal information, and Continue button', (tester) async {
      tester.view.physicalSize = const Size(1125, 2436);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (_, __) => const MaterialApp(
            home: ProfileScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(t.profile.title), findsOneWidget);
      expect(find.text(t.profile.personalInfo), findsOneWidget);
      expect(find.text(t.profile.name), findsOneWidget);
      expect(find.text('Abdullah Mamun'), findsOneWidget);
      expect(find.text(t.profile.contactNumber), findsOneWidget);
      expect(find.text('+8801800000000'), findsOneWidget);
      expect(find.text(t.profile.continueText), findsOneWidget);
      expect(find.byIcon(Icons.edit_outlined), findsNWidgets(2));
    });

    testWidgets('EditProfileScreen initializes fields with user data and validates name requirement', (tester) async {
      tester.view.physicalSize = const Size(1125, 2436);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (_, __) => const MaterialApp(
            home: EditProfileScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(t.profile.editProfile), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Abdullah Mamun'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, '+8801800000000'), findsOneWidget);

      // Clear the name field and tap Update to trigger validation error
      await tester.enterText(find.widgetWithText(TextFormField, 'Abdullah Mamun'), '');
      await tester.ensureVisible(find.text(t.profile.update));
      await tester.tap(find.text(t.profile.update));
      await tester.pumpAndSettle();

      expect(find.text(t.validation.required), findsOneWidget);
      verifyNever(() => mockRepo.updateProfile(any()));
    });
  });
}
