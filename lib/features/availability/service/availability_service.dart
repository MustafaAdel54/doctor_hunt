import 'package:doctor_hunt/core/constants/supabase_constants.dart';
import 'package:doctor_hunt/features/availability/models/availability_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AvailabilityService {
  const AvailabilityService({required this.supabase});

  final SupabaseClient supabase;

  Future<AvailabilityModel> getDoctorAvailability(String doctorId) async {
    final doc = await supabase
        .from(SbC.availability)
        .select()
        .eq('doctor_id', doctorId)
        .maybeSingle();

    if (doc == null) {
      // Return a default empty schedule if none exists yet
      return AvailabilityModel(
        doctorId: doctorId,
        slotDurationMinutes: 30,
        days: [],
      );
    }

    return AvailabilityModel.fromJson(doc);
  }

  Future<void> updateDoctorAvailability(AvailabilityModel availability) async {
    await supabase
        .from(SbC.availability)
        .upsert(availability.toJson());
  }
}
