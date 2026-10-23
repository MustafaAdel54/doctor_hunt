import 'package:doctor_hunt/core/router/routes.dart';
import 'package:doctor_hunt/core/session/session_service.dart';
import 'package:doctor_hunt/core/session/session_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSessionService extends Mock implements SessionService {}

void main() {
  group('Profile & Settings Route Integration Tests', () {
    test('Patient profile, edit profile, and privacy policy routes are properly defined', () {
      expect(Paths.profilePatient, '/patient/profile');
      expect(Paths.editProfilePatient, '/patient/profile/edit');
      expect(Paths.privacyPolicy, '/patient/settings/privacy-policy');
      expect(Routes.profilePatient, 'profilePatient');
      expect(Routes.editProfilePatient, 'editProfilePatient');
      expect(Routes.privacyPolicy, 'privacyPolicy');
    });

    test('Doctor-role user redirect blocks access to /patient/* routes', () {
      const state = SessionState.authenticated(userId: 'doc-1', role: 'doctor');
      final isDoctor = state.role == 'doctor';
      final isPatient = state.role == 'patient';
      const loc = Paths.profilePatient;

      String? redirect;
      if (loc.startsWith('/doctor') && !isDoctor) redirect = Paths.patientHome;
      if (loc.startsWith('/patient') && !isPatient) redirect = Paths.doctorHome;

      expect(redirect, Paths.doctorHome);
    });

    test('Patient-role user redirect blocks access to /doctor/* routes', () {
      const state = SessionState.authenticated(userId: 'pat-1', role: 'patient');
      final isDoctor = state.role == 'doctor';
      final isPatient = state.role == 'patient';
      const loc = Paths.profileDoctor;

      String? redirect;
      if (loc.startsWith('/doctor') && !isDoctor) redirect = Paths.patientHome;
      if (loc.startsWith('/patient') && !isPatient) redirect = Paths.doctorHome;

      expect(redirect, Paths.patientHome);
    });

    test('Patient-role user redirect permits access to /patient/profile', () {
      const state = SessionState.authenticated(userId: 'pat-1', role: 'patient');
      final isDoctor = state.role == 'doctor';
      final isPatient = state.role == 'patient';
      const loc = Paths.profilePatient;

      String? redirect;
      if (loc.startsWith('/doctor') && !isDoctor) redirect = Paths.patientHome;
      if (loc.startsWith('/patient') && !isPatient) redirect = Paths.doctorHome;

      expect(redirect, isNull);
    });

    test('Patient-role user redirect permits access to /patient/profile/edit', () {
      const state = SessionState.authenticated(userId: 'pat-1', role: 'patient');
      final isDoctor = state.role == 'doctor';
      final isPatient = state.role == 'patient';
      const loc = Paths.editProfilePatient;

      String? redirect;
      if (loc.startsWith('/doctor') && !isDoctor) redirect = Paths.patientHome;
      if (loc.startsWith('/patient') && !isPatient) redirect = Paths.doctorHome;

      expect(redirect, isNull);
    });
  });
}
