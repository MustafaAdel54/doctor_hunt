import 'package:doctor_hunt/shared/i18n/strings.g.dart';

String getErrorMessage(String code) {
  final normalized = code.replaceAll('_', '-').toLowerCase();
  return switch (normalized) {
    'cancelled' => '',
    'network' => t.errors.network,
    'server' => t.errors.server,
    'invalid-credential' || 'invalid-credentials' => t.errors.auth.invalidCredential,
    'invalid-otp' || 'otp-expired' => t.errors.auth.invalidOtp,
    'email-already-in-use' || 'user-already-exists' => t.errors.auth.emailAlreadyInUse,
    'weak-password' => t.errors.auth.weakPassword,
    'user-disabled' => t.errors.auth.userDisabled,
    'too-many-requests' => t.errors.auth.tooManyRequests,
    'email-not-verified' => t.errors.auth.emailNotVerified,
    'account-already-setup' => t.errors.accountAlreadySetup,
    _ => t.errors.auth.unknown,
  };
}
