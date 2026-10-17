import 'package:dartz/dartz.dart';
import 'package:doctor_hunt/core/error/failures.dart';
import 'package:doctor_hunt/core/network/network_info.dart';
import 'package:doctor_hunt/core/network/supabase_error_mapper.dart';
import 'package:doctor_hunt/features/reviews/models/review_model.dart';
import 'package:doctor_hunt/features/reviews/service/review_service.dart';

import 'review_repo.dart';

class ReviewRepoImpl implements ReviewRepo {
  const ReviewRepoImpl({required this.service, required this.networkInfo});

  final ReviewService service;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, List<ReviewModel>>> getDoctorReviews(
    String doctorId,
  ) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      final reviews = await service.getDoctorReviews(doctorId);
      return Right(reviews);
    } catch (e) {
      return Left(SupabaseErrorMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, ReviewModel>> addReview(ReviewModel review) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      final added = await service.addReview(review);
      return Right(added);
    } catch (e) {
      return Left(SupabaseErrorMapper.map(e));
    }
  }
}
