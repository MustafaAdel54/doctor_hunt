import 'package:intl/intl.dart';

abstract final class AppDateUtils {
  static String formatMonthYear(DateTime date) {
    return DateFormat.yMMMM().format(date);
  }

  static List<DateTime> getDaysInMonth(DateTime date) {
    final firstDay = DateTime(date.year, date.month, 1);
    final lastDay = DateTime(date.year, date.month + 1, 0);

    return List.generate(
      lastDay.day,
      (index) => firstDay.add(Duration(days: index)),
    );
  }
}
