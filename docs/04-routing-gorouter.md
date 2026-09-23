# 04 — Routing with go_router

The trickiest integration point in this app: **go_router + Supabase Auth + two roles**.
Get this right once in `main` and all three branches inherit it.

---

## 1. Route Constants

```dart
// core/router/routes.dart
abstract final class Routes {
  // shell-less
  static const splash          = 'splash';
  static const roleSelection    = 'roleSelection';
  static const doctorOnboarding = 'doctorOnboarding';
  static const login           = 'login';
  static const register        = 'register';
  static const forgotPassword  = 'forgotPassword';
  static const accountInactive  = 'accountInactive';

  // patient
  static const patientHome     = 'patientHome';
  static const search          = 'search';
  static const doctorDetails   = 'doctorDetails';     // :doctorId
  static const rateDoctor      = 'rateDoctor';        // :appointmentId
  static const bookAppointment = 'bookAppointment';   // :doctorId
  static const myAppointments  = 'myAppointments';

  // doctor
  static const doctorHome       = 'doctorHome';
  static const doctorRequests   = 'doctorRequests';
  static const doctorAvailability = 'doctorAvailability';
  static const doctorReviews    = 'doctorReviews';

  // role-specific profile routes (same screen implementation, distinct route names)
  static const profilePatient     = 'profilePatient';
  static const editProfilePatient = 'editProfilePatient';
  static const profileDoctor      = 'profileDoctor';
  static const editProfileDoctor  = 'editProfileDoctor';

  // shared
  static const settings = 'settings';
}

abstract final class Paths {
  static const splash            = '/';
  static const roleSelection     = '/role';
  static const doctorOnboarding  = '/doctor-onboarding';
  static const login             = '/login';
  static const register         = '/register';        // ?role=patient|doctor
  static const forgotPassword   = '/forgot-password';
  static const accountInactive   = '/account-inactive';

  static const patientHome      = '/patient';
  static const search           = 'search';                         // nested under patientHome
  static const doctorDetails    = 'doctor/:doctorId';              // nested under patientHome
  static const bookAppointment  = 'doctor/:doctorId/book';
  static const myAppointments   = '/patient/appointments';
  static const rateDoctor      = ':appointmentId/rate';            // nested under myAppointments

  static const doctorHome        = '/doctor';
  static const doctorRequests    = '/doctor/requests';
  static const doctorAvailability= '/doctor/availability';
  static const doctorReviews     = '/doctor/reviews';

  // Same ProfileScreen implementation, but role-scoped routes avoid duplicate names/paths.
  static const profilePatient    = '/patient/profile';
  static const profileDoctor     = '/doctor/profile';
  static const editProfilePatient= '/patient/profile/edit';
  static const editProfileDoctor = '/doctor/profile/edit';
  static const settings          = '/settings';
}
```

**Always navigate by name**, never by raw path string:
`context.goNamed(Routes.doctorDetails, pathParameters: {'doctorId': id})`.

---

## 2. Auth-Aware Refresh

`go_router` re-evaluates `redirect` only when something tells it to. Bridge the
Supabase auth state stream:

```dart
// core/router/router_refresh_stream.dart
class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _sub;
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _sub = stream.asBroadcastStream().listen((_) => notifyListeners());
  }
  @override
  void dispose() { _sub.cancel(); super.dispose(); }
}
```

---

## 3. The Session Holder

`supabase.auth.onAuthStateChange` tells you **if** someone is signed in — not their
role. The role lives in the `profiles` table in PostgreSQL. So we need a small,
branch-agnostic session object the router can read **synchronously**.

```dart
// core/session/session_state.dart
enum SessionStatus {
  unknown,
  unauthenticated,
  authenticatedWithoutProfile,
  authenticatedInactive,
  authenticated,
}

class SessionState {
  final SessionStatus status;
  final UserModel? user;
  final String? firebaseUid;

  const SessionState({
    required this.status,
    this.user,
    this.firebaseUid,
  });

  bool get isDoctor => user?.role == UserRole.doctor;
  bool get isPatient => user?.role == UserRole.patient;

  /// A Supabase auth user exists, but their profile row has not been created yet.
  /// This is the expected state after a first-time Google sign-in until the
  /// user completes role selection.
  bool get needsProfile => status == SessionStatus.authenticatedWithoutProfile;

  /// Doctor signed up but hasn't finished the onboarding wizard (07 §A5).
  bool get profileIncomplete =>
      status == SessionStatus.authenticated &&
      isDoctor &&
      !(user?.isProfileComplete ?? false);
}
```

