import 'package:doctor_hunt/features/settings/screens/privacy_policy_screen.dart';
import 'package:doctor_hunt/features/settings/screens/widgets/logout_dialog.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() {
    LocaleSettings.setLocale(AppLocale.en);
  });

  group('PrivacyPolicyScreen Widget Tests', () {
    testWidgets('renders headline, paragraphs, and bullet points', (tester) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (_, __) => const MaterialApp(
            home: PrivacyPolicyScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(t.privacyPolicy.title), findsOneWidget);
      expect(find.text(t.privacyPolicy.headline), findsOneWidget);
      expect(find.text(t.privacyPolicy.paragraph1), findsOneWidget);
      expect(find.text(t.privacyPolicy.bullet1), findsOneWidget);
      expect(find.text(t.privacyPolicy.bullet2), findsOneWidget);
    });
  });

  group('LogoutDialog Widget Tests', () {
    testWidgets('shows confirmation dialog and returns false on cancel', (tester) async {
      bool? dialogResult;

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (_, __) => MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: ElevatedButton(
                  onPressed: () async {
                    dialogResult = await showLogoutConfirmationDialog(context);
                  },
                  child: const Text('Open Dialog'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.text(t.settings.logoutConfirmTitle), findsOneWidget);
      expect(find.text(t.settings.logoutConfirmMessage), findsOneWidget);
      expect(find.text(t.common.cancel), findsOneWidget);
      expect(find.text(t.settings.ok), findsOneWidget);

      await tester.tap(find.text(t.common.cancel));
      await tester.pumpAndSettle();

      expect(dialogResult, isFalse);
    });

    testWidgets('shows confirmation dialog and returns true on OK', (tester) async {
      bool? dialogResult;

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (_, __) => MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: ElevatedButton(
                  onPressed: () async {
                    dialogResult = await showLogoutConfirmationDialog(context);
                  },
                  child: const Text('Open Dialog'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      await tester.tap(find.text(t.settings.ok));
      await tester.pumpAndSettle();

      expect(dialogResult, isTrue);
    });
  });
}
