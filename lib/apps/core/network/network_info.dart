abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    // Basic implementation for v1.
    // In production, use connectivity_plus or internet_connection_checker.
    return true;
  }
}
