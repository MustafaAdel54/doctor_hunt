import 'package:doctor_hunt/i18n/strings.g.dart';

String getErrorMessage(String code) {
  switch (code) {
    case 'network':
      return t.errors.network;
    case 'server':
      return t.errors.server;
    case 'invalid_credentials':
      return t.errors.auth.invalidCredential;
    case 'user_already_exists':
    case 'email_already_in_use':
      return t.errors.auth.emailAlreadyInUse;
    case 'weak_password':
      return t.errors.auth.weakPassword;
    case 'user_disabled':
      return t.errors.auth.userDisabled;
    case 'too_many_requests':
    case 'over_email_send_rate_limit':
      return t.errors.auth.tooManyRequests;
    case 'email_not_verified':
      return t.errors.auth.emailNotVerified;
    default:
      return t.errors.auth.unknown;
  }
}
