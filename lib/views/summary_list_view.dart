import 'package:flutter/material.dart';
import 'package:myexpenses/services/cloud/account/account.dart';
import 'package:myexpenses/utilities/show_delete_dialog.dart';
import 'package:money_formatter/money_formatter.dart';

typedef AccountCallback = void Function(Account account);
double sumup = 0;

class SummaryListView extends StatelessWidget {
  final Iterable<Account> accounts;
  final AccountCallback onDeleteAccount;
  final AccountCallback onTap;

  const SummaryListView({
    Key? key,
    required this.accounts,
    required this.onDeleteAccount,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle subtitleStyle = const TextStyle(fontSize: 25.0);
    return Text(
      'TOTAL BALANCE: ' +
          MoneyFormatter(amount: _loopResult()!.toDouble())
              .fastCalc(
                  type: FastCalcType.addition,
                  amount: _loopResult()!.toDouble())
              .fastCalc(
                  type: FastCalcType.substraction,
                  amount: _loopResult()!.toDouble())
              .output
              .nonSymbol +
          ' PLN',
      style: subtitleStyle,
      maxLines: 1,
      softWrap: true,
      overflow: TextOverflow.ellipsis,
    );
  }

  double? _loopResult() {
    sumup = 0;
    for (int i = 0; i < accounts.length; i++) {
      final account = accounts.elementAt(i);
      sumup = sumup + account.amount;
    }
    return sumup;
  }
}
