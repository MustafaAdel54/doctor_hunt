import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/supabase_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/review_model.dart';

class ReviewService {
  const ReviewService({required this.supabase});

  final SupabaseClient supabase;

  Future<List<ReviewModel>> getDoctorReviews(String doctorId) async {
    final data = await supabase
        .from(SbC.reviews)
        .select()
        .eq('doctor_id', doctorId)
        .order('created_at', ascending: false);

    return data.map((doc) => ReviewModel.fromJson(doc)).toList();
  }

  Future<ReviewModel> addReview(ReviewModel review) async {
    try {
      final result = await supabase.rpc(
        'add_review',
        params: {
          'p_appointment_id': review.appointmentId,
          'p_rating': review.rating,
          'p_comment': review.comment,
        },
      );

      return ReviewModel.fromJson(result as Map<String, dynamic>);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
