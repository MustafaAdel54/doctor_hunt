import 'package:dartz/dartz.dart';
import 'package:doctor_hunt/core/error/failures.dart';
import 'package:doctor_hunt/features/reviews/models/review_model.dart';

abstract interface class ReviewRepo {
  Future<Either<Failure, List<ReviewModel>>> getDoctorReviews(String doctorId);
  Future<Either<Failure, ReviewModel>> addReview(ReviewModel review);
}
