abstract final class Routes {
  // shell-less
  static const splash = 'splash';
  static const onboarding = 'onboarding';
  static const roleSelection = 'roleSelection';
  static const doctorOnboarding = 'doctorOnboarding';
  static const login = 'login';
  static const register = 'register';
  static const forgotPassword = 'forgotPassword';
  static const accountInactive = 'accountInactive';

  // patient
  static const patientHome = 'patientHome';
  static const search = 'search';
  static const doctorDetails = 'doctorDetails'; // :doctorId
  static const rateDoctor = 'rateDoctor'; // :appointmentId
  static const bookAppointment = 'bookAppointment'; // :doctorId
  static const myAppointments = 'myAppointments';

  // doctor
  static const doctorHome = 'doctorHome';
  static const doctorRequests = 'doctorRequests';
  static const doctorAvailability = 'doctorAvailability';
  static const doctorReviews = 'doctorReviews';

  // role-specific profile routes (same screen implementation, distinct route names)
  static const profilePatient = 'profilePatient';
  static const editProfilePatient = 'editProfilePatient';
  static const profileDoctor = 'profileDoctor';
  static const editProfileDoctor = 'editProfileDoctor';

  // shared
  static const settings = 'settings';
}

abstract final class Paths {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const roleSelection = '/role';
  static const doctorOnboarding = '/doctor-onboarding';
  static const login = '/login';
  static const register = '/register'; // ?role=patient|doctor
  static const forgotPassword = '/forgot-password';
  static const accountInactive = '/account-inactive';

  static const patientHome = '/patient';
  static const search = 'search'; // nested under patientHome
  static const doctorDetails = 'doctor/:doctorId'; // nested under patientHome
  static const bookAppointment = 'doctor/:doctorId/book';
  static const myAppointments = '/patient/appointments';
  static const rateDoctor =
      ':appointmentId/rate'; // nested under myAppointments

  static const doctorHome = '/doctor';
  static const doctorRequests = '/doctor/requests';
  static const doctorAvailability = '/doctor/availability';
  static const doctorReviews = '/doctor/reviews';

  // Same ProfileScreen implementation, but role-scoped routes avoid duplicate names/paths.
  static const profilePatient = '/patient/profile';
  static const profileDoctor = '/doctor/profile';
  static const editProfilePatient = '/patient/profile/edit';
  static const editProfileDoctor = '/doctor/profile/edit';
  static const settings = '/settings';
}
