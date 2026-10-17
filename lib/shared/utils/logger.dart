import 'dart:developer' as dev;

abstract final class Log {
  static void d(String message) {
    dev.log(message, name: 'DoctorHunt');
  }

  static void e(String message, [Object? error, StackTrace? stackTrace]) {
    dev.log(message, name: 'DoctorHunt', error: error, stackTrace: stackTrace);
  }
}
