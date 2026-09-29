import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../auth/data/models/user_model.dart';

abstract interface class ProfileRepo {
  Future<Either<Failure, UserModel>> createProfile({
    required String role,
    String? name,
    String? photoUrl,
    String? phone,
  });
  Future<Either<Failure, UserModel>> getProfile(String uid);
  Future<Either<Failure, void>> updateProfile(UserModel user);
  Future<Either<Failure, void>> updateActiveStatus(String uid, bool isActive);
}
