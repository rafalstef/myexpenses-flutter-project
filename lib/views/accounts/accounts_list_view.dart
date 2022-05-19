import 'package:flutter/material.dart';
import 'package:myexpenses/services/cloud/account/account.dart';
import 'package:myexpenses/utilities/dialogs/show_delete_dialog.dart';
import 'package:myexpenses/utilities/formats/money_formats.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Total balance: ' + moneyFormat(_loopResult()),
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        elevation: 0.0,
        backgroundColor: const Color(0xFF273A48),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 40.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const <Widget>[
                Text(
                  "Account",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                Text(
                  "Balance",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ],
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF273A48),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                final account = accounts.elementAt(index);
                return Slidable(
                  actionPane: const SlidableDrawerActionPane(),
                  actionExtentRatio: 0.45,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 56),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          account.name,
                          style: subtitleStyle,
                        ),
                        Text(
                          moneyFormat(account.amount),
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: subtitleStyle,
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    IconSlideAction(
                      caption: 'Delete',
                      color: Colors.red,
                      icon: Icons.delete,
                      closeOnTap: false,
                      onTap: () async {
                        final shouldDelete = await showDeleteDialog(context);
                        if (shouldDelete) {
                          onDeleteAccount(account);
                        }
                      },
                    ),
                    IconSlideAction(
                      caption: 'Edit',
                      color: Colors.green,
                      icon: Icons.edit,
                      onTap: () {
                        onTap(account);
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  double _loopResult() {
    double sumup = 0;
    for (int i = 0; i < accounts.length; i++) {
      final account = accounts.elementAt(i);
      if (account.includeInBalance) {
        sumup = sumup + account.amount;
      }
    }
    return sumup;
  }
}
