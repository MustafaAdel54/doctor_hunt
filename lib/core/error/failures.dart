import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  const Failure();

  @override
  List<Object?> get props => [];
}

class ServerFailure extends Failure {
  const ServerFailure();
}

class NetworkFailure extends Failure {
  const NetworkFailure();
}

class SlotTakenFailure extends Failure {
  const SlotTakenFailure();
}

class AuthFailure extends Failure {
  const AuthFailure({required this.code});

  final String code;

  @override
  List<Object?> get props => [code];
}
