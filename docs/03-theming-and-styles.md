# 03 — Theming, Colors, Text Styles & Responsiveness

> ✅ **FINAL**, based on the product owner's `generate_style.dart`.
> This document records the generator fixes and the final style-system contract. Read §4
> before running it.

---

## 1. The Atomic Style System

The generator produces **composable extensions on `BuildContext` and `TextStyle`**.
Instead of a named-style catalogue (`AppTextStyles.h1`), you describe the style at the
call site by chaining atoms:

```dart
Text(t.auth.login, style: context.bold20Primary)
Text(t.doctors.about, style: context.regular14TextSub)
Text(price,          style: context.semiBold16Success)
```

### The four atom layers

| Layer | Extension on | Produces | Example |
|---|---|---|---|
| 0. Palette | `BuildContext` | active `AppPalette` | `context.palette.primary` |
| 1. Weight | `BuildContext` | base style + weight | `context.bold` |
| 2. Size | `TextStyle` | `.px16` | `context.bold.px16` |
| 3. Mixes | `BuildContext` | weight+size | `context.bold16` |
| 4. Final | `BuildContext` | weight+size+**theme-aware colour** | `context.bold16Primary` |

> Colour is **not** an extension on `TextStyle`. A `TextStyle` has no `BuildContext`
> and therefore cannot know which theme is active — that is exactly why dark mode
> required moving colour resolution onto `BuildContext`. See `10 §Fix #11`.

**Combinatorics:** 5 weights × 15 sizes × 19 colours = **1,425 generated getters**,
plus 75 weight+size mixes, plus 19 colour atoms, plus 15 size atoms.

### Why this is a good system
- **Zero hardcoding by construction.** You physically cannot write `fontSize: 16` —
  there's no API for it. This satisfies the project's hard rule better than a
  named-style class ever could.
- **Discoverable.** Type `context.bold` and autocomplete shows every valid combination.
- **Consistent.** Only the 15 approved sizes and 19 approved colours exist.

### The trade-off (be aware)
- 1,425 getters is a large generated file (~2,500 lines). Dart tree-shakes unused
  getters in release builds, so **runtime cost is zero**, but IDE autocomplete gets
  noisy and analysis is slightly slower.
- Semantic intent is lost: `context.bold20TextMain` doesn't say "page title". Mitigate
  by keeping screen-level widgets small and self-documenting.

**Verdict: keep it.** It fits the no-hardcoding requirement perfectly.

---

## 2. `app_colors.dart` — 19 Colours

The generator reads this list and assumes `AppColors.<name>` exists for each:

```
primary, primaryLight, primaryDark,
secondary, secondaryLight, secondaryDark,
textMain, textSub, textPlaceholder, textBorders,
danger, dangerLight,
success, successLight,
warning, warningLight,
white, black, boxShadow
```

> ✅ **DONE.** The real file is at `tools/app_colors.dart` — copy it to
> `lib/generated/app_colors.dart`. It is built from the Figma extraction.
> **Full rationale, the 60→19 reduction, and the contrast audit are in
> `11-color-system.md`.**

Because dark mode is in scope, the file defines **two palettes**, not one set of
constants:

```dart
@immutable
class AppPalette {           // 19 generator colours + 3 surfaces
  final Color primary, primaryLight, primaryDark, ...;
  final Color scaffold, surface, surfaceAlt;   // not text colours

  // Derived semantic foreground for the warning fill; not a generator token.
  Color get onWarning => textMain;
}

abstract final class AppColorsLight { static const AppPalette palette = ...; }
abstract final class AppColorsDark  { static const AppPalette palette = ...; }

class AppColorsTheme extends ThemeExtension<AppColorsTheme> {
  final AppPalette palette;
  static const light = AppColorsTheme(palette: AppColorsLight.palette);
  static const dark  = AppColorsTheme(palette: AppColorsDark.palette);
}
```

**Three surface colours were added** (`scaffold`, `surface`, `surfaceAlt`). The
original 19 are all text/brand colours with no background tokens, which isn't enough
to build screens in two themes. They're outside the generator's list because they're
never text colours.

**Appointment status colours** reuse existing tokens: `warning`=pending,
`success`=confirmed, `danger`=cancelled, `textSub`=completed.

**Brand:** Doctor Hunt green `#0EBE7F`. Dark palette derived and contrast-audited —
every functional colour passes WCAG AA. See `11 §4`.

