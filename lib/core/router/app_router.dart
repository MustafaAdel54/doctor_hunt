import 'package:doctor_hunt/core/di/injector.dart';
import 'package:doctor_hunt/core/router/doctor_shell.dart';
import 'package:doctor_hunt/core/router/not_found_screen.dart';
import 'package:doctor_hunt/core/router/patient_shell.dart';
import 'package:doctor_hunt/core/session/session_service.dart';
import 'package:doctor_hunt/core/session/session_state.dart';
import 'package:doctor_hunt/features/appointments/screens/book_appointment/book_appointment_screen.dart';
import 'package:doctor_hunt/features/appointments/screens/doctor_requests/doctor_requests_screen.dart';
import 'package:doctor_hunt/features/appointments/screens/my_appointments/my_appointments_screen.dart';
import 'package:doctor_hunt/features/auth/screens/account_inactive/account_inactive_screen.dart';
import 'package:doctor_hunt/features/auth/screens/forgot_password/forgot_password_screen.dart';
import 'package:doctor_hunt/features/auth/screens/login/login_screen.dart';
import 'package:doctor_hunt/features/auth/screens/role_selection/role_selection_screen.dart';
import 'package:doctor_hunt/features/auth/screens/signup/signup_screen.dart';
import 'package:doctor_hunt/features/auth/screens/splash/splash_screen.dart';
import 'package:doctor_hunt/features/availability/screens/doctor_availability/doctor_availability_screen.dart';
import 'package:doctor_hunt/features/doctors/screens/doctor_details/doctor_details_screen.dart';
import 'package:doctor_hunt/features/doctors/screens/search/search_screen.dart';
import 'package:doctor_hunt/features/favorites/screens/favourite_doctors/favourite_doctors_screen.dart';
import 'package:doctor_hunt/features/home/screens/doctor_home/doctor_home_screen.dart';
import 'package:doctor_hunt/features/home/screens/patient_home/patient_home_screen.dart';
import 'package:doctor_hunt/features/home/screens/popular_doctors/popular_doctors_screen.dart';
import 'package:doctor_hunt/features/onboarding/screens/doctor_onboarding_screen.dart';
import 'package:doctor_hunt/features/onboarding/screens/onboarding_screen.dart';
import 'package:doctor_hunt/features/profile/screens/edit_profile/edit_profile_screen.dart';
import 'package:doctor_hunt/features/profile/screens/profile/profile_screen.dart';
import 'package:doctor_hunt/features/reviews/screens/doctor_reviews/doctor_reviews_screen.dart';
import 'package:doctor_hunt/features/reviews/screens/rate_doctor/rate_doctor_screen.dart';
import 'package:doctor_hunt/features/settings/screens/settings_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'routes.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

