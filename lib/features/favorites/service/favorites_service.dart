import 'package:doctor_hunt/core/constants/supabase_constants.dart';
import 'package:doctor_hunt/core/error/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FavoritesService {
  const FavoritesService({required this.supabase});

  final SupabaseClient supabase;

  String? get _currentUserId => supabase.auth.currentUser?.id;

  Future<List<String>> getFavoriteDoctorIds() async {
    final userId = _currentUserId;
    if (userId == null) return [];

    final response = await supabase
        .from(SbC.favorites)
        .select('doctor_id')
        .eq('user_id', userId);

    return (response as List<dynamic>)
        .map((row) => (row['doctor_id'] as String))
        .toList();
  }

  Future<void> addFavorite(String doctorId) async {
    final userId = _currentUserId;
    if (userId == null) throw const ServerException('User not authenticated');

    await supabase.from(SbC.favorites).upsert({
      'user_id': userId,
      'doctor_id': doctorId,
    });
  }

  Future<void> removeFavorite(String doctorId) async {
    final userId = _currentUserId;
    if (userId == null) throw const ServerException('User not authenticated');

    await supabase
        .from(SbC.favorites)
        .delete()
        .eq('user_id', userId)
        .eq('doctor_id', doctorId);
  }
}
