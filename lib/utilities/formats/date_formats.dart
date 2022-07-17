import 'package:intl/intl.dart';

class AppDateFormat {
  const AppDateFormat._();

  static DateTime get _now => DateTime.now();

  static DateTime get today => DateTime(_now.year, _now.month, _now.day);

  static DateTime get yesterday => today.subtract(const Duration(days: 1));

  static DateTime get currentMonthFirstDay =>
      DateTime(_now.year, _now.month, 1);

  static DateTime get currentMonthLastDay =>
      DateTime(_now.year, _now.month + 1, 0);

  static String yearMonthDayDash(DateTime date) =>
      DateFormat('yyyy-MM-dd').format(date).toString();

  static String dayMonthYearDot(DateTime date) =>
      DateFormat('dd.MM.yyyy').format(date).toString();

  static String dayMonthYearDash(DateTime date) =>
      DateFormat('dd-MM-yyyy').format(date).toString();

  static String yearMonthWeekdayDay(DateTime date) =>
      DateFormat('yMMMMEEEEd').format(date).toString();

  static String weekdayMonthDay(DateTime date) =>
      DateFormat('MMMMEEEEd').format(date).toString();

  static String numMonthDay(DateTime date) =>
      DateFormat('MMMd').format(date).toString();

  static String numYear(DateTime date) =>
      DateFormat('yyyy').format(date).toString();

  static DateTime toDate(String string) => DateTime.parse(string);

  static DateTime lastDayOfMonth(DateTime date) =>
      DateTime(date.year, date.month + 1, 0);

  static String monthName(DateTime date) => DateFormat("MMMM").format(date);
}
