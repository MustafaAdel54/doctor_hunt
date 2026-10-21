import 'package:dartz/dartz.dart';
import 'package:doctor_hunt/core/error/failures.dart';

abstract interface class FavoritesRepo {
  Future<Either<Failure, List<String>>> getFavoriteDoctorIds();
  Future<Either<Failure, void>> addFavorite(String doctorId);
  Future<Either<Failure, void>> removeFavorite(String doctorId);
}
