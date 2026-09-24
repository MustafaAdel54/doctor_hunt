import 'package:equatable/equatable.dart';

enum SessionStatus {
  initial,
  unauthenticated,
  authenticatedWithoutProfile,
  authenticated,
  authenticatedInactive,
}

class SessionState extends Equatable {
  const SessionState({required this.status, this.userId, this.role});

  const SessionState.initial()
    : status = SessionStatus.initial,
      userId = null,
      role = null;

  const SessionState.unauthenticated()
    : status = SessionStatus.unauthenticated,
      userId = null,
      role = null;

  /// Supabase user exists but no PostgreSQL application profile yet.
  const SessionState.authenticatedWithoutProfile({required String userId})
    : status = SessionStatus.authenticatedWithoutProfile,
      userId = userId,
      role = null;

  const SessionState.authenticated({required this.userId, required this.role})
    : status = SessionStatus.authenticated;

  const SessionState.authenticatedInactive({required String userId})
    : status = SessionStatus.authenticatedInactive,
      userId = userId,
      role = null;

  final SessionStatus status;
  final String? userId;
  final String? role;

  @override
  List<Object?> get props => [status, userId, role];
}
