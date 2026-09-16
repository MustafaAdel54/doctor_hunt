import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'apps/core/di/injector.dart';
import 'apps/core/router/app_router.dart';
import 'apps/core/session/session_service.dart';
import 'i18n/strings.g.dart';
import 'apps/main/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await initCore();

  LocaleSettings.useDeviceLocale();

  final router = createRouter(sl<SessionService>());

  runApp(TranslationProvider(child: MyApp(router: router)));
}
