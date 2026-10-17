import 'package:dartz/dartz.dart';
import 'package:doctor_hunt/core/error/failures.dart';
import 'package:doctor_hunt/features/auth/models/user_model.dart';

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



  /// Performs Google OAuth + Supabase credential sign-in only.
  /// Does NOT create a database application profile.
  Future<Either<Failure, void>> loginWithGoogle();

  Future<Either<Failure, void>> resetPassword(String email);

  Future<Either<Failure, void>> logout();
}
