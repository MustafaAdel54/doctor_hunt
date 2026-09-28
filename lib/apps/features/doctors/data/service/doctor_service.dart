import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/supabase_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/doctor_model.dart';

class DoctorService {
  const DoctorService({required this.supabase});

  final SupabaseClient supabase;

  Future<List<DoctorModel>> getDoctors({
    int limit = 20,
    String? specialization,
  }) async {
    var query = supabase.from(SbC.doctors).select();

    if (specialization != null) {
      query = query.eq('specialization', specialization);
    }

    final data = await query.limit(limit);

    return data
        .map((doc) => DoctorModel.fromJson(doc))
        .toList();
  }

  Future<List<DoctorModel>> searchDoctors(String query) async {
    final data = await supabase
        .from(SbC.doctors)
        .select()
        .ilike('specialization', '%$query%')
        .limit(20);

    return data
        .map((doc) => DoctorModel.fromJson(doc))
        .toList();
  }

  Future<DoctorModel> getDoctorById(String doctorId) async {
    final doc = await supabase
        .from(SbC.doctors)
        .select()
        .eq('id', doctorId)
        .maybeSingle();
        
    if (doc == null) throw const ServerException('Doctor not found');

    return DoctorModel.fromJson(doc);
  }
}
