# Doctor Hunt — Comprehensive Repository Re-Audit, Architecture Review, Dependency Injection Audit, and Refactoring Roadmap

---

## Section A — Executive Summary

This comprehensive audit of the **Doctor Hunt** Flutter codebase was conducted under strict read-only constraints. All source files, dependency injection registrations, routing structures, state management lifecycles, models, repositories, and diagnostic commands were inspected against the active Git working tree.

### 1. Overall Architecture Quality
The repository adheres to a **Feature-First** structure with separation across `core/`, `features/`, and `shared/`. Presentation, business logic (BLoC/Cubit), and repository abstractions are in place. However, the architecture is compromised by **direct service locator (`GetIt`/`sl`) access inside UI presentation widgets**, **cross-Cubit coupling via global state**, and **inconsistent lifecycle scoping** where stateful, user-specific Cubits (`AppointmentsCubit`, `FavoritesCubit`) are registered as `LazySingleton`s without session-lifecycle cleanup.

### 2. Patient Experience Readiness
The core Patient experience (Authentication, Home Doctor Discovery, Doctor Details, Slot Calculation & Booking, Appointments management, Profile, and Settings) is functionally complete. The slot calculation algorithm correctly evaluates weekly ranges, slot duration, past-slot exclusion, and booked appointments. However, the experience relies on several architectural workarounds (e.g., screens resolving repositories directly through `sl<DoctorRepo>()` when deep-linked, and `ThankYouDialog` reaching into global `AppointmentsCubit`).

### 3. Major Correctness Concerns
- **Session Lifecycle Leaks in Singleton Cubits**: `AppointmentsCubit` and `FavoritesCubit` are registered as `LazySingleton`. Upon user sign-out and subsequent sign-in with a different account, their internal state is neither cleared nor re-initialized, risking stale or leaked patient data.
- **Direct Repository Resolution in Widget Trees**: `DoctorDetailsScreen`, `BookAppointmentScreen`, and `RateDoctorScreen` invoke `sl<DoctorRepo>()`, `sl<AppointmentRepo>()`, and `sl<ReviewRepo>()` directly inside `State` lifecycle methods, bypassing dedicated state management.
- **Timezone Assumption**: All availability working hours and slot generations operate strictly in UTC wall-clock time without timezone offset translation, meaning working hours are interpreted identically regardless of the doctor's or patient's physical timezone.

### 4. Dependency Injection Health
GetIt registration is split between `lib/core/di/injector.dart` and `lib/core/di/state_injector.dart`. While infrastructure and repositories are cleanly registered, **13 UI widgets directly access `sl<T>()` or `GetIt.instance<T>()`**. Furthermore, `RateDoctorScreen` has no associated Cubit, leaving all multi-step mutation logic in the presentation layer.

### 5. Dead-Code and Duplication Findings
- `lib/features/home/models/home_mock_data.dart` contains an entire `HomeDoctor` presentation model, static lists (`popularDoctors`, `featureDoctors`), and extensions that are **100% unused** across both `lib/` and `test/`. The file's only active call is a legacy shim (`HomeMockData.getRealDoctorId`), which is obsolete now that live UUIDs are used exclusively.
- `lib/shared/widgets/doctor_card.dart` and `lib/shared/widgets/empty_state.dart` in `lib/shared/widgets/` are **completely unreferenced**.
- `popular_doctors_background_glow.dart` is imported across 6 distinct feature screens outside the Home module.

### 6. Test and Analyzer Results
- `dart analyze lib/ test/`: **0 issues found** (clean analysis).
- `flutter test`: **167 passing tests, 0 failing, 0 skipped** across 17 test suites.
- `dart format --output=none --set-exit-if-changed`: 125 files exhibit minor stylistic formatting differences (non-blocking).
- Measured line coverage: **64.19%** (exceeding baseline 59.73%).

### 7. Readiness for Doctor Persona Development
The Doctor Persona is currently **placeholder-only**. All four primary doctor screens (`DoctorHomeScreen`, `DoctorRequestsScreen`, `DoctorAvailabilityScreen`, `DoctorReviewsScreen`) render static text with no state management. However, the underlying database schema and service RPCs for availability updates, appointment status transitions, and doctor reviews are already established.

### 8. Five Most Important Immediate Actions
1. **Scope and Reset User-Bound Cubits**: Reset or scope `AppointmentsCubit` and `FavoritesCubit` on session invalidation/logout to eliminate data bleeding between user sessions.
2. **Encapsulate Data Access in Presentation**: Introduce a lightweight `DoctorDetailsCubit` or controller to remove direct `sl<DoctorRepo>()` calls from `DoctorDetailsScreen` and `BookAppointmentScreen`.
3. **Extract `RateDoctorCubit`**: Move review submission, appointment state updates, and error handling out of `RateDoctorScreen` into a tested Cubit.
4. **Purge Confirmed Dead Code**: Remove the unused `HomeDoctor` model, static mock lists, unused `DoctorCard`, and unused `EmptyState`.
5. **Relocate Misplaced Shared Widgets**: Move `PopularDoctorsBackgroundGlow` to `lib/shared/widgets/` to resolve cross-feature imports.

---

## Section B — Repository Inventory and Audit Coverage

