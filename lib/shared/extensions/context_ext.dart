import 'package:flutter/material.dart';

extension ContextExt on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  ColorScheme get colorScheme => theme.colorScheme;

  bool get isRtl => Directionality.of(this) == TextDirection.rtl;

  Locale get locale => Localizations.localeOf(this);
}
