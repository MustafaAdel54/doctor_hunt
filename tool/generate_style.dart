// Style atom generator — THEME-AWARE (light + dark).
//
// Run from the project root:
//   dart run tool/generate_style.dart
//
// Outputs:
//   lib/generated/style_atoms.dart   — 1,425 context getters
//
// Requires (hand-written, NOT generated):
//   lib/generated/app_colors.dart    — AppColorsLight / AppColorsDark + AppPalette
//
// This script lives in tool/ (NOT lib/) because it imports dart:io, which must
// never end up in the app bundle.

import 'dart:io';

// ---------------------------------------------------------------------------
// Configuration
// ---------------------------------------------------------------------------

/// Must match the fields of `AppPalette` exactly.
const List<String> kColors = <String>[
  'primary',
  'primaryLight',
  'primaryDark',
  'secondary',
  'secondaryLight',
  'secondaryDark',
  'textMain',
  'textSub',
  'textPlaceholder',
  'textBorders',
  'danger',
  'dangerLight',
  'success',
  'successLight',
  'warning',
  'warningLight',
  'white',
  'black',
  'boxShadow',
];

/// Cairo ships 200-900, so all five weights are real (no synthesis).
const Map<String, String> kFontWeights = <String, String>{
  'light': 'FontWeight.w300',
  'regular': 'FontWeight.w400',
  'medium': 'FontWeight.w500',
  'semiBold': 'FontWeight.w600',
  'bold': 'FontWeight.w700',
};

const List<int> kFontSizes = <int>[
  8, 11, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 36, 40, //
];

const String kOutputPath = 'lib/shared/generated/';
const String kOutputFile = 'style_atoms.dart';
const String kColorsImport = "import 'app_colors.dart';";

/// Font sizes are multiplied by ScreenUtil here so call sites never write `.sp`.
const bool kUseScreenUtil = true;

// ---------------------------------------------------------------------------

Future<void> main() async {
  final Directory dir = Directory(kOutputPath);
  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
  }

  final File file = File('$kOutputPath$kOutputFile');
  final IOSink sink = file.openWrite();

  _writeHeader(sink);
  _generatePaletteAccessor(sink);
  _generateWeightAtoms(sink);
  _generateFontSizeAtoms(sink);
  _generateWeightAndSizeMixes(sink);
  _generateFinalGetters(sink);

  await sink.flush();
  await sink.close();

  final int finals = kFontWeights.length * kFontSizes.length * kColors.length;
  stdout
    ..writeln('Generated $kOutputPath$kOutputFile')
    ..writeln(
      '  ${kFontWeights.length} weights x ${kFontSizes.length} sizes '
      'x ${kColors.length} colors = $finals final getters',
    )
    ..writeln('  theme-aware: colours resolve from AppColorsTheme at runtime');
}

void _writeHeader(IOSink sink) {
  sink
    ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND')
    ..writeln('// Regenerate with: dart run tool/generate_style.dart')
    ..writeln('//')
    ..writeln('// Colours resolve through Theme.of(context) so every getter')
    ..writeln(
      '// automatically returns the right value in light and dark mode.',
    )
    ..writeln('//')
    ..writeln('// coverage:ignore-file')
    ..writeln('// ignore_for_file: unused_element, lines_longer_than_80_chars')
    ..writeln()
    ..writeln("import 'package:flutter/material.dart';");

  if (kUseScreenUtil) {
    sink.writeln(
      "import 'package:flutter_screenutil/flutter_screenutil.dart';",
    );
  }

  sink
    ..writeln(kColorsImport)
    ..writeln();
}

/// The bridge between the static palettes and the widget tree.
///
/// `context.palette` returns the light or dark `AppPalette` depending on the
/// active theme. This is what makes dark mode work.
void _generatePaletteAccessor(IOSink sink) {
  sink
    ..writeln('/// Resolves the active colour palette from the widget tree.')
    ..writeln('///')
    ..writeln('/// Falls back to the light palette if the theme extension was')
    ..writeln('/// not registered, so a missing setup degrades instead of')
    ..writeln('/// throwing in every Text widget.')
    ..writeln('extension PaletteAccess on BuildContext {')
    ..writeln('  AppPalette get palette =>')
    ..writeln('      Theme.of(this).extension<AppColorsTheme>()?.palette ??')
    ..writeln('      AppColorsLight.palette;')
    ..writeln('}')
    ..writeln();
}

/// Layer 1: base style + font weight, on BuildContext.
void _generateWeightAtoms(IOSink sink) {
  sink
    ..writeln('extension WeightAtoms on BuildContext {')
    ..writeln('  /// Base style. Font family and default colour come from')
    ..writeln('  /// ThemeData, so both themes are handled centrally.')
    ..writeln('  TextStyle get style =>')
    ..writeln(
      '      Theme.of(this).textTheme.titleMedium ?? const TextStyle();',
    )
    ..writeln();

  kFontWeights.forEach((String name, String weight) {
    sink.writeln(
      '  TextStyle get $name => style.copyWith(fontWeight: $weight);',
    );
  });

  sink
    ..writeln('}')
    ..writeln();
}

/// Layer 2: font size, on TextStyle. ScreenUtil applied HERE and nowhere else.
void _generateFontSizeAtoms(IOSink sink) {
  sink.writeln('extension FontSizeAtoms on TextStyle {');
  for (final int size in kFontSizes) {
    final String value = kUseScreenUtil ? '$size.sp' : '$size.0';
    sink.writeln('  TextStyle get px$size => copyWith(fontSize: $value);');
  }
  sink
    ..writeln('}')
    ..writeln();
}

/// Layer 3: weight + size shortcuts, on BuildContext.
void _generateWeightAndSizeMixes(IOSink sink) {
  sink.writeln('extension WeightAndSizeMixes on BuildContext {');
  for (final int size in kFontSizes) {
    for (final String weight in kFontWeights.keys) {
      sink.writeln('  TextStyle get $weight$size => $weight.px$size;');
    }
  }
  sink
    ..writeln('}')
    ..writeln();
}

/// Layer 4: weight + size + colour, on BuildContext.
///
/// Note these are generated on BuildContext rather than TextStyle, because the
/// colour must be looked up from the theme — a `TextStyle` extension has no
/// context and therefore cannot support dark mode.
void _generateFinalGetters(IOSink sink) {
  for (final String weight in kFontWeights.keys) {
    sink.writeln('extension ${_capitalize(weight)}Atoms on BuildContext {');
    for (final int size in kFontSizes) {
      for (final String color in kColors) {
        sink.writeln(
          '  TextStyle get $weight$size${_capitalize(color)} => '
          '$weight$size.copyWith(color: palette.$color);',
        );
      }
    }
    sink
      ..writeln('}')
      ..writeln();
  }
}

String _capitalize(String s) =>
    s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
