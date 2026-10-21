import 'package:doctor_hunt/features/appointments/cubit/appointments_cubit.dart';
import 'package:doctor_hunt/features/appointments/cubit/booking_cubit.dart';
import 'package:doctor_hunt/features/auth/cubit/auth_cubit.dart';
import 'package:doctor_hunt/features/auth/cubit/forgot_password_cubit.dart';
import 'package:doctor_hunt/features/doctors/cubit/doctors_cubit.dart';
import 'package:doctor_hunt/features/favorites/cubit/favorites_cubit.dart';
import 'package:doctor_hunt/features/profile/cubit/profile_cubit.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void initState() {
  sl.registerFactory(() => AuthCubit(repo: sl(), sessionService: sl()));
  sl.registerFactory(() => ForgotPasswordCubit(repo: sl(), sessionService: sl()));
  sl.registerFactory(() => ProfileCubit(repo: sl(), sessionService: sl()));
  sl.registerFactory(() => BookingCubit(
        appointmentRepo: sl(),
        availabilityRepo: sl(),
        sessionService: sl(),
      ));
  sl.registerLazySingleton(() => AppointmentsCubit(repo: sl(), sessionService: sl()));
  sl.registerLazySingleton(() => FavoritesCubit(repo: sl()));
  sl.registerLazySingleton(() => DoctorsCubit(doctorRepo: sl()));
}