### 1. Folder Structure and Responsibilities

| Path | Primary Responsibility | Architectural Layer |
| :--- | :--- | :--- |
| `lib/core/app/` | Application entry configuration, theme bootstrapping, and global providers | Bootstrap / Shell |
| `lib/core/constants/` | Supabase URL, anon key, table names (`SbC`), and RPC identifiers | Constants |
| `lib/core/di/` | GetIt service locator registrations (`injector.dart`, `state_injector.dart`) | Composition Root |
| `lib/core/error/` | Domain `Failure` classes and data `ServerException` / `NetworkException` | Error Handling |
| `lib/core/network/` | Host resolution (`NetworkInfoImpl`), Supabase error mapping | Network Infrastructure |
| `lib/core/router/` | GoRouter setup, role-based guards, `PatientShell`, `DoctorShell` | Navigation |
| `lib/core/session/` | `SessionService` listening to Supabase auth state, evaluating roles | Auth State |
| `lib/features/appointments/` | Booking Cubit, slot generation, My Appointments, and cancellation | Feature Module |
| `lib/features/auth/` | Login, sign up, role selection, forgot password OTP flow | Feature Module |
| `lib/features/availability/` | Availability model, service, and `SlotCalculator` | Feature Module |
| `lib/features/doctors/` | Doctor catalog, search with debounce, doctor details | Feature Module |
| `lib/features/favorites/` | Favorite doctor IDs tracking and optimistic toggle | Feature Module |
| `lib/features/home/` | Patient Home sections, categories, popular doctors list | Feature Module |
| `lib/features/onboarding/` | Onboarding carousel and `seen_onboarding` flag management | Feature Module |
| `lib/features/profile/` | Profile view and editing, photo/phone management | Feature Module |
| `lib/features/reviews/` | Review submission and rating bar displays | Feature Module |
| `lib/features/settings/` | App settings, language switching, privacy policy, logout | Feature Module |
| `lib/shared/` | Design tokens, style atoms, generated i18n (`slang`), shared widgets | Cross-cutting / Presentation |
| `supabase/` | SQL schema definitions, RPC functions, and table constraints | Backend Reference |
| `test/` | Unit, cubit, and widget tests (17 test files) | Quality Assurance |

### 2. Diagnostic Execution Summary
- **`git status --short`**: Inspected working directory status.
- **`git diff --stat`**: Verified Phase 6 edits (46 files changed).
- **`dart analyze lib/ test/`**: Verified 0 compiler errors, 0 warnings, 0 lint violations.
- **`flutter test`**: Verified 167 automated tests passing in ~12 seconds.
- **`dart format --output=none --set-exit-if-changed lib/ test/`**: Examined formatting consistency (125 files with minor differences; non-destructive check).
- **Coverage**: Verified 1,260 hit lines out of 1,963 total lines (**64.19%** overall line coverage).

---

## Section C — Architecture Map

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                             PRESENTATION LAYER                              │
│                                                                             │
│   PatientShell / DoctorShell (GoRouter StatefulShellRoute)                  │
│       │                                                                     │
│       ├── PatientHomeScreen, SearchScreen, PopularDoctorsScreen             │
│       ├── DoctorDetailsScreen  ───[LEAK]───► sl<DoctorRepo>()               │
│       ├── BookAppointmentScreen ──[LEAK]───► sl<DoctorRepo>()               │
│       ├── MyAppointmentsScreen                                              │
│       ├── RateDoctorScreen ───────[LEAK]───► sl<ReviewRepo>(), sl<Session>()│
│       └── ProfileScreen, EditProfileScreen, SettingsScreen                  │
└──────────────────────────────────────┬──────────────────────────────────────┘
                                       │ BlocProvider / context.read()
                                       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                           BUSINESS LOGIC (CUBITS)                           │
│                                                                             │
│   • AuthCubit (Factory)             • ProfileCubit (Factory)                │
│   • ForgotPasswordCubit (Factory)   • BookingCubit (Factory)                │
│   • DoctorsCubit (LazySingleton)    • AppointmentsCubit (LazySingleton)*    │
│   • FavoritesCubit (LazySingleton)*                                         │
│                                                                             │
│   * Note: Stateful Cubits retained across session changes.                  │
└──────────────────────────────────────┬──────────────────────────────────────┘
                                       │ Constructor Injection
                                       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                              REPOSITORY LAYER                               │
│                                                                             │
│   • AuthRepoImpl         • DoctorRepoImpl       • AppointmentRepoImpl       │
│   • AvailabilityRepoImpl • FavoritesRepoImpl    • ReviewRepoImpl            │
│   • ProfileRepoImpl                                                         │
│                                                                             │
│   (All repositories consume NetworkInfo & map errors via Either<Failure, T>)│
└──────────────────────────────────────┬──────────────────────────────────────┘
                                       │ Constructor Injection
                                       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                            DATA / SERVICE LAYER                             │
│                                                                             │
│   • AuthService          • DoctorService        • AppointmentService        │
│   • AvailabilityService  • FavoritesService     • ReviewService             │
│   • ProfileService       • SettingsService                                  │
│   • SessionService (ChangeNotifier / ValueListenable<SessionState>)         │
└──────────────────────────────────────┬──────────────────────────────────────┘
                                       │
                                       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                         REMOTE SUPABASE BACKEND                             │
