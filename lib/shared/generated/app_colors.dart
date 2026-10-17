// lib/generated/app_colors.dart
//
// Doctor Hunt — colour system.
// Light palette extracted from the Figma file; dark palette derived from it
// (see docs/11-color-system.md for the derivation rules and contrast audit).
//
// HAND-WRITTEN — the style generator imports this file but does not create it.
// The 19 field names on AppPalette must stay in sync with `kColors` in
// tool/generate_style.dart.

import 'package:flutter/material.dart';

// ===========================================================================
// RAW FIGMA TOKENS
// ---------------------------------------------------------------------------
// Every literal colour from the design, kept verbatim for reference and for
// the handful of one-off cases the semantic palette doesn't cover.
//
// ⚠️ Do NOT use these directly in widgets — go through `context.palette`
// (theme-aware) or the text-style atoms. Direct use breaks dark mode.
// ===========================================================================
abstract final class FigmaRaw {
  // Brand green
  static const Color green500 = Color(0xFF0EBE7F); // core brand
  static const Color green400 = Color(0xFF10C98B); // hover / elevated
  static const Color green900 = Color(0xFF006C49); // deep, borders
  static const Color emerald600 = Color(0xFF059669); // CTA shadow tint

  // Neutrals
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey75 = Color(0xFFFDFDFD);
  static const Color grey100 = Color(0xFFF9F8F8);
  static const Color grey200 = Color(0xFFEDEDED);
  static const Color grey300 = Color(0xFFC4C4C4);
  static const Color grey350 = Color(0xFFCBCBCB);
  static const Color grey500 = Color(0xFF7B8490);
  static const Color slate400 = Color(0xFF94A3B8);
  static const Color slate500 = Color(0xFF64748B);
  static const Color slate600 = Color(0xFF475569);
  static const Color slate800 = Color(0xFF1E293B);
  static const Color slate900 = Color(0xFF0F172A);
  static const Color periwinkle = Color(0xFF677294); // most-used body text
  static const Color indigoGrey = Color(0xFF556386);
  static const Color ink333 = Color(0xFF333333);
  static const Color ink222 = Color(0xFF222222);
  static const Color navy = Color(0xFF17202A);
  static const Color almostBlack = Color(0xFF212121);
  static const Color charcoal = Color(0xFF0C0B0A);
  static const Color black = Color(0xFF000000);
  static const Color greenInk = Color(0xFF161D19);
  static const Color forest = Color(0xFF3C4A41);

  // Surfaces
  static const Color surfaceGreen = Color(0xFFF3FBF4);
  static const Color surfaceGreenSubtle = Color(0xFFF7FAF8);
  static const Color surfaceEmerald = Color(0xFFFAFCFB);
  static const Color surfaceMint = Color(0xFFECFDF5);
  static const Color surfaceBlue = Color(0xFFF5FBFF);
  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color slate200 = Color(0xFFE2E8F0);
  static const Color slate300 = Color(0xFFCBD5E1);
  static const Color sage = Color(0xFFE6ECEA);
  static const Color mintBorder = Color(0xFFD1FAE5);

  // Semantic
  static const Color red = Color(0xFFFA002F);
  static const Color rose = Color(0xFFF43F5E); // kept: Figma's original warning

  // Added beyond Figma (see docs/11-color-system.md §3)
  static const Color amber500 = Color(0xFFF59E0B); // warning / pending
  static const Color amber700 = Color(0xFFB45309); // amber dark enough for text
  static const Color blue600 = Color(0xFF2E6FF2); // real secondary accent
  static const Color blue800 = Color(0xFF1B4DB3);
  static const Color blue50 = Color(0xFFE8F0FE);
}

// ===========================================================================
// SEMANTIC PALETTE
// ---------------------------------------------------------------------------
// The 19 generator colours + surfaces + shadows. This is the only thing
// widgets should ever read, and always via `context.palette`.
// ===========================================================================
@immutable
class AppPalette {
  const AppPalette({
    // --- the 19 the generator produces text-style getters for ---
    required this.primary,
    required this.primaryLight,
    required this.primaryDark,
    required this.secondary,
    required this.secondaryLight,
    required this.secondaryDark,
    required this.textMain,
    required this.textSub,
    required this.textPlaceholder,
    required this.textBorders,
    required this.danger,
    required this.dangerLight,
    required this.success,
    required this.successLight,
    required this.warning,
    required this.warningLight,
    required this.white,
    required this.black,
    required this.boxShadow,
    // --- surfaces (not text colours, so not in the generator list) ---
    required this.scaffold,
    required this.surface,
    required this.surfaceAlt,
    required this.surfaceBrand,
    // --- elevation tints ---
    required this.shadowSoft,
    required this.shadowMedium,
    required this.shadowStrong,
    required this.shadowBrand,
    this.transparent = const Color(0x00000000),
  });

  final Color primary;
  final Color primaryLight;
  final Color primaryDark;
  final Color secondary;
  final Color secondaryLight;
  final Color secondaryDark;
  final Color textMain;
  final Color textSub;
  final Color textPlaceholder;
  final Color textBorders;
  final Color danger;
  final Color dangerLight;
  final Color success;
  final Color successLight;
  final Color warning;
  final Color warningLight;
  final Color white;
  final Color black;
  final Color boxShadow;
  final Color transparent;

