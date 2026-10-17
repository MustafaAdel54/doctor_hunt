import 'package:equatable/equatable.dart';

enum SessionStatus {
  initial,
  unauthenticated,
  authenticatedWithoutProfile,
  authenticated,
  authenticatedInactive,
  error,
}

class SessionState extends Equatable {
  const SessionState({required this.status, this.userId, this.role, this.errorMessage});

  const SessionState.initial()
    : status = SessionStatus.initial,
      userId = null,
      role = null,
      errorMessage = null;

  const SessionState.unauthenticated()
    : status = SessionStatus.unauthenticated,
      userId = null,
      role = null,
      errorMessage = null;

  const SessionState.error(String message)
    : status = SessionStatus.error,
      userId = null,
      role = null,
      errorMessage = message;

  /// Supabase user exists but no PostgreSQL application profile yet.
  const SessionState.authenticatedWithoutProfile({required String this.userId})
    : status = SessionStatus.authenticatedWithoutProfile,
      role = null,
      errorMessage = null;

  const SessionState.authenticated({required this.userId, required this.role})
    : status = SessionStatus.authenticated,
      errorMessage = null;

  const SessionState.authenticatedInactive({required String this.userId})
    : status = SessionStatus.authenticatedInactive,
      role = null,
      errorMessage = null;

  final SessionStatus status;
  final String? userId;
  final String? role;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, userId, role, errorMessage];
}
