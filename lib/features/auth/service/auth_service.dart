import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/constants/supabase_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

class AuthService {
  const AuthService({
    required this.supabase,
    required this.googleSignIn,
  });

  final SupabaseClient supabase;
  final GoogleSignIn googleSignIn;

  Future<UserModel> loginWithEmail(String email, String password) async {
    final response = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    final user = response.user;
    if (user == null) throw const AuthException('No user returned');

    final doc = await supabase
        .from(SbC.profiles)
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (doc == null) throw const ServerException('User profile not found');

    return UserModel.fromJson(doc);
  }

  Future<User> registerWithEmailOnly(
    String email,
    String password,
    String name,
  ) async {
    final response = await supabase.auth.signUp(
      email: email,
      password: password,
      data: {'name': name},
    );
    final user = response.user;
    if (user == null) throw const AuthException('No user returned');

    return user;
  }



  Future<User> loginWithGoogle() async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      throw const AuthException('Google sign in cancelled');
    }

    final googleAuth = await googleUser.authentication;
    final idToken = googleAuth.idToken;
    final accessToken = googleAuth.accessToken;
    
    if (idToken == null) {
      throw const AuthException('No ID Token found.');
    }

    final response = await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
    
    final user = response.user;
    if (user == null) {
      throw const AuthException('No Supabase user returned from Google credential');
    }

    // Google metadata is held for Phase 3 profile creation. 
    if (user.userMetadata == null || user.userMetadata!.isEmpty) {
      await supabase.auth.updateUser(
        UserAttributes(
          data: {
            'name': googleUser.displayName,
            'photoUrl': googleUser.photoUrl,
          },
        ),
      );
    }

    return user;
  }

  Future<void> resetPassword(String email) async {
    await supabase.auth.resetPasswordForEmail(email);
  }

  Future<void> logout() async {
    await Future.wait([
      supabase.auth.signOut(),
      if (await googleSignIn.isSignedIn()) googleSignIn.signOut(),
    ]);
  }
}
