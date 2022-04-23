import 'package:money_formatter/money_formatter.dart';

String moneyFormat(double amount) {
  return MoneyFormatter(
    amount: amount,
    settings: MoneyFormatterSettings(
      thousandSeparator: ' ',
      decimalSeparator: '.',
      symbol: 'PLN',
    ),
  ).output.symbolOnRight;
}
