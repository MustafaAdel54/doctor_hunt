import 'package:doctor_hunt/core/network/network_info.dart';
import 'package:doctor_hunt/core/session/session_service.dart';
import 'package:doctor_hunt/features/appointments/repo/appointment_repo.dart';
import 'package:doctor_hunt/features/appointments/repo/appointment_repo_impl.dart';
import 'package:doctor_hunt/features/appointments/service/appointment_service.dart';
import 'package:doctor_hunt/features/auth/repo/auth_repo.dart';
import 'package:doctor_hunt/features/auth/repo/auth_repo_impl.dart';
// Features
import 'package:doctor_hunt/features/auth/service/auth_service.dart';
import 'package:doctor_hunt/features/availability/repo/availability_repo.dart';
import 'package:doctor_hunt/features/availability/repo/availability_repo_impl.dart';
import 'package:doctor_hunt/features/availability/service/availability_service.dart';
import 'package:doctor_hunt/features/doctors/repo/doctor_repo.dart';
import 'package:doctor_hunt/features/doctors/repo/doctor_repo_impl.dart';
import 'package:doctor_hunt/features/doctors/service/doctor_service.dart';
import 'package:doctor_hunt/features/favorites/repo/favorites_repo.dart';
import 'package:doctor_hunt/features/favorites/repo/favorites_repo_impl.dart';
import 'package:doctor_hunt/features/favorites/service/favorites_service.dart';
import 'package:doctor_hunt/features/profile/repo/profile_repo.dart';
import 'package:doctor_hunt/features/profile/repo/profile_repo_impl.dart';
import 'package:doctor_hunt/features/profile/service/profile_service.dart';
import 'package:doctor_hunt/features/reviews/repo/review_repo.dart';
import 'package:doctor_hunt/features/reviews/repo/review_repo_impl.dart';
import 'package:doctor_hunt/features/reviews/service/review_service.dart';
import 'package:doctor_hunt/features/settings/service/settings_service.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'state_injector.dart';

final sl = GetIt.instance;

Future<void> initCore() async {
  // External
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => prefs);
  sl.registerLazySingleton(() => Supabase.instance.client);
  sl.registerLazySingleton(
    () => GoogleSignIn(
      // Web OAuth client (client_type: 3) from google-services.json.
      // Required so that googleAuth.idToken is populated for Supabase credential exchange.
      serverClientId:
          '495407091381-oovsqnelafi4ljqov7te0ot7s70e48cc.apps.googleusercontent.com',
    ),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => const NetworkInfoImpl());

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
  sl.registerLazySingleton(() => DoctorService(supabase: sl()));
  sl.registerLazySingleton<DoctorRepo>(
    () => DoctorRepoImpl(service: sl(), networkInfo: sl()),
  );

  // Features - Favorites
  sl.registerLazySingleton(() => FavoritesService(supabase: sl()));
  sl.registerLazySingleton<FavoritesRepo>(
    () => FavoritesRepoImpl(service: sl(), networkInfo: sl()),
  );

  // Features - Appointments
  sl.registerLazySingleton(() => AppointmentService(supabase: sl()));
  sl.registerLazySingleton<AppointmentRepo>(
    () => AppointmentRepoImpl(service: sl(), networkInfo: sl()),
  );

  // Features - Availability
  sl.registerLazySingleton(() => AvailabilityService(supabase: sl()));
  sl.registerLazySingleton<AvailabilityRepo>(
    () => AvailabilityRepoImpl(service: sl(), networkInfo: sl()),
  );

  // Features - Reviews
  sl.registerLazySingleton(() => ReviewService(supabase: sl()));
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
