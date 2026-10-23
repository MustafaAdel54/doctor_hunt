import 'dart:async';
import 'dart:io';

import 'package:doctor_hunt/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NetworkInfoImpl', () {
    test('returns true when lookup succeeds with results', () async {
      final networkInfo = NetworkInfoImpl(
        lookup: (_) async => ['1.2.3.4'],
      );

      final isConnected = await networkInfo.isConnected;
      expect(isConnected, isTrue);
    });

    test('returns false when lookup returns empty list', () async {
      final networkInfo = NetworkInfoImpl(
        lookup: (_) async => [],
      );

      final isConnected = await networkInfo.isConnected;
      expect(isConnected, isFalse);
    });

    test('returns false when lookup throws SocketException', () async {
      final networkInfo = NetworkInfoImpl(
        lookup: (_) async => throw const SocketException('No address associated with hostname'),
      );

      final isConnected = await networkInfo.isConnected;
      expect(isConnected, isFalse);
    });

    test('returns false when lookup throws TimeoutException', () async {
      final networkInfo = NetworkInfoImpl(
        lookup: (_) async => throw TimeoutException('Connection timed out'),
      );

      final isConnected = await networkInfo.isConnected;
      expect(isConnected, isFalse);
    });

    test('returns false when lookup throws generic exception', () async {
      final networkInfo = NetworkInfoImpl(
        lookup: (_) async => throw Exception('Unknown network error'),
      );

      final isConnected = await networkInfo.isConnected;
      expect(isConnected, isFalse);
    });
  });
}
