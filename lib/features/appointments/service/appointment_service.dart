import 'package:doctor_hunt/core/constants/supabase_constants.dart';
import 'package:doctor_hunt/core/error/exceptions.dart';
import 'package:doctor_hunt/features/appointments/models/appointment_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppointmentService {
  const AppointmentService({required this.supabase});

  final SupabaseClient supabase;

  Future<List<AppointmentModel>> getPatientAppointments(
    String patientId,
  ) async {
    try {
      final isUuid = RegExp(
        r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
      ).hasMatch(patientId);

      final rpcParams = <String, dynamic>{};
      if (isUuid) {
        rpcParams['p_patient_id'] = patientId;
      }

      final data = await supabase.rpc('get_my_appointments', params: rpcParams);
      if (data is List) {
        return data
            .map((doc) => AppointmentModel.fromJson(doc as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {
      // Fallback
    }

    final query = supabase.from(SbC.appointments).select();
    final isUuid = RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
    ).hasMatch(patientId);
    
    final data = isUuid
        ? await query.eq('patient_id', patientId).order('start_time', ascending: false)
        : await query.order('start_time', ascending: false);

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
          'p_start_time': appointment.startTime.toUtc().toIso8601String(),
          'p_notes': appointment.notes,
        },
      );

      return AppointmentModel.fromJson(result as Map<String, dynamic>);
    } on PostgrestException catch (e) {
      if (e.message.contains('already booked')) {
        throw const SlotTakenException();
      }
      throw ServerException(e.message);
    } catch (e) {
      if (e.toString().contains('already booked')) {
        throw const SlotTakenException();
      }
      throw ServerException(e.toString());
    }
  }

  Future<List<DateTime>> getBookedSlots(String doctorId, DateTime date) async {
    try {
      final dateStr =
          "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      final result = await supabase.rpc(
        'get_doctor_booked_slots',
        params: {
          'p_doctor_id': doctorId,
          'p_date': dateStr,
        },
      );

      if (result is List) {
        return result.map((row) {
          final startTime = (row as Map<String, dynamic>)['start_time'] as String;
          return DateTime.parse(startTime).toUtc();
        }).toList();
      }
      return [];
    } catch (_) {
      return [];
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
