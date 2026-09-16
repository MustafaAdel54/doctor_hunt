import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/firebase_error_mapper.dart';
import '../../../../core/network/network_info.dart';
import '../models/doctor_model.dart';
import 'doctor_repo.dart';
import '../service/doctor_service.dart';

class DoctorRepoImpl implements DoctorRepo {
  const DoctorRepoImpl({required this.service, required this.networkInfo});

  final DoctorService service;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, List<DoctorModel>>> getDoctors({
    int limit = 20,
    String? specialization,
  }) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      final doctors = await service.getDoctors(
        limit: limit,
        specialization: specialization,
      );
      return Right(doctors);
    } catch (e) {
      return Left(FirebaseErrorMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, List<DoctorModel>>> searchDoctors(String query) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      final doctors = await service.searchDoctors(query);
      return Right(doctors);
    } catch (e) {
      return Left(FirebaseErrorMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, DoctorModel>> getDoctorById(String doctorId) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      final doctor = await service.getDoctorById(doctorId);
      return Right(doctor);
    } catch (e) {
      return Left(FirebaseErrorMapper.map(e));
    }
  }
}