---

## 3. Approved Sizes & Weights

```
Sizes   : 8, 11, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 36, 40
Weights : light(300), regular(400), medium(500), semiBold(600), bold(700)
Family  : Cairo     ← ships 200-900, covers Latin + Arabic
```

---

## 4. 🔴 Required Fixes to `generate_style.dart`

The script works, but has **8 issues** that will bite us. Fix all of them before first run.

### Fix #1 — Import path doesn't match the folder structure
```dart
// current
const String importColorsClass = "import '../app/core/themes/app_colors.dart';";
```
The screenshot shows `lib/apps/` (plural) and `app_colors.dart` in `lib/generated/`.
Since output and colours are both in `lib/generated/`, the import should simply be:
```dart
const String importColorsClass = "import 'app_colors.dart';";
```

### Fix #2 — Filename mismatch: `style_atoms.dart` vs `style_atoms.dart`
The generator writes `${outputPath}style_atoms.dart` (plural), while the original
screenshot showed `style_atoms.dart` (singular). **Final decision: plural** —
`lib/generated/style_atoms.dart`. The generator, docs, imports, and generated output must
all use this exact name.

### Fix #3 — 🔴 ScreenUtil is completely missing
This is the big one. The project requires `flutter_screenutil`, but the generator emits:
```dart
TextStyle get px16 => copyWith(fontSize: 16.0);   // ❌ fixed pixels
```
Font sizes will **not** scale between a small phone and a tablet. Fix:
```dart
void generateFontSizes(IOSink sink, List<int> fontSizes) {
  sink.writeln('extension FontSizeAtoms on TextStyle {');
  for (final int size in fontSizes) {
    sink.writeln('  TextStyle get px$size => copyWith(fontSize: $size.sp);');
  }
  sink.writeln('}\n\n');
}
```
and add `import 'package:flutter_screenutil/flutter_screenutil.dart';` to the emitted
header. **This resolves the open question from the previous draft: `.sp` is applied
inside the generator, so call sites never touch it.**

### Fix #4 — Hardcoded colour/font inside the generator
The base style must contain **neither a hardcoded colour nor a hardcoded font family**.
Use the active `ThemeData.textTheme.titleMedium` as the base style and let `AppTheme`
provide the Cairo font family and default text colour. The generated colour getters
apply the active palette only when a specific semantic colour is requested. This keeps
dark mode and typography centralized in `ThemeData`.

### Fix #5 — ✅ Dark mode implemented (generator restructured)
Colour atoms moved off `TextStyle` and onto `BuildContext`, resolving through a
`ThemeExtension`. Call-site syntax is unchanged. Full details in `10 §Fix #11`.

### Fix #6 — `generateWeightAtoms` is `async` but never awaited
```dart
Future<void> generateWeightAtoms(IOSink sink) async => sink.writeln(...);
```
It's called without `await`, so the weight extension can be written **after** later
sections, producing a scrambled file. Make it `void`:
```dart
void generateWeightAtoms(IOSink sink) => sink.writeln('''...''');
```

### Fix #7 — `sink.close()` not awaited
`main()` may exit before the buffer flushes, truncating the file. Fix:
```dart
void main() async {
  ...
  await sink.close();
}
```

### Fix #8 — Timestamp in the header churns git diffs
```dart
sink.writeln('// Last updated: ${DateTime.now()}');
```
Every regeneration produces a diff even when nothing changed. Remove it, or replace
with a static version string. (Same reasoning as `timestamp: false` for slang.)

### Minor
- Typos: `generateFinalGeters` → `generateFinalGetters`, `wieght` → `weight`.
- Header says `dart run generate_styles.dart`; actual path is `tool/generate_style.dart`.
- Add `sink.writeln("// ignore_for_file: unused_element")` — not strictly needed, but
  a 2,500-line file may trip analyzer warnings.
- Consider emitting `// coverage:ignore-file` so generated code doesn't skew coverage.

---

## 5. Usage Rules