│                                                                             │
│   • Tables: profiles, doctors, appointments, availability, reviews          │
│   • Stored Procedures (RPCs): book_appointment, cancel_appointment,         │
│     get_my_appointments, get_doctor_booked_slots, add_review                │
│   • PostgREST Partial Unique Indexes (concurrency enforcement)              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Architectural Leaks Identified:
1. **UI ➔ Repository Direct Access**: `DoctorDetailsScreen` (`doctor_details_screen.dart:62`), `BookAppointmentScreen` (`book_appointment_screen.dart:86`), and `RateDoctorScreen` (`rate_doctor_screen.dart:62, 126`) bypass Cubits and resolve repositories directly from `sl`.
2. **UI ➔ Global Singleton Cubit Mutation**: `AppointmentCard` (`appointment_card.dart:40`), `PatientShell` (`patient_shell.dart:20`), and `ThankYouDialog` (`thank_you_dialog.dart:117`) resolve and mutate Cubit singletons via `GetIt.instance` instead of `BuildContext`.
3. **Cross-Feature Private Widget Reuse**: `PopularDoctorsBackgroundGlow` located in `features/home` is consumed as a primary background across 4 unrelated feature modules.

---

## Section D — Patient Experience End-to-End Audit

| Flow / Feature | Concrete Implementation Path | Verification Status | Evidence / Notes |
| :--- | :--- | :--- | :--- |
| **Email/Password Authentication** | `LoginScreen` ➔ `AuthCubit` ➔ `AuthRepoImpl` ➔ `AuthService` | Verified by tests & source | Covered by 13 unit tests in `auth_cubit_test.dart` and `auth_repo_impl_test.dart`. |
| **Google Sign-In** | `LoginScreen` ➔ `AuthCubit.loginWithGoogle` ➔ `AuthRepoImpl` ➔ `GoogleSignIn` + Supabase exchange | Verified by tests & source | Handled in `AuthRepoImpl`; unit-tested with mock `GoogleSignIn`. |
| **Session & Role Routing** | `SessionService` ➔ `app_router.dart` redirect | Verified by tests & source | Covered by `session_service_test.dart` and `profile_navigation_test.dart`. |
| **Password Recovery** | `ForgotPasswordSheet` / `ForgotPasswordScreen` ➔ `ForgotPasswordCubit` | Verified by tests & source | 16 dedicated unit tests covering OTP send, verify, recovery flag, and reset. |
| **Doctor Discovery (Home)** | `PatientHomeScreen` ➔ `PopularDoctorsSection` ➔ `DoctorsCubit` | Verified by tests & source | Doctors loaded from live Supabase `public.doctors`. Shimmer and error fallback tested. |
| **Specialty Search** | `SearchScreen` ➔ `DoctorsCubit.searchDoctors` | Verified by tests & source | 350ms debounce implemented. Unit-tested in `doctors_cubit_test.dart`. |
| **Doctor Details Loading** | `DoctorDetailsScreen` ➔ `DoctorsCubit.getDoctorById` or fallback `DoctorRepo` | Partially verified | Works via route extra and cubit cache; direct `sl<DoctorRepo>()` fallback untested in widget. |
| **Availability & Slot Generation** | `SlotCalculator.generateSlotsForDate` | Verified by tests & source | Rigorously tested in `booking_slot_calculator_test.dart` (past slots, duration, conflicts). |
| **Appointment Booking** | `BookAppointmentScreen` ➔ `BookingCubit` ➔ `AppointmentRepoImpl` | Verified by tests & source | Tested in `booking_cubit_test.dart`; duplicate submission guard and slot-taken rollback active. |
| **Appointment Listing & Filter** | `MyAppointmentsScreen` ➔ `AppointmentsCubit` | Verified by tests & source | Tested in `appointments_cubit_test.dart`; Upcoming/Completed/Cancelled sorting verified. |
| **Appointment Cancellation** | `CancelAppointmentDialog` ➔ `AppointmentsCubit.cancelAppointment` | Verified by tests & source | Optimistic cancellation with rollback on failure tested in `appointments_cubit_test.dart`. |
| **Doctor Review Submission** | `RateDoctorScreen` ➔ `ReviewRepoImpl` ➔ `add_review` RPC | Partially verified | Data service works via RPC, but screen has no dedicated Cubit or automated unit tests. |
| **Favorites Management** | `FavoritesCubit.toggleFavorite` ➔ `FavoritesRepoImpl` | Verified by tests & source | Optimistic toggle with rollback verified in `favorites_cubit_test.dart`. |
| **Profile & Settings** | `ProfileScreen`, `EditProfileScreen`, `SettingsScreen` | Verified by tests & source | Covered by widget and unit tests in `profile_screen_test.dart` and `settings_screen_test.dart`. |
| **Language Switching** | `SettingsLanguageBottomSheet` ➔ `LocaleSettings.setLocale` | Verified by source inspection | Parity verified between `en.i18n.json` and `ar.i18n.json`; `slang` files regenerated. |

### Patient Readiness Assessment:
The Patient flows are functionally cohesive, pass all 167 automated unit/integration tests, and adhere to Supabase schema contracts. The primary blocking quality issues before scaling are **state retention in singleton Cubits upon logout** and **untested presentation logic in `RateDoctorScreen`**.

