import 'package:supabase_flutter/supabase_flutter.dart';
import '../error/failures.dart';
import '../utils/logger.dart';

abstract final class SupabaseErrorMapper {
  static Failure map(Object e) {
    if (e is AuthException) {
      Log.e('AuthException: ${e.message}', e);
      return AuthFailure(code: e.message); // Note: using message as code for mapping
    }
    
    if (e is PostgrestException) {
      Log.e('PostgrestException: ${e.message}', e);
      return const ServerFailure();
    }

    Log.e('ServerException: $e', e);
    return const ServerFailure();
  }
}
