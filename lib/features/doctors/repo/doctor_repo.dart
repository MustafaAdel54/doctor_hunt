import 'package:dartz/dartz.dart';
import 'package:doctor_hunt/core/error/failures.dart';
import 'package:doctor_hunt/features/doctors/models/doctor_model.dart';

abstract interface class DoctorRepo {
  Future<Either<Failure, List<DoctorModel>>> getDoctors({
    int limit = 20,
    String? specialization,
  });
  Future<Either<Failure, List<DoctorModel>>> searchDoctors(String query);
  Future<Either<Failure, DoctorModel>> getDoctorById(String doctorId);
}