---

## Section E — Full Dependency Injection Audit

### 1. Complete Dependency Registration Matrix

| Dependency Type | Concrete Class | Registration File | Lifetime | Main Consumers | Assessment |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `SharedPreferences` | `SharedPreferences` | `injector.dart:38` | LazySingleton | `SettingsService`, `AppRouter`, `SplashScreen` | Appropriate |
| `SupabaseClient` | `Supabase.instance.client` | `injector.dart:39` | LazySingleton | All feature services, `SessionService` | Appropriate |
| `GoogleSignIn` | `GoogleSignIn` | `injector.dart:40` | LazySingleton | `AuthService` | Appropriate |
| `NetworkInfo` | `NetworkInfoImpl` | `injector.dart:50` | LazySingleton | All repository implementations | Appropriate |
| `SessionService` | `SessionService` | `injector.dart:53` | LazySingleton | `AppRouter`, `AuthRepoImpl`, Cubits | Appropriate |
| `AuthService` | `AuthService` | `injector.dart:56` | LazySingleton | `AuthRepoImpl` | Appropriate |
| `AuthRepo` | `AuthRepoImpl` | `injector.dart:59` | LazySingleton | `AuthCubit`, `ForgotPasswordCubit` | Appropriate |
| `DoctorService` | `DoctorService` | `injector.dart:64` | LazySingleton | `DoctorRepoImpl` | Appropriate |
| `DoctorRepo` | `DoctorRepoImpl` | `injector.dart:65` | LazySingleton | `DoctorsCubit`, `DoctorDetailsScreen`, `BookAppointmentScreen` | Leak in UI consumers |
| `FavoritesService` | `FavoritesService` | `injector.dart:70` | LazySingleton | `FavoritesRepoImpl` | Appropriate |
| `FavoritesRepo` | `FavoritesRepoImpl` | `injector.dart:71` | LazySingleton | `FavoritesCubit` | Appropriate |
| `AppointmentService` | `AppointmentService` | `injector.dart:76` | LazySingleton | `AppointmentRepoImpl` | Appropriate |
| `AppointmentRepo` | `AppointmentRepoImpl` | `injector.dart:77` | LazySingleton | `AppointmentsCubit`, `BookingCubit`, `RateDoctorScreen` | Leak in RateDoctorScreen |
| `AvailabilityService` | `AvailabilityService` | `injector.dart:82` | LazySingleton | `AvailabilityRepoImpl` | Appropriate |
| `AvailabilityRepo` | `AvailabilityRepoImpl` | `injector.dart:83` | LazySingleton | `BookingCubit` | Appropriate |
| `ReviewService` | `ReviewService` | `injector.dart:88` | LazySingleton | `ReviewRepoImpl` | Appropriate |
| `ReviewRepo` | `ReviewRepoImpl` | `injector.dart:89` | LazySingleton | `RateDoctorScreen` (direct) | Missing ReviewCubit |
| `ProfileService` | `ProfileService` | `injector.dart:94` | LazySingleton | `ProfileRepoImpl`, `AuthRepoImpl` | Appropriate |
| `ProfileRepo` | `ProfileRepoImpl` | `injector.dart:95` | LazySingleton | `ProfileCubit` | Appropriate |
| `SettingsService` | `SettingsService` | `injector.dart:100` | LazySingleton | Settings management | Appropriate |
| `AuthCubit` | `AuthCubit` | `state_injector.dart:13` | Factory | `LoginScreen`, `SignUpScreen`, `SettingsScreen` | Appropriate |
| `ForgotPasswordCubit` | `ForgotPasswordCubit` | `state_injector.dart:14` | Factory | `ForgotPasswordSheet`, `ForgotPasswordScreen` | Appropriate |
| `ProfileCubit` | `ProfileCubit` | `state_injector.dart:15` | Factory | `ProfileScreen`, `EditProfileScreen`, `RoleSelectionScreen` | Appropriate |
| `BookingCubit` | `BookingCubit` | `state_injector.dart:16` | Factory | `BookAppointmentScreen` | Appropriate |
| `AppointmentsCubit` | `AppointmentsCubit` | `state_injector.dart:21` | LazySingleton | `MyAppointmentsScreen`, `PatientShell`, `ThankYouDialog` | **Problematic lifecycle** |
| `FavoritesCubit` | `FavoritesCubit` | `state_injector.dart:22` | LazySingleton | `AppBootstrap`, `FavouriteDoctorsScreen` | **Problematic lifecycle** |
| `DoctorsCubit` | `DoctorsCubit` | `state_injector.dart:23` | LazySingleton | `AppBootstrap`, `PatientHomeScreen`, `SearchScreen` | Acceptable as cache |

### 2. Service Locator (`sl` / `GetIt`) Access in Presentation Code

