import 'package:dartz/dartz.dart';
import 'package:doctor_hunt/core/error/failures.dart';
import 'package:doctor_hunt/core/network/network_info.dart';
import 'package:doctor_hunt/core/network/supabase_error_mapper.dart';
import 'package:doctor_hunt/features/auth/models/user_model.dart';
import 'package:doctor_hunt/features/auth/service/auth_service.dart';
import 'package:doctor_hunt/features/profile/service/profile_service.dart';

import 'auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  const AuthRepoImpl({
    required this.service,
    required this.profileService,
    required this.networkInfo,
  });

  final AuthService service;
  final ProfileService profileService;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, UserModel>> loginWithEmail(
    String email,
    String password,
  ) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      final user = await service.loginWithEmail(email, password);
      return Right(user);
    } catch (e) {
      return Left(SupabaseErrorMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, void>> registerWithEmailOnly(
    String email,
    String password,
    String name,
  ) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      await service.registerWithEmailOnly(email, password, name);
      return const Right(null);
    } catch (e) {
      return Left(SupabaseErrorMapper.map(e));
    }
  }


  @override
  Future<Either<Failure, void>> loginWithGoogle() async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      await service.loginWithGoogle();
      return const Right(null);
    } catch (e) {
      return Left(SupabaseErrorMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      await service.resetPassword(email);
      return const Right(null);
    } catch (e) {
      return Left(SupabaseErrorMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      await service.logout();
      return const Right(null);
    } catch (e) {
      return Left(SupabaseErrorMapper.map(e));
    }
  }
}
