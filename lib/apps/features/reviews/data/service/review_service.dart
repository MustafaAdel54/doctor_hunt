import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/supabase_constants.dart';
import '../models/review_model.dart';

class ReviewService {
  const ReviewService({required this.firestore});

  final FirebaseFirestore firestore;

  Future<List<ReviewModel>> getDoctorReviews(String doctorId) async {
    final snap = await firestore
        .collection(SbC.doctors)
        .doc(doctorId)
        .collection(SbC.reviews)
        .orderBy('createdAt', descending: true)
        .get();

    return snap.docs.map((doc) => ReviewModel.fromJson(doc.data())).toList();
  }

  Future<ReviewModel> addReview(ReviewModel review) async {
    final doctorRef = firestore.collection(SbC.doctors).doc(review.doctorId);
    final reviewRef = doctorRef.collection(SbC.reviews).doc();

    final finalReview = review.copyWith(id: reviewRef.id);

    await firestore.runTransaction((tx) async {
      final doc = await tx.get(doctorRef);
      if (!doc.exists) return; // or throw

      final data = doc.data()!;
      final currentSum = (data[SbC.ratingSum] as num?)?.toDouble() ?? 0.0;
      final currentCount = (data[SbC.ratingCount] as num?)?.toInt() ?? 0;

      tx.set(reviewRef, finalReview.toJson());
      tx.update(doctorRef, {
        SbC.ratingSum: currentSum + review.rating,
        SbC.ratingCount: currentCount + 1,
      });
    });

    return finalReview;
  }
}
