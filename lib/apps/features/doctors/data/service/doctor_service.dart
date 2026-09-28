import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/supabase_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/doctor_model.dart';

class DoctorService {
  const DoctorService({required this.firestore});

  final FirebaseFirestore firestore;

  Future<List<DoctorModel>> getDoctors({
    int limit = 20,
    String? specialization,
  }) async {
    Query query = firestore.collection(SbC.doctors);

    if (specialization != null) {
      query = query.where('specialization', isEqualTo: specialization);
    }

    final snap = await query.limit(limit).get();

    return snap.docs
        .map((doc) => DoctorModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<DoctorModel>> searchDoctors(String query) async {
    // For v1 Spark plan without Algolia/Elasticsearch, we'll do a simple
    // prefix search or just fetch all and filter in memory if the dataset is small.
    // For demo purposes, we do a basic prefix on a specific field or just
    // fetch a limited set.
    final snap = await firestore
        .collection(SbC.doctors)
        .where('specialization', isGreaterThanOrEqualTo: query)
        .where('specialization', isLessThanOrEqualTo: '$query\uf8ff')
        .limit(20)
        .get();

    return snap.docs
        .map((doc) => DoctorModel.fromJson(doc.data()))
        .toList();
  }

  Future<DoctorModel> getDoctorById(String doctorId) async {
    final doc = await firestore.collection(SbC.doctors).doc(doctorId).get();
    if (!doc.exists) throw const ServerException('Doctor not found');

    return DoctorModel.fromJson(doc.data()!);
  }
}