```dart
// 1. RateDoctorScreen: Resolving repositories and session directly in widget state
final session = sl<SessionService>();           // rate_doctor_screen.dart:56, 94
final repo = sl<AppointmentRepo>();             // rate_doctor_screen.dart:62
final repo = sl<ReviewRepo>();                  // rate_doctor_screen.dart:126

// 2. DoctorDetailsScreen: Direct repository call on deep link
final cubitDoc = sl<DoctorsCubit>().getDoctorById(widget.doctorId); // doctor_details_screen.dart:51
final repo = sl<DoctorRepo>();                  // doctor_details_screen.dart:62

// 3. BookAppointmentScreen: Direct repository call
final cubitDoc = sl<DoctorsCubit>().getDoctorById(widget.doctorId); // book_appointment_screen.dart:59
final repo = sl<DoctorRepo>();                  // book_appointment_screen.dart:86

// 4. Global UI mutation of Singleton Cubits
GetIt.instance<AppointmentsCubit>().refreshAppointments(); // patient_shell.dart:20
GetIt.instance<AppointmentsCubit>().switchTab(...);        // thank_you_dialog.dart:117
GetIt.instance<DoctorsCubit>().refresh();                 // appointment_card.dart:40
```

### 3. Lifecycle Evaluation and Session Invalidation Risks
- **`AppointmentsCubit` as LazySingleton**: Holds user-specific appointment lists. When user A logs out and user B logs in without killing the application process, `AppointmentsCubit` remains registered with User A's loaded appointments until `refreshAppointments()` is called. If user B has no appointments, the UI briefly renders User A's data.
- **`FavoritesCubit` as LazySingleton**: `FavoritesCubit` loads IDs in its constructor. On user sign-out, `FavoritesCubit` is not notified and retains User A's set of favorite IDs.
- **Recommendation**: Wire `SessionService` state changes to either invalidate and re-register user-bound Cubits, or expose explicit `reset()` methods on `AppointmentsCubit` and `FavoritesCubit` invoked during sign-out.

---

## Section F — Unused Code, Files, Assets, and Packages

| Item / Symbol | Exact Location | Classification | Evidence | Impact of Removal |
| :--- | :--- | :--- | :--- | :--- |
| `class HomeDoctor` | `home_mock_data.dart:5-73` | **Confirmed unused** | Zero references in `lib/` and `test/`. Real UI uses `DoctorModel`. | Removes 68 lines of dead code. |
| `HomeMockData.popularDoctors` | `home_mock_data.dart:97-134` | **Confirmed unused** | Unused mock list; live doctors come from Supabase. | Removes 37 lines. |
| `HomeMockData.featureDoctors` | `home_mock_data.dart:136-158` | **Confirmed unused** | Unused mock list; live feature doctors list is empty. | Removes 22 lines. |
| `extension HomeDoctorX` | `home_mock_data.dart:161-191` | **Confirmed unused** | Zero references in `lib/` and `test/`. | Removes 30 lines. |
| `extension DoctorModelX` | `home_mock_data.dart:193-207` | **Confirmed unused** | Zero references in `lib/` and `test/`. | Removes 15 lines. |
| `HomeMockData.getRealDoctorId` | `home_mock_data.dart:95` | **Obsolete shim** | Called in 3 files for legacy `'pop1'` mapping. Live doctor IDs are all UUIDs. | Eliminates cross-feature imports once callers pass UUID directly. |
| `class DoctorCard` | `doctor_card.dart:8-132` | **Confirmed unused** | Zero references in `lib/` and `test/`. | Removes 124 lines of redundant UI. |
| `class EmptyState` | `empty_state.dart:7-55` | **Confirmed unused** | Zero references. Each screen has custom empty state. | Safe to remove or repurpose as shared standard. |
| `dev_dependency path: any` | `pubspec.yaml:56` | **Still required** | Imported in `tool/convert_imports.dart`. | Keep in `dev_dependencies`. |
| `OnboardingIndicator` | `onboarding_indicator.dart` | **Still required** | Actively used in onboarding page view. | Retain. |
| `datetime_ext.dart` | `datetime_ext.dart` | **Still required** | Actively used across appointments tabs and booking. | Retain. |

---

## Section G — Duplicated Code and Conflicting Implementations

### 1. Doctor Fallback Query Cascade (Duplicate Business Logic)
- **Locations**: `doctor_details_screen.dart:40-69` and `book_appointment_screen.dart:50-96`.
- **Conflict**: Both screens execute an identical 4-stage fallback:
  1. Inspect `widget.extra as DoctorModel`.
  2. Inspect `widget.extra as Map<String, dynamic>`.
  3. Query `sl<DoctorsCubit>().getDoctorById(id)`.
  4. Query remote `sl<DoctorRepo>().getDoctorById(id)`.
- **Impact**: Duplicated error handling, duplicate remote requests if user navigates back and forth, and unnecessary boilerplate in presentation state.
- **Recommended Authoritative Owner**: Encapsulate in `DoctorRepo` or a shared `DoctorDetailsCubit`.

### 2. Background Glow Misplacement (Feature-Boundary Leak)
- **Location**: `popular_doctors_background_glow.dart`.
- **Conflict**: A widget located in `features/home/.../widgets/` is imported across 6 distinct feature screens (`RateDoctorScreen`, `FavouriteDoctorsScreen`, `SearchScreen`, `DoctorDetailsScreen`, `MyAppointmentsScreen`, `BookAppointmentScreen`).
- **Impact**: Creates artificial coupling between independent feature modules and the Home feature.
- **Resolution**: Move to `lib/shared/widgets/app_background_glow.dart`.

