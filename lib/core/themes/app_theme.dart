import 'package:doctor_hunt/shared/generated/app_colors.dart';
import 'package:flutter/material.dart';

import 'font_family.dart';

abstract final class AppTheme {
  static ThemeData get light => _build(
    brightness: Brightness.light,
    extensions: const [AppColorsTheme.light],
    palette: AppColorsLight.palette,
  );

  static ThemeData _build({
    required Brightness brightness,
    required Iterable<ThemeExtension<dynamic>> extensions,
    required AppPalette palette,
  }) {
    return ThemeData(
      brightness: brightness,
      extensions: extensions,
      fontFamily: FontFamily.cairo,
      scaffoldBackgroundColor: palette.scaffold,
      colorScheme: ColorScheme.fromSeed(
        seedColor: palette.primary,
        brightness: brightness,
      ),
      textTheme: const TextTheme(
        // Base style used by the generator's WeightAtoms extension
        titleMedium: TextStyle(
          // Don't set colour here; that's handled by final colour getters
          // which pull from context.palette.
        ),
      ),
      // Prevent material widgets from forcing an overlay
      appBarTheme: AppBarTheme(backgroundColor: palette.scaffold, elevation: 0),
    );
  }
}
