import 'dart:io';

void main() {
  final content = File('lib/apps/features/placeholder_screens.dart').readAsStringSync();
  
  void writeStub(String path, String name, String classContent, [bool importsSupabase = false]) {
    final file = File(path);
    file.parent.createSync(recursive: true);
    
    var out = "import 'package:flutter/material.dart';\n";
    if (importsSupabase) {
      out += "import 'package:supabase_flutter/supabase_flutter.dart';\n";
    }
    if (classContent.contains('t.')) {
      out += "import 'package:doctor_hunt/shared/i18n/strings.g.dart';\n";
    }
    out += "\n" + classContent + "\n";
    file.writeAsStringSync(out);
  }

  // 1. SplashScreen
  writeStub('lib/features/auth/screens/splash/splash_screen.dart', 'SplashScreen',
  '''class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Splash')));
}''');

  // 2. DoctorOnboardingScreen
  writeStub('lib/features/onboarding/screens/doctor_onboarding_screen.dart', 'DoctorOnboardingScreen',
  '''class DoctorOnboardingScreen extends StatelessWidget {
  const DoctorOnboardingScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('DoctorOnboarding')));
}''');

  // 3. ForgotPasswordScreen
  writeStub('lib/features/auth/screens/forgot_password/forgot_password_screen.dart', 'ForgotPasswordScreen',
  '''class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('ForgotPassword')));
}''');

  // 4. AccountInactiveScreen
  writeStub('lib/features/auth/screens/account_inactive/account_inactive_screen.dart', 'AccountInactiveScreen',
  '''class AccountInactiveScreen extends StatelessWidget {
  const AccountInactiveScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('AccountInactive')));
}''');

  // 5. SearchScreen
  writeStub('lib/features/doctors/screens/search/search_screen.dart', 'SearchScreen',
  '''class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Search')));
}''');

  // 6. BookAppointmentScreen
  writeStub('lib/features/appointments/screens/book_appointment/book_appointment_screen.dart', 'BookAppointmentScreen',
  '''class BookAppointmentScreen extends StatelessWidget {
  const BookAppointmentScreen({super.key, required this.doctorId});
  final String doctorId;
  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text('BookAppointment: \')));
}''');

  // 7. MyAppointmentsScreen
  writeStub('lib/features/appointments/screens/my_appointments/my_appointments_screen.dart', 'MyAppointmentsScreen',
  '''class MyAppointmentsScreen extends StatelessWidget {
  const MyAppointmentsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('MyAppointments')));
}''');

  // 8. RateDoctorScreen
  writeStub('lib/features/reviews/screens/rate_doctor/rate_doctor_screen.dart', 'RateDoctorScreen',
  '''class RateDoctorScreen extends StatelessWidget {
  const RateDoctorScreen({super.key, required this.appointmentId});
  final String appointmentId;
  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text('RateDoctor: \')));
}''');

  // 9. DoctorHomeScreen
  writeStub('lib/features/home/screens/doctor_home/doctor_home_screen.dart', 'DoctorHomeScreen',
  '''class DoctorHomeScreen extends StatelessWidget {
  const DoctorHomeScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('DoctorHome'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Supabase.instance.client.auth.signOut(),
            child: const Text('Logout'),
          ),
        ],
      ),
    ),
  );
}''', true);

  // 10. DoctorRequestsScreen
  writeStub('lib/features/appointments/screens/doctor_requests/doctor_requests_screen.dart', 'DoctorRequestsScreen',
  '''class DoctorRequestsScreen extends StatelessWidget {
  const DoctorRequestsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('DoctorRequests')));
}''');

  // 11. DoctorAvailabilityScreen
  writeStub('lib/features/availability/screens/doctor_availability/doctor_availability_screen.dart', 'DoctorAvailabilityScreen',
  '''class DoctorAvailabilityScreen extends StatelessWidget {
  const DoctorAvailabilityScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('DoctorAvailability')));
}''');

  // 12. DoctorReviewsScreen
  writeStub('lib/features/reviews/screens/doctor_reviews/doctor_reviews_screen.dart', 'DoctorReviewsScreen',
  '''class DoctorReviewsScreen extends StatelessWidget {
  const DoctorReviewsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('DoctorReviews')));
}''');

  // 13. ProfileScreen
  writeStub('lib/features/profile/screens/profile/profile_screen.dart', 'ProfileScreen',
  '''class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Profile')));
}''');

  // 14. EditProfileScreen
  writeStub('lib/features/profile/screens/edit_profile/edit_profile_screen.dart', 'EditProfileScreen',
  '''class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('EditProfile')));
}''');

  // 15. SettingsScreen
  writeStub('lib/features/settings/screens/settings_screen.dart', 'SettingsScreen',
  '''class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Settings')));
}''');

  // 16. NotFoundScreen
  writeStub('lib/core/router/not_found_screen.dart', 'NotFoundScreen',
  '''class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key, this.error});
  final Object? error;
  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text('NotFound: \')));
}''');

  // 17. PatientShell
  writeStub('lib/core/router/patient_shell.dart', 'PatientShell',
  '''class PatientShell extends StatelessWidget {
  const PatientShell({super.key, required this.navigationShell});
  final Widget navigationShell;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: navigationShell,
    bottomNavigationBar: BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: t.nav.home),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: t.appointments.title,
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: t.nav.profile),
      ],
    ),
  );
}''');

  // 18. DoctorShell
  writeStub('lib/core/router/doctor_shell.dart', 'DoctorShell',
  '''class DoctorShell extends StatelessWidget {
  const DoctorShell({super.key, required this.navigationShell});
  final Widget navigationShell;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: navigationShell,
    bottomNavigationBar: BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: t.nav.home),
        BottomNavigationBarItem(icon: Icon(Icons.list), label: t.nav.requests),
        BottomNavigationBarItem(
          icon: Icon(Icons.schedule),
          label: t.doctor.availability,
        ),
        BottomNavigationBarItem(icon: Icon(Icons.star), label: t.reviews.title),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: t.nav.profile),
      ],
    ),
  );
}''');
}
