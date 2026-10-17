import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/supabase_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/appointment_model.dart';

class AppointmentService {
  const AppointmentService({required this.supabase});

  final SupabaseClient supabase;

  Future<List<AppointmentModel>> getPatientAppointments(
    String patientId,
  ) async {
    final data = await supabase
        .from(SbC.appointments)
        .select()
        .eq('patient_id', patientId)
        .order('start_time', ascending: false);

    return data
        .map((doc) => AppointmentModel.fromJson(doc))
        .toList();
  }

  Future<List<AppointmentModel>> getDoctorAppointments(String doctorId) async {
    final data = await supabase
        .from(SbC.appointments)
        .select()
        .eq('doctor_id', doctorId)
        .order('start_time', ascending: false);

    return data
        .map((doc) => AppointmentModel.fromJson(doc))
        .toList();
  }

  Future<AppointmentModel> bookAppointment(AppointmentModel appointment) async {
    try {
      final result = await supabase.rpc(
        'book_appointment',
        params: {
          'p_doctor_id': appointment.doctorId,
          'p_start_time': appointment.startTime.toIso8601String(),
          'p_notes': appointment.notes,
        },
      );

      return AppointmentModel.fromJson(result as Map<String, dynamic>);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<void> updateStatus(String appointmentId, String status) async {
    try {
      if (status == 'cancelled') {
        await supabase.rpc('cancel_appointment', params: {
          'p_appointment_id': appointmentId,
        });
      } else {
        await supabase.rpc('update_appointment_status', params: {
          'p_appointment_id': appointmentId,
          'p_new_status': status,
        });
      }
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
