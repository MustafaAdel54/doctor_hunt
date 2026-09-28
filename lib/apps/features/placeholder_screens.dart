import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Splash')));
}

class DoctorOnboardingScreen extends StatelessWidget {
  const DoctorOnboardingScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('DoctorOnboarding')));
}

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('ForgotPassword')));
}

class AccountInactiveScreen extends StatelessWidget {
  const AccountInactiveScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('AccountInactive')));
}

// Removed PatientHomeScreen placeholder

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Search')));
}

class BookAppointmentScreen extends StatelessWidget {
  const BookAppointmentScreen({super.key, required this.doctorId});
  final String doctorId;
  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text('BookAppointment: $doctorId')));
}

class MyAppointmentsScreen extends StatelessWidget {
  const MyAppointmentsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('MyAppointments')));
}

class RateDoctorScreen extends StatelessWidget {
  const RateDoctorScreen({super.key, required this.appointmentId});
  final String appointmentId;
  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text('RateDoctor: $appointmentId')));
}

class DoctorHomeScreen extends StatelessWidget {
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
}

class DoctorRequestsScreen extends StatelessWidget {
  const DoctorRequestsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('DoctorRequests')));
}

class DoctorAvailabilityScreen extends StatelessWidget {
  const DoctorAvailabilityScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('DoctorAvailability')));
}

class DoctorReviewsScreen extends StatelessWidget {
  const DoctorReviewsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('DoctorReviews')));
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Profile')));
}

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('EditProfile')));
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Settings')));
}

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key, this.error});
  final Object? error;
  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text('NotFound: $error')));
}

class PatientShell extends StatelessWidget {
  const PatientShell({super.key, required this.navigationShell});
  final Widget navigationShell;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: navigationShell,
    bottomNavigationBar: BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Appointments',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    ),
  );
}

class DoctorShell extends StatelessWidget {
  const DoctorShell({super.key, required this.navigationShell});
  final Widget navigationShell;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: navigationShell,
    bottomNavigationBar: BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Requests'),
        BottomNavigationBarItem(
          icon: Icon(Icons.schedule),
          label: 'Availability',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Reviews'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    ),
  );
}
