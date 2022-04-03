import 'package:flutter/material.dart';
import 'package:myexpenses/services/cloud/account/account.dart';
import 'package:myexpenses/utilities/show_delete_dialog.dart';
import 'package:money_formatter/money_formatter.dart';

typedef AccountCallback = void Function(Account account);

class AccountsListView extends StatelessWidget {
  final Iterable<Account> accounts;
  final AccountCallback onDeleteAccount;
  final AccountCallback onTap;

  const AccountsListView({
    Key? key,
    required this.accounts,
    required this.onDeleteAccount,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle subtitleStyle = const TextStyle(fontSize: 15.0);

    return ListView.builder(
      itemCount: accounts.length,
      itemBuilder: (context, index) {
        final account = accounts.elementAt(index);
        return ListTile(
          onTap: () {
            onTap(account);
          },
          title: Text(
            account.name,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            MoneyFormatter(
                        amount: account.amount,
                        settings: MoneyFormatterSettings(
                          thousandSeparator: ' ',
                          decimalSeparator: '.',
                        ))
                    .fastCalc(
                        type: FastCalcType.addition, amount: account.amount)
                    .fastCalc(
                        type: FastCalcType.substraction, amount: account.amount)
                    .output
                    .nonSymbol +
                ' PLN',
            style: subtitleStyle,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            onPressed: () async {
              final shouldDelete = await showDeleteDialog(context);
              if (shouldDelete) {
                onDeleteAccount(account);
              }
            },
            icon: const Icon(Icons.delete),
          ),
        );
      },
    );
  }
}
