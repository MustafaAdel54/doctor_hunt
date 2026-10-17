import 'package:doctor_hunt/features/auth/cubit/auth_cubit.dart';
import 'package:doctor_hunt/features/profile/cubit/profile_cubit.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void initState() {
  sl.registerFactory(() => AuthCubit(repo: sl(), sessionService: sl()));
  sl.registerFactory(() => ProfileCubit(repo: sl(), sessionService: sl()));
}
