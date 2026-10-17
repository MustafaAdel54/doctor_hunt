import 'package:doctor_hunt/shared/i18n/strings.g.dart';

String getErrorMessage(String code) {
  switch (code) {
    case 'cancelled':
      return '';
    case 'network':
      return t.errors.network;
    case 'server':
      return t.errors.server;
    case 'invalid_credentials':
    case 'invalid_credential':
    case 'invalid-credential':
      return t.errors.auth.invalidCredential;
    case 'user_already_exists':
    case 'email_already_in_use':
    case 'email-already-in-use':
      return t.errors.auth.emailAlreadyInUse;
    case 'weak_password':
    case 'weak-password':
      return t.errors.auth.weakPassword;
    case 'user_disabled':
    case 'user-disabled':
      return t.errors.auth.userDisabled;
    case 'too_many_requests':
    case 'too-many-requests':
    case 'over_email_send_rate_limit':
      return t.errors.auth.tooManyRequests;
    case 'email_not_verified':
    case 'email-not-verified':
      return t.errors.auth.emailNotVerified;
    case 'account-already-setup':
    case 'account_already_setup':
      return t.errors.accountAlreadySetup;
    default:
      return t.errors.auth.unknown;
  }
}
