import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firebase_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/appointment_model.dart';

class AppointmentService {
  const AppointmentService({required this.firestore});

  final FirebaseFirestore firestore;

  Future<List<AppointmentModel>> getPatientAppointments(
    String patientId,
  ) async {
    final snap = await firestore
        .collection(FbC.appointments)
        .where(FbC.patientId, isEqualTo: patientId)
        .orderBy(FbC.startTime, descending: true)
        .get();

    return snap.docs
        .map((doc) => AppointmentModel.fromJson(doc.data()))
        .toList();
  }

  Future<List<AppointmentModel>> getDoctorAppointments(String doctorId) async {
    final snap = await firestore
        .collection(FbC.appointments)
        .where(FbC.doctorId, isEqualTo: doctorId)
        .orderBy(FbC.startTime, descending: true)
        .get();

    return snap.docs
        .map((doc) => AppointmentModel.fromJson(doc.data()))
        .toList();
  }

  Future<AppointmentModel> bookAppointment(AppointmentModel appointment) async {
    final lockRef = firestore
        .collection(FbC.slotLocks)
        .doc(appointment.slotLockId);
    final apptRef = firestore.collection(FbC.appointments).doc();

    final finalAppointment = appointment.copyWith(id: apptRef.id);

    try {
      await firestore.runTransaction((tx) async {
        final lockDoc = await tx.get(lockRef);
        if (lockDoc.exists) {
          throw const SlotTakenException();
        }

        // Lock the slot
        tx.set(lockRef, {
          'appointmentId': apptRef.id,
          'patientId': appointment.patientId,
          'doctorId': appointment.doctorId,
          'startTime': appointment.startTime.toIso8601String(),
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Create the appointment
        tx.set(apptRef, finalAppointment.toJson());
      });

      return finalAppointment;
    } catch (e) {
      if (e is SlotTakenException) rethrow;
      throw ServerException(e.toString());
    }
  }

  Future<void> updateStatus(String appointmentId, String status) async {
    await firestore.collection(FbC.appointments).doc(appointmentId).update({
      FbC.status: status,
    });
  }
}
