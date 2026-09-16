import 'package:firebase_auth/firebase_auth.dart';
import '../error/failures.dart';
import '../utils/logger.dart';

abstract final class FirebaseErrorMapper {
  static Failure map(Object e) {
    if (e is FirebaseAuthException) {
      Log.e('FirebaseAuthException: ${e.code}', e);
      return AuthFailure(code: e.code);
    }

    Log.e('ServerException: $e', e);
    return const ServerFailure();
  }
}