  final Color scaffold;
  final Color surface;
  final Color surfaceAlt;
  final Color surfaceBrand;

  final Color shadowSoft;
  final Color shadowMedium;
  final Color shadowStrong;
  final Color shadowBrand;

  /// Readable foreground for text/icons placed ON a filled `warning` chip.
  ///
  /// Amber is a fill colour, not a text colour: #F59E0B on white is only
  /// 2.15:1. Use `warning` for the chip background and this for its label.
  Color get onWarning => textMain;
}

// ---------------------------------------------------------------------------
// LIGHT — straight from Figma
// ---------------------------------------------------------------------------
abstract final class AppColorsLight {
  static const AppPalette palette = AppPalette(
    primary: FigmaRaw.green500, // #0EBE7F
    primaryLight: Color(0xFFE7F9F2), // solid tint of the brand green
    primaryDark: FigmaRaw.green900, // #006C49
    // Figma is monochrome-green, so a real secondary accent was added.
    secondary: FigmaRaw.blue600, // #2E6FF2
    secondaryLight: FigmaRaw.blue50, // #E8F0FE
    secondaryDark: FigmaRaw.blue800, // #1B4DB3
    textMain: FigmaRaw.navy, // #17202A  (16.5:1 on white)
    textSub: FigmaRaw.periwinkle, // #677294  (4.76:1 - AA body)
    textPlaceholder: FigmaRaw.slate400, // #94A3B8
    textBorders: FigmaRaw.grey200, // #EDEDED
    danger: FigmaRaw.red, // #FA002F
    dangerLight: Color(0xFFFFE8EC),
    success: FigmaRaw.green500, // brand green doubles as success
    successLight: FigmaRaw.surfaceMint, // #ECFDF5
    // Amber, not Figma's rose: `warning` marks PENDING bookings, and a red
    // pending badge reads as a failure.
    warning: FigmaRaw.amber500, // #F59E0B
    warningLight: Color(0xFFFEF3C7),
    white: FigmaRaw.white,
    black: FigmaRaw.black,
    boxShadow: Color(0x14000000),
    scaffold: FigmaRaw.white,
    surface: FigmaRaw.white,
    surfaceAlt: FigmaRaw.grey100, // #F9F8F8
    surfaceBrand: FigmaRaw.surfaceGreen, // #F3FBF4
    shadowSoft: Color(0x0F000000),
    shadowMedium: Color(0x14000000),
    shadowStrong: Color(0x40000000),
    shadowBrand: Color(0x33059669),
  );
}

// ===========================================================================
// ThemeExtension — provides the active light palette to widgets.
// ===========================================================================
@immutable
class AppColorsTheme extends ThemeExtension<AppColorsTheme> {
  const AppColorsTheme({required this.palette});

  final AppPalette palette;

  static const AppColorsTheme light = AppColorsTheme(
    palette: AppColorsLight.palette,
  );

  @override
  AppColorsTheme copyWith({AppPalette? palette}) =>
      AppColorsTheme(palette: palette ?? this.palette);

  @override
  AppColorsTheme lerp(ThemeExtension<AppColorsTheme>? other, double t) => this;
}

// ===========================================================================
// Elevation presets — theme-aware versions of the Figma shadow styles.
// Use: `boxShadow: AppShadows.card(context)`
// ===========================================================================
abstract final class AppShadows {
  static List<BoxShadow> card(BuildContext c) {
    final AppPalette p = _p(c);
    return <BoxShadow>[BoxShadow(color: p.shadowMedium, blurRadius: 20)];
  }

  static List<BoxShadow> cardLarge(BuildContext c) => <BoxShadow>[
    BoxShadow(color: _p(c).shadowMedium, blurRadius: 40),
  ];

  static List<BoxShadow> searchBar(BuildContext c) => <BoxShadow>[
    BoxShadow(color: _p(c).shadowSoft, blurRadius: 40),
  ];

  static List<BoxShadow> navBar(BuildContext c) => <BoxShadow>[
    BoxShadow(
      color: _p(c).shadowSoft,
      blurRadius: 20,
      offset: const Offset(0, -1),
    ),
  ];

  static List<BoxShadow> elevated(BuildContext c) => <BoxShadow>[
    BoxShadow(
      color: _p(c).shadowStrong,
      blurRadius: 50,
      spreadRadius: -12,
      offset: const Offset(0, 25),
    ),
  ];

  static List<BoxShadow> ctaButton(BuildContext c) {
    final AppPalette p = _p(c);
    return <BoxShadow>[
      BoxShadow(
        color: p.shadowBrand,
        blurRadius: 6,
        spreadRadius: -4,
        offset: const Offset(0, 4),
      ),
      BoxShadow(
        color: p.shadowBrand,
        blurRadius: 15,
        spreadRadius: -3,
        offset: const Offset(0, 10),
      ),
    ];
  }

  static AppPalette _p(BuildContext c) =>
      Theme.of(c).extension<AppColorsTheme>()?.palette ??
      AppColorsLight.palette;
}
