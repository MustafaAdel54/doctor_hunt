# 09 — Conventions, Tooling & Setup

## 1. `pubspec.yaml` (shared base — `main` branch)

```yaml
name: doctor_hunt
description: Doctor appointment booking app
publish_to: 'none'
version: 1.0.0+1

environment:
  # Dart 3.12.2 is the intentional minimum Dart SDK baseline for v1.
  sdk: ^3.12.2

dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter

  # Supabase & Auth
  supabase_flutter: ^2.4.1
  google_sign_in: ^6.2.1
  firebase_core: ^3.6.0        # TEMPORARY: retained during transition; removed with google-services.json in the de-Firebase phase

  # Routing
  go_router: ^14.2.7

  # Localization
  slang: ^4.19.1
  slang_flutter: ^4.19.0
  intl: ^0.19.0                # DateFormat / NumberFormat only

  # Responsive
  flutter_screenutil: ^5.9.3

  # DI
  get_it: ^7.7.0

  # Models / functional
  freezed_annotation: ^2.4.4
  json_annotation: ^4.9.0
  dartz: ^0.10.1               # Either<Failure, T> — chosen over fpdart
  equatable: ^2.0.5

  # Launchers (v1 — no API key needed)
  url_launcher: ^6.3.0            # tel: , whatsapp, open-in-maps

  # Maps & location — DEFERRED to v1.1 (needs Maps API key + billing)
  # google_maps_flutter: ^2.9.0
  # geolocator: ^13.0.1
  # geocoding: ^3.0.0
  # permission_handler: ^11.3.1

  # UI helpers
  cached_network_image: ^3.4.1
  flutter_rating_bar: ^4.0.1      # ratings UI
  shimmer: ^3.0.0
  flutter_svg: ^2.0.10+1
  shared_preferences: ^2.3.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
  build_runner: ^2.4.13
  freezed: ^2.5.7
  json_serializable: ^6.8.0
  slang_build_runner: ^4.19.0
  mocktail: ^1.0.4
  mocktail: ^1.0.4

flutter:
  uses-material-design: true
  assets:
    - assets/images/
    - assets/icons/
  fonts:
    # Almarai only ships 300/400/700/800 - see docs/03 §8.
    # Cairo ships 200-900 and covers all five generator weights.
    - family: Cairo
      fonts:
        - asset: assets/fonts/Cairo-Light.ttf
          weight: 300
        - asset: assets/fonts/Cairo-Regular.ttf
          weight: 400
        - asset: assets/fonts/Cairo-Medium.ttf
          weight: 500
        - asset: assets/fonts/Cairo-SemiBold.ttf
          weight: 600
        - asset: assets/fonts/Cairo-Bold.ttf
          weight: 700
```

Per-branch additions: `flutter_bloc`+`bloc_test` / `flutter_riverpod`+`riverpod_generator` /
`get`. Nothing else differs.

> **Version note:** pin ranges, then run `flutter pub outdated` before starting.
> Packages move fast — verify these resolve together before writing code.

---

## 2. `analysis_options.yaml`

```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
    - "lib/i18n/strings.g.dart"
  errors:
    invalid_annotation_target: ignore
  language:
    strict-casts: true
    strict-raw-types: true

linter:
  rules:
    always_declare_return_types: true
    avoid_print: true
    prefer_const_constructors: true
    prefer_const_declarations: true
    prefer_final_locals: true
    require_trailing_commas: true
    use_super_parameters: true
    sort_child_properties_last: true
    avoid_unnecessary_containers: true
    unnecessary_await_in_return: true
    directives_ordering: true
```

For the "no hardcoding" rules that stock lints can't express, add `custom_lint` +
a tiny local lint package, or at minimum a CI grep:

```bash
# scripts/check_hardcoded.sh
! grep -rnE "Color\(0x|Colors\.[a-z]|TextStyle\(" lib/features --include="*.dart" \
  && echo "✅ no hardcoded colors/styles" || (echo "❌ hardcoded style found" && exit 1)
```

---

## 3. Git Conventions

**Branches:** `main`, `feature/bloc`, `feature/riverpod`, `feature/getx`.
Work branches: `feat/<scope>-<desc>`, `fix/<scope>-<desc>`.

**Conventional Commits:**
```
feat(auth): add google sign-in
fix(booking): prevent double booking on same slot
refactor(core): extract StateHandler widget
docs(readme): add branch comparison table
chore(deps): bump firebase_auth to 5.3.1
```

**`.gitignore` additions:**
```
# Google Sign-in config (if repo is public)
android/app/google-services.json
ios/Runner/GoogleService-Info.plist

# keep these generated files IN git:
# !lib/i18n/strings.g.dart
```

---

## 4. Codegen Commands

```bash
dart run tool/generate_style.dart               # style atoms  (run after editing colours/sizes)
dart run slang                                  # translations
dart run build_runner build -d                  # freezed + json + riverpod + slang
dart run build_runner watch -d                  # during development
dart run slang analyze                          # missing/unused keys
```

Add to `Makefile`:
```makefile
gen:      ; dart run tool/generate_style.dart && dart run build_runner build -d
styles:   ; dart run tool/generate_style.dart
watch:    ; dart run build_runner watch -d
i18n:     ; dart run slang && dart run slang analyze
lint:     ; flutter analyze && dart format --set-exit-if-changed lib test
test:     ; flutter test --coverage
clean:    ; flutter clean && flutter pub get && $(MAKE) gen
```

