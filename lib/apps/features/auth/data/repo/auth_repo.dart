import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../models/user_model.dart';

abstract interface class AuthRepo {
  Future<Either<Failure, UserModel>> loginWithEmail(
    String email,
    String password,
  );

  /// Creates a Supabase Auth account with email + password only.
  /// Does NOT create a database profile. After success the session
  /// transitions to [authenticatedWithoutProfile] → Role Selection.
  Future<Either<Failure, void>> registerWithEmailOnly(
    String email,
    String password,
    String name,
  );

  /// Creates the database application profile for any authenticated user.
  /// Called from Role Selection for both email-registered and Google users.
  Future<Either<Failure, UserModel>> createUserProfile({
    required String uid,
    required String email,
    required String role,
    String? name,
    String? photoUrl,
    String? phone,
    bool isVerified,
  });

  /// Performs Google OAuth + Supabase credential sign-in only.
  /// Does NOT create a database application profile.
  Future<Either<Failure, void>> loginWithGoogle();

  Future<Either<Failure, void>> resetPassword(String email);

  Future<Either<Failure, void>> logout();
}
