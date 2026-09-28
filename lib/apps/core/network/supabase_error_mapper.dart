import 'package:supabase_flutter/supabase_flutter.dart';
import '../error/failures.dart';
import '../utils/logger.dart';

abstract final class SupabaseErrorMapper {
  static Failure map(Object e) {
    if (e is AuthException) {
      Log.e('AuthException: ${e.message}', e);
      String code = 'unknown';
      final msg = e.message.toLowerCase();
      if (msg.contains('invalid login credentials')) {
        code = 'invalid-credential';
      } else if (msg.contains('user already registered')) {
        code = 'email-already-in-use';
      } else if (msg.contains('disabled')) {
        code = 'user-disabled';
      }
      return AuthFailure(code: code);
    }
    
    if (e is PostgrestException) {
      Log.e('PostgrestException: ${e.message}', e);
      if (e.code == '23505') {
        return const AuthFailure(code: 'account-already-setup');
      }
      return const ServerFailure();
    }

    Log.e('ServerException: $e', e);
    return const ServerFailure();
  }
}
