import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/firebase_error_mapper.dart';
import '../../../../core/network/network_info.dart';
import '../models/user_model.dart';
import 'auth_repo.dart';
import '../service/auth_service.dart';

class AuthRepoImpl implements AuthRepo {
  const AuthRepoImpl({required this.service, required this.networkInfo});

  final AuthService service;
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
      return Left(FirebaseErrorMapper.map(e));
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
      return Left(FirebaseErrorMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, UserModel>> createUserProfile({
    required String uid,
    required String email,
    required String role,
    String? name,
    String? photoUrl,
    String? phone,
    bool isVerified = false,
  }) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      final user = await service.createUserProfile(
        uid: uid,
        email: email,
        role: role,
        name: name,
        photoUrl: photoUrl,
        phone: phone,
        isVerified: isVerified,
      );
      return Right(user);
    } catch (e) {
      return Left(FirebaseErrorMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, void>> loginWithGoogle() async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      await service.loginWithGoogle();
      return const Right(null);
    } catch (e) {
      return Left(FirebaseErrorMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      await service.resetPassword(email);
      return const Right(null);
    } catch (e) {
      return Left(FirebaseErrorMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      await service.logout();
      return const Right(null);
    } catch (e) {
      return Left(FirebaseErrorMapper.map(e));
    }
  }
}
