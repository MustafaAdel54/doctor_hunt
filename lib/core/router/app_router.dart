import 'package:doctor_hunt/apps/features/home/presentation/screens/patient_home/patient_home_screen.dart';
import 'package:doctor_hunt/apps/features/placeholder_screens.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import '../session/session_service.dart';
import '../session/session_state.dart';
import 'routes.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login/login_screen.dart';
import '../../features/auth/presentation/screens/signup/signup_screen.dart';
import '../../features/auth/presentation/screens/role_selection/role_selection_screen.dart';
import '../../features/doctors/presentation/screens/doctor_details/doctor_details_screen.dart';

GoRouter createRouter(SessionService session) => GoRouter(
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

    // 1. Still resolving → stay on splash
    if (s.status == SessionStatus.initial) {
      return onSplash ? null : Paths.splash;
    }

    // 2. Signed out → allow auth/onboarding pages only
    if (s.status == SessionStatus.unauthenticated) {
      final onAuthEntryPage = onOnboarding || onRoleSelection || onAuthPage;
      return onAuthEntryPage ? null : Paths.onboarding;
    }

    // 3. Supabase user authenticated but no PostgreSQL application profile.
    //    Must go through Role Selection before reaching any home screen.
    if (s.status == SessionStatus.authenticatedWithoutProfile) {
      return onRoleSelection ? null : Paths.roleSelection;
    }

    // 3.5. Profile exists but is marked inactive
    if (s.status == SessionStatus.authenticatedInactive) {
      final onInactivePage = loc == Paths.accountInactive;
      return onInactivePage ? null : Paths.accountInactive;
    }

    // 4. Fully authenticated with a role.
    final isDoctor = s.role == 'doctor';
    final isPatient = s.role == 'patient';
    final home = isDoctor ? Paths.doctorHome : Paths.patientHome;

    // Redirect away from splash/auth/role pages to the correct home
    if (onSplash || onRoleSelection || onAuthPage || onOnboarding) return home;

    // Role isolation: prevent patients accessing doctor routes and vice versa
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
                  path: 'doctor/:doctorId',
                  name: Routes.doctorDetails,
                  builder: (_, s) => DoctorDetailsScreen(
                    doctorId: s.pathParameters['doctorId']!,
                  ),
                ),
                GoRoute(
                  path: 'doctor/:doctorId/book',
                  name: Routes.bookAppointment,
                  builder: (_, s) => BookAppointmentScreen(
                    doctorId: s.pathParameters['doctorId']!,
                  ),
                ),
              ],
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
