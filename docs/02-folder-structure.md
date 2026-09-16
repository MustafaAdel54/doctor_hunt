# 02 — Folder Structure

> ✅ **FINAL.** Based on the product owner's screenshot. The layout below preserves it
> exactly and only *adds* folders that are required by decisions already made
> (i18n, DI, theming, error handling). Additions are marked `← ADDED`.

---

## 1. The Screenshot, Transcribed

```
assets/
lib/
├── apps/
│   ├── core/
│   │   ├── extensions/
│   │   ├── network/
│   │   ├── router/
│   │   ├── utils/
│   │   └── widgets/
│   ├── features/
│   │   └── auth/
│   │       ├── data/
│   │       │   ├── models/
│   │       │   ├── repo/
│   │       │   └── service/
│   │       └── presentation/
│   │           ├── controller/
│   │           ├── screens/
│   │           └── widgets/
│   └── main/
├── generated/
│   ├── app_colors.dart
│   ├── image_assets.dart
│   └── style_atoms.dart
└── main.dart
```

**Key observations that override my earlier draft:**
1. Root package folder is `apps/` (plural), not `app/`.
2. There is **no `domain/` layer.** The structure is `data` (models / repo / service)
   + `presentation` (controller / screens / widgets). This is a **two-layer** design,
   not Clean Architecture. `01-architecture.md` has been updated to match.
3. `service/` is the Firebase-facing layer (what I called `datasources`).
4. `repo/` maps service output to models and handles errors.
5. Screens folder is `screens/`, not `pages/`. Controllers folder is `controller/`
   (singular) — works for all three branches: cubits, notifiers, and GetX controllers
   all live there.
6. `generated/` sits at `lib/` root, **outside** `apps/`, and holds three generated
   files: colors, image assets, text styles.
7. There is an `apps/main/` folder — the app-level bootstrap (MaterialApp, ScreenUtil,
   providers) as distinct from `lib/main.dart` which is just the entrypoint.

---

## 2. Final Structure (screenshot + required additions)

```
assets/
├── images/
├── icons/
└── fonts/

lib/
├── main.dart                                  # entrypoint only: ensureInitialized, Firebase, DI, runApp
│
├── apps/
│   ├── main/
│   │   ├── app.dart                           # MaterialApp.router + ScreenUtilInit + TranslationProvider
│   │   └── app_bootstrap.dart                 # branch-specific provider wrapper (ProviderScope / MultiBlocProvider / Bindings)
│   │
│   ├── core/
│   │   ├── extensions/
│   │   │   ├── context_ext.dart               # context.isRtl, context.theme, context.locale
│   │   │   ├── string_ext.dart
│   │   │   ├── datetime_ext.dart
│   │   │   └── num_ext.dart
│   │   ├── network/
│   │   │   ├── network_info.dart
│   │   │   └── firebase_error_mapper.dart
│   │   ├── router/
│   │   │   ├── app_router.dart
│   │   │   ├── routes.dart
│   │   │   └── router_refresh_stream.dart
│   │   ├── utils/
│   │   │   ├── validators.dart
│   │   │   ├── date_utils.dart
│   │   │   └── logger.dart
│   │   ├── widgets/
│   │   │   ├── app_button.dart
│   │   │   ├── app_text_field.dart
│   │   │   ├── app_scaffold.dart
│   │   │   ├── app_loader.dart
│   │   │   ├── app_error_view.dart
│   │   │   ├── app_empty_view.dart
│   │   │   ├── state_handler.dart
│   │   │   ├── app_avatar.dart
│   │   │   ├── status_badge.dart
│   │   │   ├── shimmer_box.dart
│   │   │   └── app_dialogs.dart
│   │   │
│   │   ├── themes/                            # ← ADDED (the generator imports from here)
│   │   │   ├── app_theme.dart                 # light + dark ThemeData
│   │   │   └── font_family.dart               # 'Cairo' constant — see 03 §7
│   │   ├── constants/                         # ← ADDED
│   │   │   ├── app_constants.dart             # designSize, durations, gaps, radii
│   │   │   └── firebase_constants.dart        # collection & field names
│   │   ├── error/                             # ← ADDED
│   │   │   ├── failures.dart
│   │   │   └── exceptions.dart
│   │   ├── di/                                # ← ADDED
│   │   │   ├── injector.dart                  # SHARED across branches
│   │   │   └── state_injector.dart            # PER-BRANCH
│   │   └── session/                           # ← ADDED (router needs role synchronously)
│   │       ├── session_service.dart
│   │       └── session_state.dart
│   │
│   └── features/
│       ├── auth/
│       │   ├── data/
│       │   │   ├── models/
│       │   │   │   └── user_model.dart
│       │   │   ├── repo/
│       │   │   │   ├── auth_repo.dart          # abstract
│       │   │   │   └── auth_repo_impl.dart
│       │   │   └── service/
│       │   │       └── auth_service.dart       # FirebaseAuth + Google + Firestore user doc
│       │   └── presentation/
│       │       ├── controller/                 # ← ONLY branch-specific folder
│       │       ├── screens/
│       │       │   ├── splash_screen.dart
│       │       │   ├── login_screen.dart
│       │       │   ├── register_screen.dart
│       │       │   └── forgot_password_screen.dart
│       │       └── widgets/
│       │           ├── auth_header.dart
│       │           ├── google_sign_in_button.dart
│       │           └── auth_form_fields.dart
│       │
│       ├── doctors/          # data/{models,repo,service} + presentation/{controller,screens,widgets}
│       ├── appointments/
│       ├── availability/
│       ├── doctor_dashboard/
│       ├── profile/
│       ├── reviews/
│       │   ├── data/                         # models/repo/service as needed
│       │   └── presentation/                  # controller/screens/widgets
│       └── settings/
│           ├── data/
│           │   └── service/                  # deactivation update only; no model/repo
│           └── presentation/                 # controller/screens/widgets
│
├── generated/
│   ├── app_colors.dart                        # hand-maintained OR generated — see 03 §2
│   ├── image_assets.dart                      # asset path constants
│   └── style_atoms.dart                        # ← generated by tool/generate_style.dart
│
└── i18n/                                      # ← ADDED (slang)
    ├── en.i18n.json
    ├── ar.i18n.json
    └── strings.g.dart

tool/
└── generate_style.dart                        # the generator script (NOT inside lib/)

test/
docs/
firestore.rules
firestore.indexes.json
build.yaml
analysis_options.yaml
```

