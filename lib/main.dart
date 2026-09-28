import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'apps/core/di/injector.dart';
import 'apps/core/router/app_router.dart';
import 'apps/core/session/session_service.dart';
import 'apps/core/constants/supabase_constants.dart';
import 'i18n/strings.g.dart';
import 'apps/main/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  await initCore();

  LocaleSettings.useDeviceLocale();

  final router = createRouter(sl<SessionService>());

  runApp(TranslationProvider(child: MyApp(router: router)));
}
