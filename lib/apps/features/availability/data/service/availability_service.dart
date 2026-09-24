import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/supabase_constants.dart';
import '../models/availability_model.dart';

class AvailabilityService {
  const AvailabilityService({required this.firestore});

  final FirebaseFirestore firestore;

  Future<AvailabilityModel> getDoctorAvailability(String doctorId) async {
    final doc = await firestore
        .collection(SbC.availability)
        .doc(doctorId)
        .get();
    if (!doc.exists) {
      // Return a default empty schedule if none exists yet
      return AvailabilityModel(
        doctorId: doctorId,
        slotDurationMinutes: 30,
        days: [],
      );
    }

    return AvailabilityModel.fromJson(doc.data()!);
  }

  Future<void> updateDoctorAvailability(AvailabilityModel availability) async {
    await firestore
        .collection(SbC.availability)
        .doc(availability.doctorId)
        .set(availability.toJson(), SetOptions(merge: true));
  }
}
