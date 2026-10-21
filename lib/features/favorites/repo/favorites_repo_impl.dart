import 'package:dartz/dartz.dart';
import 'package:doctor_hunt/core/error/failures.dart';
import 'package:doctor_hunt/core/network/network_info.dart';
import 'package:doctor_hunt/core/network/supabase_error_mapper.dart';
import 'package:doctor_hunt/features/favorites/service/favorites_service.dart';

import 'favorites_repo.dart';

class FavoritesRepoImpl implements FavoritesRepo {
  const FavoritesRepoImpl({
    required this.service,
    required this.networkInfo,
  });

  final FavoritesService service;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, List<String>>> getFavoriteDoctorIds() async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      final ids = await service.getFavoriteDoctorIds();
      return Right(ids);
    } catch (e) {
      return Left(SupabaseErrorMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, void>> addFavorite(String doctorId) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      await service.addFavorite(doctorId);
      return const Right(null);
    } catch (e) {
      return Left(SupabaseErrorMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, void>> removeFavorite(String doctorId) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      await service.removeFavorite(doctorId);
      return const Right(null);
    } catch (e) {
      return Left(SupabaseErrorMapper.map(e));
    }
  }
}
