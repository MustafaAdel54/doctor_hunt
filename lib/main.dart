import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/app/app.dart';
import 'core/constants/supabase_constants.dart';
import 'core/di/injector.dart';
import 'core/router/app_router.dart';
import 'core/session/session_service.dart';
import 'shared/i18n/strings.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.anonKey,
  );

  await initCore();

  LocaleSettings.useDeviceLocale();

  final router = createRouter(sl<SessionService>());

  runApp(TranslationProvider(child: MyApp(router: router)));
}
