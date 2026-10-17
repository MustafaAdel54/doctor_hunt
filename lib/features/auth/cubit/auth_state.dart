sealed class AuthState {
  const AuthState();

  const factory AuthState.initial() = AuthInitial;
  const factory AuthState.loading() = AuthLoading;
  const factory AuthState.success() = AuthSuccess;
  const factory AuthState.error(String message) = AuthError;

  T? whenOrNull<T>({
    T? Function()? initial,
    T? Function()? loading,
    T? Function()? success,
    T? Function(String message)? error,
  }) {
    final state = this;
    if (state is AuthInitial && initial != null) return initial();
    if (state is AuthLoading && loading != null) return loading();
    if (state is AuthSuccess && success != null) return success();
    if (state is AuthError && error != null) return error(state.message);
    return null;
  }

  T maybeWhen<T>({
    T Function()? initial,
    T Function()? loading,
    T Function()? success,
    T Function(String message)? error,
    required T Function() orElse,
  }) {
    final state = this;
    if (state is AuthInitial && initial != null) return initial();
    if (state is AuthLoading && loading != null) return loading();
    if (state is AuthSuccess && success != null) return success();
    if (state is AuthError && error != null) return error(state.message);
    return orElse();
  }
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSuccess extends AuthState {
  const AuthSuccess();
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}
