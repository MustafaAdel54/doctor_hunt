import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/network_info.dart';
import '../session/session_service.dart';
import 'state_injector.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

// Features
import '../../features/auth/data/service/auth_service.dart';
import '../../features/auth/data/repo/auth_repo.dart';
import '../../features/auth/data/repo/auth_repo_impl.dart';
import '../../features/doctors/data/service/doctor_service.dart';
import '../../features/doctors/data/repo/doctor_repo.dart';
import '../../features/doctors/data/repo/doctor_repo_impl.dart';
import '../../features/appointments/data/service/appointment_service.dart';
import '../../features/appointments/data/repo/appointment_repo.dart';
import '../../features/appointments/data/repo/appointment_repo_impl.dart';
import '../../features/availability/data/service/availability_service.dart';
import '../../features/availability/data/repo/availability_repo.dart';
import '../../features/availability/data/repo/availability_repo_impl.dart';
import '../../features/reviews/data/service/review_service.dart';
import '../../features/reviews/data/repo/review_repo.dart';
import '../../features/reviews/data/repo/review_repo_impl.dart';
import '../../features/profile/data/service/profile_service.dart';
import '../../features/profile/data/repo/profile_repo.dart';
import '../../features/profile/data/repo/profile_repo_impl.dart';
import '../../features/settings/data/service/settings_service.dart';

final sl = GetIt.instance;

Future<void> initCore() async {
  // External
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => prefs);
  sl.registerLazySingleton(() => Supabase.instance.client);
  sl.registerLazySingleton(() => FirebaseFirestore.instance); // Legacy services
  sl.registerLazySingleton(
    () => GoogleSignIn(
      // Web OAuth client (client_type: 3) from google-services.json.
      // Required so that googleAuth.idToken is populated for Supabase credential exchange.
      serverClientId:
          '495407091381-oovsqnelafi4ljqov7te0ot7s70e48cc.apps.googleusercontent.com',
    ),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  // Session
  sl.registerLazySingleton(() => SessionService(supabase: sl()));

  // Features - Auth
  sl.registerLazySingleton(
    () => AuthService(supabase: sl(), googleSignIn: sl()),
  );
  sl.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(service: sl(), profileService: sl(), networkInfo: sl()),
  );

  // Features - Doctors
  sl.registerLazySingleton(() => DoctorService(firestore: sl())); // Will update in later phases
  sl.registerLazySingleton<DoctorRepo>(
    () => DoctorRepoImpl(service: sl(), networkInfo: sl()),
  );

  // Features - Appointments
  sl.registerLazySingleton(() => AppointmentService(firestore: sl())); // Will update in later phases
  sl.registerLazySingleton<AppointmentRepo>(
    () => AppointmentRepoImpl(service: sl(), networkInfo: sl()),
  );

  // Features - Availability
  sl.registerLazySingleton(() => AvailabilityService(firestore: sl())); // Will update in later phases
  sl.registerLazySingleton<AvailabilityRepo>(
    () => AvailabilityRepoImpl(service: sl(), networkInfo: sl()),
  );

  // Features - Reviews
  sl.registerLazySingleton(() => ReviewService(firestore: sl())); // Will update in later phases
  sl.registerLazySingleton<ReviewRepo>(
    () => ReviewRepoImpl(service: sl(), networkInfo: sl()),
  );

  // Features - Profile
  sl.registerLazySingleton(() => ProfileService(supabase: sl())); // Updated in Phase 3
  sl.registerLazySingleton<ProfileRepo>(
    () => ProfileRepoImpl(service: sl(), networkInfo: sl()),
  );

  // Features - Settings
  sl.registerLazySingleton(() => SettingsService(prefs: sl()));

  // State Management (branch-specific)
  initState();
}