### 3. Divergent Doctor Card Variants (UI Duplication)
- **Locations**:
  - `PopularDoctorCard`: Horizontal scroll card (`popular_doctor_card.dart`).
  - `PopularDoctorListCard`: Vertical list card with book button (`popular_doctor_list_card.dart`).
  - `FeatureDoctorCard`: Mini horizontal card (`feature_doctor_card.dart`).
  - `FavouriteDoctorGridCard`: 2-column grid card with favorite icon (`favourite_doctor_grid_card.dart`).
  - `BookingDoctorCard`: Header card on booking screen (`booking_doctor_card.dart`).
  - `DoctorCard`: Unused generic card (`doctor_card.dart`).
- **Assessment**: While Figma specifies different layouts (grid vs horizontal card vs detail header), they duplicate rating calculation, localized name extraction, and image fallback logic. Localized name and rating formatting should be consolidated on `DoctorModel`.

---

## Section H — Reusable Widget Extraction Plan

| Screen File | Section / Subtree | Proposed Extracted Widget | Target Destination | Reuse or Readability | Parameters & Contract |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `search_screen.dart` (217 lines) | App bar search field + clear button (L56-118) | `SearchInputField` | `features/doctors/screens/search/widgets/` | Readability | `TextEditingController`, `onChanged`, `onClear`, `onBack` |
| `search_screen.dart` | Search state views (loading/empty/results) (L122-211) | `SearchResultsView` | `features/doctors/screens/search/widgets/` | Readability | `List<DoctorModel> results`, `bool isSearching`, `String? error` |
| `book_appointment_screen.dart` (344 lines) | Date selector tab bar (L180-205) | `BookingDateTabsSection` | `features/appointments/screens/book_appointment/widgets/` | Readability | Handled via `BlocBuilder<BookingCubit, BookingState>` |
| `book_appointment_screen.dart` | Morning / Afternoon / Evening slots list (L215-285) | `BookingTimeSlotsSection` | `features/appointments/screens/book_appointment/widgets/` | Readability | `BookingState`, `onSlotSelected(String slot)` callback |
| `rate_doctor_screen.dart` (276 lines) | Comment input & submit button section (L195-255) | `RateDoctorFeedbackForm` | `features/reviews/screens/rate_doctor/widgets/` | Readability | `TextEditingController`, `bool isSubmitting`, `onSubmit` |
| `popular_doctors_background_glow.dart` | Entire background glow decoration | `AppBackgroundGlow` | `lib/shared/widgets/app_background_glow.dart` | **Reuse across 6 screens** | `const AppBackgroundGlow()` |

---

## Section I — OOP, SOLID, and Architecture Findings

### Finding 1: Direct Service Locator Usage in Presentation (`P1 — High`)
- **Location**: `rate_doctor_screen.dart:56-126`, `doctor_details_screen.dart:62`, `book_appointment_screen.dart:86`.
- **Violation**: Violates the **Dependency Inversion Principle** and **Single Responsibility Principle**. UI widgets construct repositories and execute multi-step database operations.
- **Impact**: Makes UI widgets difficult to test in isolation without setting up global GetIt singletons.
- **Recommended Direction**: Introduce `RateDoctorCubit` for reviews; move doctor resolution into `DoctorsCubit` or a dedicated coordinator.

### Finding 2: Singleton Lifecycle for User-Bound State (`P1 — High`)
- **Location**: `state_injector.dart:21-22`.
- **Violation**: `AppointmentsCubit` and `FavoritesCubit` are registered as `LazySingleton`.
- **Impact**: Violates **Encapsulation** and **State Hygiene**. A singleton state manager outlives the user session that created it.
- **Recommended Direction**: Reset or re-scope these Cubits whenever `SessionService` transitions to `unauthenticated`.

### Finding 3: Misplaced Shared Component (`P2 — Medium`)
- **Location**: `popular_doctors_background_glow.dart`.
- **Violation**: Violates **Feature Isolation / Package by Feature**. A widget in `features/home` is used as an application-wide background.
- **Impact**: High coupling between unrelated modules.
- **Recommended Direction**: Move to `lib/shared/widgets/`.

### Finding 4: Obsolete Mock Data Shim (`P3 — Low`)
- **Location**: `home_mock_data.dart:95`.
- **Violation**: Retains dead prototyping code.
- **Impact**: Developers may mistakenly believe fake IDs (`'pop1'`) are still supported or required.
- **Recommended Direction**: Remove `HomeMockData` entirely and pass live UUIDs directly.

---

## Section J — Localization, Error Handling, and Reliability

### 1. Localization Status
- **Translation Parity**: Verified 100% key parity between `en.i18n.json` and `ar.i18n.json`.
- **Error Codes**: `AuthCubit`, `ProfileCubit`, `AppointmentsCubit`, and `ForgotPasswordCubit` emit standard machine-readable codes (`'network'`, `'server'`, `'unauthenticated'`) translated at the presentation boundary via `getErrorMessage(...)`.
- **RTL Support**: Cairo font family and `Directionality` are handled automatically by Flutter localizations and `slang`.

