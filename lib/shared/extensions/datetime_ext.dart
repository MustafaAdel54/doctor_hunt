import 'package:intl/intl.dart';

extension DateTimeExt on DateTime {
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  String toDateString() => DateFormat.yMMMd().format(this);

  String toTimeString() => DateFormat.jm().format(this);
}