```dart
// ✅ correct
Text(t.auth.login,   style: context.bold20TextMain)
Text(t.common.cancel, style: context.medium14TextSub)

// ✅ ad-hoc composition when no final getter fits
Text(x, style: context.semiBold16.copyWith(decoration: TextDecoration.underline))
Text(x, style: context.bold16.copyWith(color: context.palette.primary))

// ❌ removed in the dark-mode rewrite — TextStyle has no context
Text(x, style: context.bold.px16.primary)

// ❌ never
Text(x, style: TextStyle(fontSize: 16, color: Colors.black))
Text(x, style: context.bold16.copyWith(fontSize: 17))   // 17 is not an approved size
Text(x, style: context.bold16.copyWith(color: Color(0xFF...)))
```

**Colour for non-text widgets** (containers, icons, borders) comes from
`context.palette.x` — **not** from a static constant, or dark mode breaks:

```dart
// ✅
Container(color: context.palette.surface)
Icon(Icons.star, color: context.palette.warning)

// ❌ static — always light-mode colour
Container(color: AppColorsLight.palette.surface)
```

---

## 6. ThemeData

`app_theme.dart` in `core/themes/` consumes the same `AppColors`:

Both themes are built from the same function so they can never drift apart:

```dart
abstract final class AppTheme {
  static ThemeData get light => _build(AppColorsTheme.light, Brightness.light);
  static ThemeData get dark  => _build(AppColorsTheme.dark,  Brightness.dark);

  static ThemeData _build(AppColorsTheme ext, Brightness brightness) {
    final AppPalette p = ext.palette;
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: FontFamily.cairo,

      // 🔴 REQUIRED: without this the generated getters silently fall back
      // to the light palette.
      extensions: <ThemeExtension<dynamic>>[ext],

      scaffoldBackgroundColor: p.scaffold,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: p.primary,
        onPrimary: p.white,
        secondary: p.secondary,
        onSecondary: p.white,
        error: p.danger,
        onError: p.white,
        surface: p.surface,
        onSurface: p.textMain,
      ),
      // titleMedium MUST exist — WeightAtoms.style reads it.
      textTheme: TextTheme(
        titleMedium: TextStyle(color: p.textMain, fontFamily: FontFamily.cairo),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: p.surface,
        foregroundColor: p.textMain,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.surface,
        hintStyle: TextStyle(color: p.textPlaceholder),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: p.textBorders),
        ),
      ),
    );
  }
}
```

**Theme mode** is persisted in `SharedPreferences` and exposed per branch
(`ThemeCubit` / `themeProvider` / `ThemeController`), defaulting to
`ThemeMode.system`.

> ⚠️ `WeightAtoms.style` reads `Theme.of(this).textTheme.titleMedium`. If `titleMedium`
> is ever null the generator's `!` throws. Material 3 always provides it, but if you
> override `textTheme` in `AppTheme`, **make sure `titleMedium` is defined.**

---

## 7. Responsiveness — `flutter_screenutil`

```dart
ScreenUtilInit(
  designSize: const Size(375, 812),
  minTextAdapt: true,
  splitScreenMode: true,
  builder: (context, child) => MaterialApp.router(...),
);
```

| Suffix | Use for | Who applies it |
|---|---|---|
| `.sp` | font sizes | **the generator** — never at call sites |
| `.w` | widths, horizontal padding | you |
| `.h` | heights, vertical padding | you |
| `.r` | radii, square icons | you |

```dart
// core/constants/app_constants.dart
abstract final class Gaps {
  static Widget get h8  => SizedBox(height: 8.h);
  static Widget get h16 => SizedBox(height: 16.h);
  static Widget get h24 => SizedBox(height: 24.h);
  static Widget get w8  => SizedBox(width: 8.w);
  static Widget get w16 => SizedBox(width: 16.w);
}

abstract final class AppRadius {
  static double get sm   => 8.r;
  static double get md   => 12.r;
  static double get lg   => 16.r;
  static double get pill => 100.r;
}
```

> `FontFamily` lives only in `core/themes/font_family.dart`; do not redeclare it in
> `app_constants.dart`.

---

## 8. Font: Cairo

✅ **Decided: Cairo.** It ships weights 200–900, so all five generator weights
(`light`/`regular`/`medium`/`semiBold`/`bold`) map to real font files with no
synthesis. It also covers Latin + Arabic in one family — no font swap needed for
EN↔AR.

See `09-conventions-and-setup.md §1` for the `pubspec.yaml` font entries with all
five weights registered.

> **Why not Almarai?** Almarai only ships 300/400/700/800, which would have
> forced dropping `medium` (500) and `semiBold` (600) from the generator.