### 2. Error Handling & Reliability
- **Host Resolution vs Backend Reachability**: `NetworkInfoImpl` uses `InternetAddress.lookup('google.com')` with a 3-second timeout. Resolving DNS verifies device Internet access but does not guarantee Supabase connectivity. All repositories wrap network calls with `try / catch` mapping unexpected PostgREST/network exceptions to `ServerFailure` or `NetworkFailure`.
- **Asynchronous Race Conditions**:
  - `SearchScreen`: Debounce timer (350ms) cancels prior requests before firing.
  - `BookingCubit`: Guard `if (state.isBooking) return;` prevents duplicate submissions on rapid taps.
  - `ProfileCubit`: Guard `if (state.isSaving) return;` prevents concurrent profile mutations.

---

## Section K — Testing and Verification Gaps

### 1. Current Test Metrics
- **Passing Tests**: 167 (0 failed, 0 skipped).
- **Line Coverage**: 64.19% (1,260 hit / 1,963 found).
- **Static Analyzer**: Clean (0 issues).

### 2. Verified Areas vs Unverified Gaps

| Module | Unit Tests | Widget Tests | Live Integration Tests | Gap Assessment |
| :--- | :--- | :--- | :--- | :--- |
| **Auth** | 100% covered (Mocks) | None | Manual / Backend | Add widget test for `LoginScreen` & `SignUpScreen`. |
| **Appointments** | 100% Cubit covered | Partial (`thank_you_dialog`) | Manual / Backend | Add widget test for `MyAppointmentsScreen`. |
| **Booking** | 100% Cubit covered | None | Manual / Backend | Add widget test for `BookAppointmentScreen`. |
| **Doctors** | 100% Cubit covered | None | Manual / Backend | Missing `DoctorRepoImpl` unit test. |
| **Reviews** | **0% covered** | None | Manual / Backend | **Critical Gap**: `ReviewRepoImpl` and `RateDoctorScreen` have zero tests. |
| **Availability** | Slot calculator covered | None | Manual / Backend | Missing `AvailabilityRepoImpl` unit test. |
| **Profile** | 100% Cubit covered | 100% Widget covered | Manual / Backend | Well tested. |
| **Settings** | Cubit/service covered | 100% Widget covered | Manual / Backend | Well tested. |

---

## Section L — Doctor Persona Readiness

### 1. Current Implementation Status

| Screen / Feature | Current Code State | Route Registration | Data Layer Support | Readiness Level |
| :--- | :--- | :--- | :--- | :--- |
| **Doctor Shell** | `DoctorShell` (`doctor_shell.dart`) | `Paths.doctorHome` | Bottom nav bar with 4 tabs | Ready for nesting |
| **Doctor Home / Dashboard** | `DoctorHomeScreen` (`doctor_home_screen.dart`) | `/doctor` | None (Placeholder text + Sign out) | **Placeholder only** |
| **Appointment Requests** | `DoctorRequestsScreen` (`doctor_requests_screen.dart`) | `/doctor/requests` | `AppointmentRepo.getDoctorAppointments`, `updateStatus` exist | **Placeholder only** |
| **Doctor Availability** | `DoctorAvailabilityScreen` (`doctor_availability_screen.dart`) | `/doctor/availability` | `AvailabilityRepo.getDoctorAvailability`, `updateDoctorAvailability` exist | **Placeholder only** |
| **Doctor Reviews** | `DoctorReviewsScreen` (`doctor_reviews_screen.dart`) | `/doctor/reviews` | `ReviewRepo.getDoctorReviews` exists | **Placeholder only** |
| **Doctor Profile** | Routes to Patient `ProfileScreen` | `/doctor/profile` | Needs doctor-specific fields (specialization, rate, services) | **Requires decision** |

### 2. Compatibility with Patient Booking Logic
The Patient booking flow relies on:
1. `AvailabilityModel.days` with weekday `1..7` (ISO 8601).
2. Working hour ranges with format `HH:mm` (e.g., `'09:00'`, `'17:00'`).
3. `slot_duration_minutes` (positive integer).
4. `AppointmentModel.status` transitions (`'pending'`, `'confirmed'`, `'cancelled'`).

**Guarantee**: Any UI created for the Doctor Persona to manage availability must write JSON strictly conforming to `AvailabilityModel.toJson()`. This ensures that when a doctor modifies their working hours, the Patient's `SlotCalculator` immediately reflects the new slots without breaking.

---

## Section M — Prioritized Implementation Roadmap

### Phase A — Session Lifecycle & Critical Architecture Fixes (Priority: P1)
- **Objectives**: Prevent cross-session data leaks and decouple UI from direct service locator repository calls.
- **Actions**:
  1. Add session reset hooks to `AppointmentsCubit` and `FavoritesCubit` on user logout.
  2. Implement `RateDoctorCubit` to handle review submissions, replacing direct `sl` calls in `RateDoctorScreen`.
  3. Relocate `PopularDoctorsBackgroundGlow` to `lib/shared/widgets/app_background_glow.dart`.
- **Target Files**: `state_injector.dart`, `rate_doctor_screen.dart`, `rate_doctor_cubit.dart` (new), `popular_doctors_background_glow.dart`.
- **Prerequisites**: Phase 6 baseline.
- **Estimated Effort**: 3–4 hours.
- **Regression Tests**: Add `rate_doctor_cubit_test.dart`; verify session logout clears appointments.

