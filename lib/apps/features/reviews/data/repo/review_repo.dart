import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../models/review_model.dart';

abstract interface class ReviewRepo {
  Future<Either<Failure, List<ReviewModel>>> getDoctorReviews(String doctorId);
  Future<Either<Failure, ReviewModel>> addReview(ReviewModel review);
}
