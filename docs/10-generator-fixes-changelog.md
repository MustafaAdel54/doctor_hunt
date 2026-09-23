# 10 — `generate_style.dart`: What Exactly Was Changed

Original file: as supplied by the product owner.
Fixed file: `tool/generate_style.dart` (in this workspace at `tools/generate_style.dart`).

Verified output: **1,425 final getters, 75 weight+size mixes, 19 colour atoms,
15 size atoms — zero duplicate getter names, ~1,563 lines.**

---

## Fix #1 — Import path corrected

```diff
- const String importColorsClass = "import '../app/core/themes/app_colors.dart';";
+ const String kColorsImport = "import 'app_colors.dart';";
```
**Why:** the screenshot shows `lib/apps/` (plural) and `app_colors.dart` living in
`lib/generated/` — the same folder as the output file. A bare relative import is
correct and survives any rename of folders above `generated/`.

---

## Fix #2 — Output filename settled

```diff
- final File file = File('${outputPath}style_atoms.dart');
+ const String kOutputFile = 'style_atoms.dart';
```
**Why:** the original screenshot showed `style_atom.dart` (singular), but the generator
uses plural and the final project convention is **`style_atoms.dart`** everywhere.

---

## Fix #3 — 🔴 ScreenUtil added (the important one)

```diff
- sink.writeln('  TextStyle get px$size => copyWith(fontSize: $size.0);');
+ final String value = kUseScreenUtil ? '$size.sp' : '$size.0';
+ sink.writeln('  TextStyle get px$size => copyWith(fontSize: $value);');
```
plus the emitted header now contains:
```dart
import 'package:flutter_screenutil/flutter_screenutil.dart';
```

**Why:** the original emitted fixed pixels, so font sizes would not scale between a
small phone and a tablet — defeating the whole point of adding `flutter_screenutil`.

**Consequence (important):** `.sp` is applied **inside the generator**. Call sites must
**never** write `.sp`. `context.bold16Primary` is already responsive.

A `kUseScreenUtil` flag was added so this can be switched off in one place.

---

## Fix #4 — Hardcoded colour + font removed from the base style

```diff
  TextStyle get style => Theme.of(this).textTheme.titleMedium!.copyWith(
-       color: Color(0xFF1A1A1A),
-       fontFamily: 'Almarai',
-     );
+ TextStyle get style =>
+     Theme.of(this).textTheme.titleMedium ?? const TextStyle();
```
**Why, three separate reasons:**
1. `Color(0xFF1A1A1A)` is exactly the hardcoding the project bans — and it was inside
   the tool meant to prevent it.
2. Baking a colour in breaks dark mode permanently.
3. `fontFamily` belongs in `ThemeData` once, not repeated in every style.

Font family now comes from `AppTheme.fontFamily`. Colour comes from the active theme,
and the colour atoms override it explicitly when a specific colour is wanted.

---

## Fix #5 — `!` null-assertion replaced

```diff
- Theme.of(this).textTheme.titleMedium!
+ Theme.of(this).textTheme.titleMedium ?? const TextStyle()
```
**Why:** if anyone overrides `textTheme` in `AppTheme` without defining `titleMedium`,
the original crashes at runtime in every single `Text` widget. The fallback degrades
gracefully instead.

---

## Fix #6 — 🔴 `async` race condition removed

```diff
- Future<void> generateWeightAtoms(IOSink sink) async => sink.writeln('''...''');
+ void _generateWeightAtoms(IOSink sink) { ... }
```
**Why:** it was declared `Future<void> ... async` but called **without `await`**. The
weight extension could be written to the sink *after* later sections, producing a
scrambled, non-compiling file. Intermittent and very annoying to debug.

---

## Fix #7 — `sink.close()` now awaited

```diff
- sink.close();
+ await sink.flush();
+ await sink.close();
  // and main() is now `Future<void> main() async`
```
**Why:** without awaiting, `main()` can exit before the buffer flushes and the file
gets silently truncated — worse on large output, and this output is 1,563 lines.

---

## Fix #8 — Timestamp removed from the header

```diff
- sink.writeln('// Last updated: ${DateTime.now()}');
```
**Why:** every regeneration produced a git diff even when nothing changed. Same
reasoning as `timestamp: false` in the slang config. Replaced with a stable header.

---

## Fix #9 — Output directory auto-created

```dart
final Directory dir = Directory(kOutputPath);
if (!dir.existsSync()) dir.createSync(recursive: true);
```
**Why:** the original threw on a fresh clone where `lib/generated/` didn't exist yet.

---

## Fix #10 — Font weights moved to a typed map

