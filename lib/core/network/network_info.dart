import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

typedef NetworkLookupFunction = Future<List<dynamic>> Function(String host);

class NetworkInfoImpl implements NetworkInfo {
  const NetworkInfoImpl({
    this.lookupHost = 'google.com',
    this.lookup,
  });

  final String lookupHost;
  final NetworkLookupFunction? lookup;

  @override
  Future<bool> get isConnected async {
    if (kIsWeb) return true;
    try {
      if (lookup != null) {
        final result = await lookup!(lookupHost);
        return result.isNotEmpty;
      }
      final result = await InternetAddress.lookup(lookupHost)
          .timeout(const Duration(seconds: 2));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } on TimeoutException catch (_) {
      return false;
    } catch (_) {
      return false;
    }
  }
}
