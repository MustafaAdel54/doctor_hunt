import 'package:get_it/get_it.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';

final sl = GetIt.instance;

void initState() {
  sl.registerFactory(() => AuthCubit(repo: sl(), sessionService: sl()));
  sl.registerFactory(() => ProfileCubit(repo: sl(), sessionService: sl()));
}
