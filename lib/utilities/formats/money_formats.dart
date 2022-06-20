import 'package:intl/intl.dart';

String moneyFormat(double amount) {
  NumberFormat f = NumberFormat("\$#,##0.00", "en_US");
  return f.format(amount);
}
