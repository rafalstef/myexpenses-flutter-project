import 'package:intl/intl.dart';

DateTime get now => DateTime.now();

String yearMonthDayDash(DateTime date) =>
    DateFormat('yyyy-MM-dd').format(date).toString();

String dayMonthYearDot(DateTime date) =>
    DateFormat('dd.MM.yyyy').format(date).toString();

String dayMonthYearDash(DateTime date) =>
    DateFormat('dd-MM-yyyy').format(date).toString();

String yearMonthWeekdayDay(DateTime date) =>
    DateFormat('yMMMMEEEEd').format(date).toString();

String weekdayMonthDay(DateTime date) =>
    DateFormat('MMMMEEEEd').format(date).toString();

String numMonthDay(DateTime date) => DateFormat('MMMd').format(date).toString();

String numYear(DateTime date) => DateFormat('yyyy').format(date).toString();

DateTime get currentMonthFirstDay => DateTime(now.year, now.month, 1);

DateTime get currentMonthLastDay => DateTime(now.year, now.month + 1, 0);

DateTime toDate(String string) => DateTime.parse(string);

DateTime lastDayOfMonth(DateTime date) =>
    DateTime(date.year, date.month + 1, 0);

String monthName(DateTime date) => DateFormat("MMMM").format(date);
