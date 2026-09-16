class ServerException implements Exception {
  const ServerException([this.message]);
  final String? message;
}

class NetworkException implements Exception {
  const NetworkException();
}

class SlotTakenException implements Exception {
  const SlotTakenException();
}
