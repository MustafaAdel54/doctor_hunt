import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  const SettingsService({required this.prefs});

  final SharedPreferences prefs;

  static const _keyTheme = 'theme_mode';

  String? getThemeMode() {
    return prefs.getString(_keyTheme);
  }

  Future<void> setThemeMode(String theme) async {
    await prefs.setString(_keyTheme, theme);
  }
}