---

## 5. Testing Strategy

| Layer | Tool | Target coverage |
|---|---|---|
| `calculateAvailableSlots()` (pure fn) | `flutter_test` | 90%+ |
| Repositories | `mocktail` | 80% |
| Controllers | `bloc_test` / `ProviderContainer` / `Get.put` in test | 70% |
| Shared widgets | widget tests, both EN and AR directionality | key widgets |
| Booking flow | integration test | 1 happy + 1 slot-conflict path |

`calculateAvailableSlots()` must be a **pure function** with no Database/Supabase dependency —
it's the highest-value test in the codebase and the same tests must pass on all three
branches unchanged.

---

## 6. CI (`.github/workflows/ci.yaml`)

```yaml
name: CI
on:
  push:    { branches: [main, 'feature/**'] }
  pull_request:

jobs:
  analyze-and-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with: { channel: stable, cache: true }
      - run: flutter pub get
      - run: dart run build_runner build -d
      - run: dart run slang analyze          # fails on missing AR keys
      - run: dart format --set-exit-if-changed lib test
      - run: flutter analyze
      - run: bash scripts/check_hardcoded.sh
      - run: flutter test --coverage
```

---

## 6A. Supabase v1 scope notes

The project is running on the **Supabase free tier**. Therefore:

- Do not attempt to use Edge Functions for server-side logic in v1.
- Do not add `supabase_storage` (profile-photo uploads are excluded from v1).
- `image_picker` is not a v1 dependency.
- Doctor `photoUrl` is optional and may point to a pre-existing remote image; otherwise use
  the shared placeholder/avatar widget.
- Account lifecycle is governed by the canonical contract in `12-supabase-plan.md §3`;
  the UI action is **Deactivate account** in v1.

## 7. Bootstrap Order (do it in this sequence)

1. `flutter create` + set package name, min SDK 21 (Android) / iOS 13.
2. `flutterfire configure` → `firebase_options.dart` (Keep during the transition, not permanently).
3. Add **the product owner's `app_colors.dart` and `generate_style.dart`** (received),
   then build `app_theme.dart` on top of them.
4. Mirror **the product owner's folder structure screenshot** exactly (received).
5. `core/constants`, `core/extensions`, `core/error`, `core/utils`.
6. slang setup + `en`/`ar` JSON with the full key tree from `05`.
7. `core/widgets/` — the whole inventory in `07 §E`, built against a widgetbook/gallery page.
8. Data layer: models, repository abstractions/impls, and Supabase-facing services.
9. `SessionService` + `app_router.dart`.
10. Apply `supabase/schema.sql` to your Supabase project.
11. Verify the Supabase project remains on the free tier; do **not** add Edge Functions or Supabase Storage to the v1 baseline.
12. Commit, tag `core-v1`, **then** fork the three branches.
13. Implement auth → patient flow → doctor flow, one branch at a time.

---

## 8. Open Questions To Resolve Before Step 1

1. **App name / package id?** (`com.<company>.medibook`)

2. **Arabic-Indic or Western numerals for times/dates?** Recommend Western
   (`3:30`, not `٣:٣٠`) — far more readable for Egyptian users in a medical context.
   This is the only genuinely open question left, and it's a one-line change.

> **Migration Note (google-services.json):** For v1, we KEEP `google-services.json` and the current Android setup as-is. Although we now pass the Google ID token to Supabase (instead of Firebase), `firebase_core` remains temporarily during the transition. The file, Gradle plugin, and `firebase_core` will be removed together in a later phase. Google Cloud Console config (Web client ID, Android SHA-1) remains unchanged.

**Resolved in this revision:**
- ✅ `warning` → amber `#F59E0B` (pending no longer looks like an error).
- ✅ `secondary` → blue `#2E6FF2` (real accent added; design was monochrome).
- ✅ `dartz` chosen for `Either<Failure, T>`.

- ✅ Figma palette extracted, reduced 60 → 19 semantic tokens, dark palette derived
  and contrast-audited (`11-color-system.md`).

- ✅ Dark mode IN → generator rewritten as theme-aware (`10 §Fix #11`).
- ✅ Font: **Cairo** (200-900, no synthesised weights).
- ✅ `completed` is set by the **doctor only** → dashboard nudges required (`07 §C2`).
- ✅ Maps **deferred to v1.1**; `url_launcher` covers call + open-in-maps in v1.
- ✅ Supabase free tier is the baseline for v1; Edge Functions and Storage are explicitly excluded.
- ✅ Account lifecycle is canonicalized in `12-supabase-plan.md §3`; v1 action is **Deactivate account**.

- ✅ v1 feature list confirmed (see `07 §0`).
- ✅ Both roles self-register via a role-selection screen → security rules updated.
- ✅ Search and ratings are in v1.
- ✅ Interactive maps and geolocation are deferred to v1.1; v1 keeps address data and an "Open in Maps" action only.
- ✅ Generator fixes applied (see `10`).

**Resolved earlier:**
- ✅ `.sp` is applied inside the generator; call sites never write it.
- ✅ No `domain/` layer — two-layer data/presentation.
- ✅ Multi-doctor platform.
- ✅ Docs stay in English.