A `SessionService` (shared, in `core/session/`) listens to `authStateChanges`,
fetches/streams the Firestore user doc, and exposes:
- `ValueListenable<SessionState>` (used as the router's `refreshListenable`)
- `SessionState get current` (read synchronously inside `redirect`)

If Supabase reports a signed-in user but their profile row does not exist, the service
sets `SessionStatus.authenticatedWithoutProfile` rather than inventing a role. That
state is required for the first Google sign-in flow and redirects only to role selection.

> This is the key design choice: the **router depends on `SessionService`, not on any
> Cubit/Notifier/Controller**, so `app_router.dart` is byte-identical across all
> three branches. Branch-specific auth state management talks to the shared repository
> and the Supabase stream updates `SessionService`.

---

### Supabase deactivated-session state

A persisted `profiles.is_active == false` must be exposed as an explicit
`SessionStatus.authenticatedInactive`. The router sends that user to a small
`/account-inactive` screen instead of treating the session as a normal authenticated
profile, effectively blocking them from logging in. The screen can offer **Reactivate account** by setting `isActive` back to `true`
and then returning through the normal role-based redirect.

## 4. Router Definition

```dart
// core/router/app_router.dart
GoRouter createRouter(SessionService session) => GoRouter(
  initialLocation: Paths.splash,
  refreshListenable: session.listenable,
  debugLogDiagnostics: kDebugMode,

  redirect: (context, state) {
    final s = session.current;
    final loc = state.matchedLocation;

    final onSplash = loc == Paths.splash;
    final onRoleSelection = loc == Paths.roleSelection;
    final onAuthPage = const [
      Paths.login, Paths.register, Paths.forgotPassword,
    ].contains(loc);
    final onOnboarding = loc == Paths.doctorOnboarding;

    // 1. still resolving → stay on splash
    if (s.status == SessionStatus.unknown) return onSplash ? null : Paths.splash;

    // 2. signed out → auth entry pages only; role selection is allowed here
    //    because it is the first step before registration.
    if (s.status == SessionStatus.unauthenticated) {
      final onAuthEntryPage = onRoleSelection || onAuthPage;
      return onAuthEntryPage ? null : Paths.roleSelection;
    }

    // 3. Supabase auth user exists but the PostgreSQL profile does not yet exist.
    //    Do not invent a role or send the user into a role home.
    if (s.status == SessionStatus.authenticatedWithoutProfile) {
      return onRoleSelection ? null : Paths.roleSelection;
    }

    // 4. deactivated profile — allow only the inactive-account screen.
    if (s.status == SessionStatus.authenticatedInactive) {
      return loc == Paths.accountInactive ? null : Paths.accountInactive;
    }

    // 5. doctor with an incomplete profile is trapped in the wizard
    if (s.isDoctor && s.profileIncomplete) {
      return onOnboarding ? null : Paths.doctorOnboarding;
    }
    // ...and can't re-enter it once complete
    if (onOnboarding && !s.profileIncomplete) return Paths.doctorHome;

    // 6. signed in with a complete profile but sitting on splash/auth → home
    final home = s.isDoctor ? Paths.doctorHome : Paths.patientHome;
    if (onSplash || onRoleSelection || onAuthPage) return home;

    // 7. role isolation
    if (loc.startsWith('/doctor') && !s.isDoctor) return Paths.patientHome;
    if (loc.startsWith('/patient') && !s.isPatient) return Paths.doctorHome;

    return null;
  },

  routes: [
    GoRoute(path: Paths.splash, name: Routes.splash, builder: (_, __) => const SplashScreen()),
    GoRoute(path: Paths.roleSelection, name: Routes.roleSelection,
        builder: (_, __) => const RoleSelectionScreen()),
    GoRoute(path: Paths.login,  name: Routes.login,  builder: (_, __) => const LoginScreen()),
    GoRoute(
      path: Paths.register, name: Routes.register,
      builder: (_, s) => RegisterScreen(
        role: UserRole.fromString(s.uri.queryParameters['role'] ?? 'patient'),
      ),
    ),
    GoRoute(path: Paths.doctorOnboarding, name: Routes.doctorOnboarding,
        builder: (_, __) => const DoctorOnboardingScreen()),
    GoRoute(path: Paths.forgotPassword, name: Routes.forgotPassword, builder: (_, __) => const ForgotPasswordScreen()),
    GoRoute(path: Paths.accountInactive, name: Routes.accountInactive, builder: (_, __) => const AccountInactiveScreen()),

    // ---- Patient shell (bottom nav) ----
    StatefulShellRoute.indexedStack(
      builder: (_, __, shell) => PatientShell(navigationShell: shell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(path: Paths.patientHome, name: Routes.patientHome,
            builder: (_, __) => const PatientHomeScreen(),
            routes: [
              GoRoute(path: Paths.search, name: Routes.search,
                builder: (_, __) => const SearchScreen()),
              GoRoute(path: Paths.doctorDetails, name: Routes.doctorDetails,
                builder: (_, s) => DoctorDetailsScreen(doctorId: s.pathParameters['doctorId']!)),
              GoRoute(path: Paths.bookAppointment, name: Routes.bookAppointment,
                builder: (_, s) => BookAppointmentScreen(doctorId: s.pathParameters['doctorId']!)),
            ]),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: Paths.myAppointments,
            name: Routes.myAppointments,
            builder: (_, __) => const MyAppointmentsScreen(),
            routes: [
              GoRoute(
                path: Paths.rateDoctor,
                name: Routes.rateDoctor,
                builder: (_, s) => RateDoctorScreen(
                  appointmentId: s.pathParameters['appointmentId']!,
                ),
              ),
            ],
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: Paths.profilePatient,
            name: Routes.profilePatient,
            builder: (_, __) => const ProfileScreen(),
            routes: [
              GoRoute(
                path: 'edit',
                name: Routes.editProfilePatient,
                builder: (_, __) => const EditProfileScreen(),
              ),
            ],
          ),
        ]),
      ],
    ),

    // ---- Doctor shell ----
    StatefulShellRoute.indexedStack(
      builder: (_, __, shell) => DoctorShell(navigationShell: shell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(path: Paths.doctorHome, name: Routes.doctorHome,
            builder: (_, __) => const DoctorHomeScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: Paths.doctorRequests, name: Routes.doctorRequests,
            builder: (_, __) => const DoctorRequestsScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: Paths.doctorAvailability, name: Routes.doctorAvailability,
            builder: (_, __) => const DoctorAvailabilityScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: Paths.doctorReviews, name: Routes.doctorReviews,
            builder: (_, __) => const DoctorReviewsScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: Paths.profileDoctor,
            name: Routes.profileDoctor,
            builder: (_, __) => const ProfileScreen(),
            routes: [
              GoRoute(
                path: 'edit',
                name: Routes.editProfileDoctor,
                builder: (_, __) => const EditProfileScreen(),
              ),
            ],
          ),
        ]),
      ],
    ),
  ],

  errorBuilder: (_, s) => NotFoundScreen(error: s.error),
);
```

---

## 5. Gotchas (read before debugging for two hours)

1. **Profile is role-scoped in the route table.** Use distinct paths and names
   (`/patient/profile` + `profilePatient`, `/doctor/profile` + `profileDoctor`) even though
   both routes render the same `ProfileScreen` implementation. Never register the same route
   name/path in both shells.
2. **Redirect loops.** Every branch of `redirect` must be able to return `null`.
   If `redirect` always returns a path, go_router throws after 5 iterations.
3. **Splash is not a loading spinner you `push`.** It's a real route that `redirect`
   parks you on while `SessionStatus.unknown`.
4. **`StatefulShellRoute` children need relative paths** (`doctor/:id`, not `/doctor/:id`)
   if you want them inside the shell; a leading `/` pushes them fullscreen over it.
5. **GetX branch:** use `MaterialApp.router`, **not** `GetMaterialApp`'s routing.
   You still get `GetMaterialApp.router(routerConfig: ...)` if you want snackbars/dialogs
   via `Get.snackbar`, but `Get.to()` / `Get.offAll()` must **never** be called —
   they bypass go_router and desync the URL stack. Documented again in `08`.
6. **The onboarding gate can deadlock.** If `isProfileComplete` never flips true, the
   doctor is stuck forever. Make sure the wizard's final step writes it, and add a
   "sign out" action inside the wizard as an escape hatch.
7. **Deep links / role change:** if a doctor's role is changed server-side, the
   Supabase realtime listener (or profile refresh) updates `SessionService` → `notifyListeners()` → redirect kicks
   them out automatically. Make sure `SessionService` listens to the user **profile row**,
   not just the auth state.

---

## 6. Transitions

Centralize page transitions instead of per-route `CustomTransitionPage` copies:

```dart
// core/router/transitions.dart
CustomTransitionPage<T> fadePage<T>({required Widget child, required LocalKey key}) =>
  CustomTransitionPage<T>(
    key: key, child: child,
    transitionDuration: AppConstants.pageTransition,
    transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
  );
```