GoRouter createRouter(SessionService session) => GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: Paths.splash,
  refreshListenable: session,
  debugLogDiagnostics: kDebugMode,

  redirect: (context, state) {
    final s = session.value;
    final loc = state.matchedLocation;

    final onSplash = loc == Paths.splash;
    final onOnboarding = loc == Paths.onboarding;
    final onRoleSelection = loc == Paths.roleSelection;
    final onAuthPage = const [
      Paths.login,
      Paths.register,
      Paths.forgotPassword,
    ].contains(loc);

    // Allow SplashScreen to display its animation and load data in background
    if (onSplash) return null;

    if (s.status == SessionStatus.initial) {
      return Paths.splash;
    }

    if (s.status == SessionStatus.unauthenticated) {
      final onAuthEntryPage = onOnboarding || onRoleSelection || onAuthPage;
      if (onAuthEntryPage) return null;
      final seenOnboarding =
          sl<SharedPreferences>().getBool('seen_onboarding') ?? false;
      return seenOnboarding ? Paths.login : Paths.onboarding;
    }

    if (s.status == SessionStatus.authenticatedWithoutProfile) {
      return onRoleSelection ? null : Paths.roleSelection;
    }

    if (s.status == SessionStatus.authenticatedInactive) {
      final onInactivePage = loc == Paths.accountInactive;
      return onInactivePage ? null : Paths.accountInactive;
    }

    final isDoctor = s.role == 'doctor';
    final isPatient = s.role == 'patient';
    final home = isDoctor ? Paths.doctorHome : Paths.patientHome;

    if (onRoleSelection || onAuthPage || onOnboarding) return home;

    if (loc.startsWith('/doctor') && !isDoctor) return Paths.patientHome;
    if (loc.startsWith('/patient') && !isPatient) return Paths.doctorHome;

    return null;
  },

  routes: [
    GoRoute(
      path: Paths.splash,
      name: Routes.splash,
      builder: (_, __) => const SplashScreen(),
    ),
    GoRoute(
      path: Paths.onboarding,
      name: Routes.onboarding,
      builder: (_, __) => const OnboardingScreen(),
    ),
    GoRoute(
      path: Paths.roleSelection,
      name: Routes.roleSelection,
      builder: (_, __) => const RoleSelectionScreen(),
    ),
    GoRoute(
      path: Paths.login,
      name: Routes.login,
      builder: (_, __) => const LoginScreen(),
    ),
    GoRoute(
      path: Paths.register,
      name: Routes.register,
      builder: (_, __) => const SignupScreen(),
    ),
    GoRoute(
      path: Paths.doctorOnboarding,
      name: Routes.doctorOnboarding,
      builder: (_, __) => const DoctorOnboardingScreen(),
    ),
    GoRoute(
      path: Paths.forgotPassword,
      name: Routes.forgotPassword,
      builder: (_, __) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: Paths.accountInactive,
      name: Routes.accountInactive,
      builder: (_, __) => const AccountInactiveScreen(),
    ),

    // ---- Patient shell (bottom nav) ----
    StatefulShellRoute.indexedStack(
      builder: (_, __, shell) => PatientShell(navigationShell: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Paths.patientHome,
              name: Routes.patientHome,
              builder: (_, __) => const PatientHomeScreen(),
              routes: [
                GoRoute(
                  path: 'search',
                  name: Routes.search,
                  builder: (_, __) => const SearchScreen(),
                ),
                GoRoute(
                  parentNavigatorKey: rootNavigatorKey,
                  path: Paths.popularDoctors,
                  name: Routes.popularDoctors,
                  builder: (_, __) => const PopularDoctorsScreen(),
                ),
                GoRoute(
                  parentNavigatorKey: rootNavigatorKey,
                  path: 'doctor/:doctorId',
                  name: Routes.doctorDetails,
                  builder: (_, s) => DoctorDetailsScreen(
                    doctorId: s.pathParameters['doctorId']!,
                    extra: s.extra,
                  ),
                ),
                GoRoute(
                  parentNavigatorKey: rootNavigatorKey,
                  path: Paths.bookAppointment,
                  name: Routes.bookAppointment,
                  builder: (_, s) => BookAppointmentScreen(
                    doctorId: s.pathParameters['doctorId']!,
                    extra: s.extra,
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Paths.favoriteDoctors,
              name: Routes.favoriteDoctors,
              builder: (ctx, __) => const FavouriteDoctorsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Paths.myAppointments,
              name: Routes.myAppointments,
              builder: (_, __) => const MyAppointmentsScreen(),
              routes: [
                GoRoute(
                  path: ':appointmentId/rate',
                  name: Routes.rateDoctor,
                  builder: (_, s) => RateDoctorScreen(
                    appointmentId: s.pathParameters['appointmentId']!,
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Paths.settings,
              name: Routes.settings,
              builder: (_, __) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),

    // ---- Doctor shell ----
    StatefulShellRoute.indexedStack(
      builder: (_, __, shell) => DoctorShell(navigationShell: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Paths.doctorHome,
              name: Routes.doctorHome,
              builder: (_, __) => const DoctorHomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Paths.doctorRequests,
              name: Routes.doctorRequests,
              builder: (_, __) => const DoctorRequestsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Paths.doctorAvailability,
              name: Routes.doctorAvailability,
              builder: (_, __) => const DoctorAvailabilityScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Paths.doctorReviews,
              name: Routes.doctorReviews,
              builder: (_, __) => const DoctorReviewsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
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
          ],
        ),
      ],
    ),
  ],

  errorBuilder: (_, s) => NotFoundScreen(error: s.error),
);