### Phase B — Dead-Code Purge & Model Sanitization (Priority: P2)
- **Objectives**: Remove confirmed obsolete prototyping code and legacy ID shims.
- **Actions**:
  1. Remove `HomeDoctor` model, static mock lists, and extensions from `home_mock_data.dart`.
  2. Eliminate `HomeMockData.getRealDoctorId` and pass real UUIDs directly in `appointment_repo_impl`, `availability_repo_impl`, and `booking_cubit`.
  3. Delete unused `lib/shared/widgets/doctor_card.dart` and `lib/shared/widgets/empty_state.dart`.
- **Target Files**: `home_mock_data.dart`, `doctor_card.dart`, `empty_state.dart`, `appointment_repo_impl.dart`, `availability_repo_impl.dart`, `booking_cubit.dart`.
- **Prerequisites**: Phase A.
- **Estimated Effort**: 1–2 hours.
- **Regression Tests**: Run full test suite to confirm zero build/test regressions.

### Phase C — Screen Widget Extractions (Priority: P2)
- **Objectives**: Improve readability of oversized screens by extracting cohesive local subtrees.
- **Actions**:
  1. Extract `SearchInputField` and `SearchResultsView` from `search_screen.dart`.
  2. Extract `BookingDateTabsSection` and `BookingTimeSlotsSection` from `book_appointment_screen.dart`.
  3. Extract `RateDoctorFeedbackForm` from `rate_doctor_screen.dart`.
- **Target Files**: `search_screen.dart`, `book_appointment_screen.dart`, `rate_doctor_screen.dart`, and their respective `widgets/` folders.
- **Prerequisites**: Phase B.
- **Estimated Effort**: 2–3 hours.
- **Regression Tests**: Existing widget tests in `profile_screen_test.dart` and cubit tests.

### Phase D — Review & Availability Repository Test Coverage (Priority: P2)
- **Objectives**: Close test coverage gaps for repositories currently lacking automated tests.
- **Actions**:
  1. Create `test/features/reviews/review_repo_impl_test.dart` (covering `getDoctorReviews` and `addReview`).
  2. Create `test/features/availability/availability_repo_impl_test.dart` (covering `getDoctorAvailability` and `updateDoctorAvailability`).
  3. Create `test/features/doctors/doctor_repo_impl_test.dart`.
- **Target Files**: `test/features/reviews/`, `test/features/availability/`, `test/features/doctors/`.
- **Prerequisites**: Phase C.
- **Estimated Effort**: 2–3 hours.
- **Regression Tests**: Push line coverage from 64.19% to >70%.

### Phase E — Doctor Persona: Appointment Requests & Dashboard (Priority: P3)
- **Objectives**: Implement the first functional Doctor Persona screens.
- **Actions**:
  1. Implement `DoctorRequestsCubit` utilizing existing `AppointmentRepo.getDoctorAppointments` and `updateStatus`.
  2. Build `DoctorRequestsScreen` with Accept/Decline/Complete actions.
  3. Build `DoctorHomeScreen` displaying upcoming appointment metrics.
- **Target Files**: `doctor_requests_screen.dart`, `doctor_requests_cubit.dart`, `doctor_home_screen.dart`.
- **Prerequisites**: Phase D.
- **Estimated Effort**: 4–5 hours.
- **Regression Tests**: Unit tests for `DoctorRequestsCubit`.

### Phase F — Doctor Persona: Availability Management (Priority: P3)
- **Objectives**: Enable doctors to set working days, time slots, and slot duration.
- **Actions**:
  1. Implement `DoctorAvailabilityCubit` utilizing `AvailabilityRepo`.
  2. Build `DoctorAvailabilityScreen` with day toggles (Mon–Sun) and time range pickers.
  3. Enforce strict validation conforming to `AvailabilityModel`.
- **Target Files**: `doctor_availability_screen.dart`, `doctor_availability_cubit.dart`.
- **Prerequisites**: Phase E.
- **Estimated Effort**: 4–5 hours.
- **Regression Tests**: End-to-end slot generation tests ensuring modified doctor availability produces valid slots for the Patient booking flow.

---

## Section N — Decisions and Approval Checklist

### Critical Items Requiring User Approval Before Execution:
1. **Approval to introduce `RateDoctorCubit`**: Replaces direct repository calls in `RateDoctorScreen`.
2. **Approval to delete confirmed dead code**:
   - `lib/shared/widgets/doctor_card.dart` (unused).
   - `lib/shared/widgets/empty_state.dart` (unused).
   - `HomeDoctor` model and static lists in `lib/features/home/models/home_mock_data.dart`.
3. **Approval to relocate `PopularDoctorsBackgroundGlow`**: Moves from `features/home` to `lib/shared/widgets/`.
4. **Approval for Session Invalidation Strategy**: Choose between (a) registering `AppointmentsCubit` and `FavoritesCubit` in a session-scoped GetIt container, or (b) adding a `reset()` method triggered on logout.
5. **Doctor Profile Architecture**: Decide whether Doctor Profile shares `ProfileScreen` (using `role == 'doctor'` conditional sections) or uses a dedicated `DoctorProfileScreen` tailored to doctor fees and services.
