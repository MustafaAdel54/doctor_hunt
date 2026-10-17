import 'package:doctor_hunt/core/constants/supabase_constants.dart';
import 'package:doctor_hunt/core/error/exceptions.dart';
import 'package:doctor_hunt/features/auth/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  const ProfileService({required this.supabase});

  final SupabaseClient supabase;

  Future<UserModel> createProfile({
    required String role,
    required String? name,
    required String? phone,
    required String? photoUrl,
  }) async {
    await supabase.rpc(SbC.createProfile, params: {
      'p_role': role,
      'p_name': name,
      'p_phone': phone,
      'p_photo_url': photoUrl,
    });
    
    // Fetch the newly created profile to return
    final user = supabase.auth.currentUser;
    if (user == null) throw const ServerException('No active session');
    return getProfile(user.id);
  }

  Future<UserModel> getProfile(String uid) async {
    final doc = await supabase
        .from(SbC.profiles)
        .select()
        .eq('id', uid)
        .maybeSingle();
        
    if (doc == null) throw const ServerException('Profile not found');

    return UserModel.fromJson(doc);
  }

  Future<void> updateProfile(UserModel user) async {
    await supabase
        .from(SbC.profiles)
        .update({
          'name': user.name,
          'phone': user.phone,
          'photo_url': user.photoUrl,
        })
        .eq('id', user.uid);
  }

  Future<void> deactivateAccount() async {
    await supabase.rpc(SbC.deactivateAccount);
  }
}
