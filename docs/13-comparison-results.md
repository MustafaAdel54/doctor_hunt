# 13 — State Management Comparison Results

This document is intentionally a results template. Measure the three branches only after
all branches implement the same feature set on the same device/emulator and the same
seeded Supabase dataset.

## 1. Environment

- Flutter SDK: fill after bootstrap
- Dart SDK: fill after bootstrap
- Device/emulator: fill
- Build mode: release/profile as specified in `08-state-management-branches.md`
- Seed dataset version: fill

## 2. Results

| Metric | BLoC/Cubit | Riverpod | GetX | Measurement method |
|---|---:|---:|---:|---|
| Release APK size | — | — | — | `flutter build apk --release --analyze-size` |
| Cold start time | — | — | — | `flutter run --profile --trace-startup` |
| Booking-screen rebuild count | — | — | — | DevTools / rebuild instrumentation |
| Presentation LOC | — | — | — | `cloc lib/apps/features/*/presentation` |
| Boilerplate for one new screen | — | — | — | files + lines |
| Test setup per controller | — | — | — | lines of test setup |
| DevTools support (1–5) | — | — | — | documented qualitative score |

## 3. Interpretation Rules

Do not change the shared architecture, Supabase schema, routing, styling, localization,
or widget contracts to improve one branch's score. The comparison must remain apples-to-apples.

## 4. Notes

Record device, Flutter/Dart versions, dataset size, and any measurement caveats next to
final numbers so the comparison is reproducible.