---

## 3. Why `domain/` Was Dropped

The screenshot has no `domain/`, so `01-architecture.md` now describes a two-layer
data flow:

```
Screen → Controller → Repo (abstract) → RepoImpl → Service → Firebase
```

**Trade-off, stated honestly:** we lose the use-case layer. For a portfolio project
comparing state management, that's fine — fewer files, less ceremony, and the
comparison stays focused. The one exception:

> ⚠️ **`getAvailableSlots` must still be a pure, standalone, testable function.**
> It's the only real business logic in the app. Put it in
> `features/availability/data/repo/slot_calculator.dart` as a top-level pure function
> with zero Firebase imports. Do not bury it inside a controller.

---

## 4. Where the Generator Lives

The generator is a **script**, not app code. It must **not** live in `lib/` — otherwise
`dart:io` gets compiled into the app bundle and Flutter Web builds break.

```
tool/generate_style.dart      ← the script
lib/generated/style_atoms.dart ← its output
```

Run with: `dart run tool/generate_style.dart`

---

## 5. Naming Conventions (aligned to the screenshot)

| Thing | Convention | Example |
|---|---|---|
| Files & folders | `snake_case` | `auth_repo_impl.dart` |
| Screens | suffix `Screen` | `LoginScreen` (file: `login_screen.dart`) |
| Controllers (Bloc) | `AuthCubit` + `AuthState` | in `controller/` |
| Controllers (Riverpod) | `AuthNotifier` + `authProvider` | in `controller/` |
| Controllers (GetX) | `AuthController` + `AuthBinding` | in `controller/` |
| Repo abstract | `AuthRepo` | `auth_repo.dart` |
| Repo impl | `AuthRepoImpl` | `auth_repo_impl.dart` |
| Service | `AuthService` | `auth_service.dart` |
| Models | suffix `Model` | `UserModel` |
| Shared widgets | prefix `App` | `AppButton` |
| Feature widgets | descriptive | `DoctorCard` |

---

## 6. Feature Folder Template

Every feature follows this exactly. Copy-paste and rename:

```
features/<name>/
├── data/
│   ├── models/       <name>_model.dart
│   ├── repo/         <name>_repo.dart + <name>_repo_impl.dart
│   └── service/      <name>_service.dart
└── presentation/
    ├── controller/   (branch-specific)
    ├── screens/      <name>_screen.dart
    └── widgets/      <name>_card.dart, ...
```

The `settings` feature is a deliberate exception: it has no domain model or repository,
but it does perform the Spark v1 account-deactivation write, so it keeps a minimal
`data/service/settings_service.dart` and omits `models/` and `repo/`.

Do not pluralize `controller/`; the canonical folder name is singular in every feature.
