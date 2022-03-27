import 'package:flutter/material.dart';
import 'package:myexpenses/services/cloud/cloud_account.dart';
import 'package:myexpenses/utilities/show_delete_dialog.dart';

typedef AccountCallback = void Function(CloudAccount account);

class AccountsListView extends StatelessWidget {
  final Iterable<CloudAccount> accounts;
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
            account.income
                ? account.amount.toStringAsFixed(2) + ' PLN'
                : '-' + account.amount.toStringAsFixed(2) + ' PLN',
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style:
                TextStyle(color: (account.income) ? Colors.green : Colors.red),
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
