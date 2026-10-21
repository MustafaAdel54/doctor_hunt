import 'package:doctor_hunt/core/error/failures.dart';
import 'package:doctor_hunt/shared/utils/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract final class SupabaseErrorMapper {
  static Failure map(Object e) {
    if (e is AuthException) {
      Log.e('AuthException: ${e.message} (code: ${e.code})', e);
      String code = 'unknown';
      final msg = e.message.toLowerCase();
      final errCode = (e.code ?? '').toLowerCase();
      if (msg.contains('cancelled') || msg.contains('canceled')) {
        code = 'cancelled';
      } else if (msg.contains('invalid login credentials')) {
        code = 'invalid-credential';
      } else if (errCode.contains('otp') ||
          errCode.contains('token') ||
          errCode.contains('expired') ||
          msg.contains('token') ||
          msg.contains('otp') ||
          msg.contains('expired') ||
          msg.contains('verification code')) {
        code = 'invalid-otp';
      } else if (msg.contains('user already registered')) {
        code = 'email-already-in-use';
      } else if (msg.contains('disabled')) {
        code = 'user-disabled';
      } else if (msg.contains('weak')) {
        code = 'weak-password';
      } else if (errCode.contains('rate_limit') ||
          msg.contains('rate limit') ||
          msg.contains('too many requests')) {
        code = 'too-many-requests';
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
