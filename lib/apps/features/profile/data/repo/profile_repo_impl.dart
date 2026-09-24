import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/supabase_error_mapper.dart';
import '../../../../core/network/network_info.dart';
import '../../../auth/data/models/user_model.dart';
import 'profile_repo.dart';
import '../service/profile_service.dart';

class ProfileRepoImpl implements ProfileRepo {
  const ProfileRepoImpl({required this.service, required this.networkInfo});

  final ProfileService service;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, UserModel>> getProfile(String uid) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      final profile = await service.getProfile(uid);
      return Right(profile);
    } catch (e) {
      return Left(SupabaseErrorMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, void>> updateProfile(UserModel user) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      await service.updateProfile(user);
      return const Right(null);
    } catch (e) {
      return Left(SupabaseErrorMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, void>> updateActiveStatus(
    String uid,
    bool isActive,
  ) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      if (!isActive) {
        await service.deactivateAccount();
      } else {
        // We only support deactivation per the Supabase migration
        throw UnimplementedError('Activation is not supported');
      }
      return const Right(null);
    } catch (e) {
      return Left(SupabaseErrorMapper.map(e));
    }
  }
}