```diff
- final List<String> fontWeights = ['light','regular','medium','semiBold','bold'];
+ const Map<String, String> kFontWeights = {
+   'light': 'FontWeight.w300', 'regular': 'FontWeight.w400',
+   'medium': 'FontWeight.w500', 'semiBold': 'FontWeight.w600',
+   'bold': 'FontWeight.w700',
+ };
```
**Why:** the original hardcoded the weight→`FontWeight` mapping inside a raw string
literal, so adding or removing a weight meant editing two places that could silently
disagree. Now it's one source of truth, and dropping `medium`/`semiBold` for a
4-weight font is a one-line change.

---

## Minor cleanups

| Change | Reason |
|---|---|
| `generateFinalGeters` → `_generateFinalGetters` | typo |
| `wieght` → `weight` | typo |
| All helpers now `_private` | they're internal to the script |
| Config hoisted to top-level `k`-prefixed consts | one place to edit |
| Emits `// coverage:ignore-file` | 1,563 generated lines shouldn't skew coverage |
| Emits `// ignore_for_file: unused_element, lines_longer_than_80_chars` | keeps `flutter analyze` clean |
| Prints a summary on completion | confirms the run did what you expected |
| Header says `dart run tool/generate_style.dart` | matches the real path |

---

## Fix #11 — ✅ DONE: dark mode support (generator rewritten)

**Decision: light + dark mode.** This required restructuring the generator, because the
original design made dark mode impossible.

### The problem
Colour atoms were an `extension on TextStyle`:
```dart
extension ColorAtoms on TextStyle {
  TextStyle get textMain => copyWith(color: AppColors.textMain);  // static const
}
```
A `TextStyle` has **no `BuildContext`**, so it can never know which theme is active.
`context.bold16TextMain` was permanently `#1A1A1A`.

### The fix — three structural changes

**1. `AppColors` became two palettes + a `ThemeExtension`.**
`AppPalette` is a class with 22 `Color` fields (19 from the generator list + 3
surface colours). Two instances: `AppColorsLight.palette`, `AppColorsDark.palette`.
`AppColorsTheme extends ThemeExtension<AppColorsTheme>` carries the active one.
Template provided at `tools/app_colors_template.dart` → copy to
`lib/generated/app_colors.dart`.

**2. New generated accessor — the bridge to the widget tree:**
```dart
extension PaletteAccess on BuildContext {
  AppPalette get palette =>
      Theme.of(this).extension<AppColorsTheme>()?.palette ??
      AppColorsLight.palette;      // graceful fallback, never throws
}
```

**3. `ColorAtoms on TextStyle` was deleted entirely.** Final getters moved to
`BuildContext` and now resolve the colour at call time:
```diff
- TextStyle get bold16Primary => bold16.primary;                       // static
+ TextStyle get bold16Primary => bold16.copyWith(color: palette.primary); // theme-aware
```

### What this changes for you

| | Before | After |
|---|---|---|
| Call site | `context.bold16Primary` | `context.bold16Primary` — **unchanged** |
| Dark mode | impossible | automatic |
| Getter count | 1,425 | 1,425 (verified, zero collisions) |
| ~~`someTextStyle.primary`~~ | worked | **removed** — no longer possible |

**The only breaking change:** you can no longer chain a colour onto a bare
`TextStyle`. Instead of `context.bold.px16.primary`, use `context.bold16Primary`, or
`context.bold16.copyWith(color: context.palette.primary)` for ad-hoc cases.

### Registering it
```dart
ThemeData(
  extensions: const [AppColorsTheme.light],   // and .dark in the dark theme
  ...
)
```
⚠️ **Forget this and every colour silently falls back to the light palette.** The
fallback is deliberate — a missing registration degrades instead of crashing in every
`Text` widget — but it makes the mistake quiet. Add a `debugAssert` in `AppTheme` if
this bites.

---

## Fix #12 — ✅ DONE: font switched to Cairo

**Decision: Cairo.** It ships weights 200–900, so all five generator weights
(`light/regular/medium/semiBold/bold`) map to real font files with no synthesis.
Almarai would have forced dropping `medium` and `semiBold`.

Cairo also covers Latin and Arabic in one family, which keeps EN/AR visually
consistent. `09-conventions-and-setup.md` already lists it in `pubspec.yaml` with all
five weights.


## Supabase v1 scope revision

- Supabase Storage and Edge Functions were removed from the v1 baseline because the
  project is constrained to the free tier v1 scope.
- Profile-photo uploads are deferred; `photoUrl` is optional and may reference a
  pre-existing remote image.
- Settings uses account deactivation in v1; full server-side account purge is deferred
  to a future implementation utilizing Edge Functions.
- All three state-management branches use the same Supabase v1 baseline.
