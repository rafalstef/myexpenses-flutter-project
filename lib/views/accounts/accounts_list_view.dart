// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:myexpenses/services/cloud/account/account.dart';
import 'package:myexpenses/utilities/show_delete_dialog.dart';
import 'package:money_formatter/money_formatter.dart';
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
      //body:
      body: Column(
        children: <Widget>[
          Container(
            height: 40.0,
            child: Row(
              children: <Widget>[
                Container(
                    padding: const EdgeInsets.all(4.0),
                    margin: const EdgeInsets.only(left: 57),
                    width: 100.0,
                    child: const Text(
                      "Account",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    )),
                Container(
                    padding: const EdgeInsets.all(4.0),
                    margin: const EdgeInsets.only(left: 100),
                    width: 100.0,
                    child: const Text(
                      "Balance",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    )),
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
                  child: Container(
                      color: Colors.white,
                      child: ListTile(
                        title: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                    padding: const EdgeInsets.only(
                                        top: 5, bottom: 5),
                                    margin: const EdgeInsets.only(left: 45),
                                    width: 100.0,
                                    child: Text(
                                      account.name,
                                      style: subtitleStyle,
                                    )),
                                Container(
                                  padding: null,
                                  margin: const EdgeInsets.only(left: 100),
                                  width: 100.0,
                                  child: Text(
                                    MoneyFormatter(
                                                amount: account.amount,
                                                settings: MoneyFormatterSettings(
                                                  thousandSeparator: ' ',
                                                  decimalSeparator: '.',
                                                ))
                                            .fastCalc(
                                                type: FastCalcType.addition,
                                                amount: account.amount)
                                            .fastCalc(
                                                type: FastCalcType.substraction,
                                                amount: account.amount)
                                            .output
                                            .nonSymbol +
                                        ' PLN',
                                    maxLines: 1,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    style: subtitleStyle,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(
                              color: Colors.black38,
                            )
                          ],
                        ),
                      )),
                  actions: <Widget>[
                    IconSlideAction(
                      caption: 'Delete',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () async {
                        final shouldDelete = await showDeleteDialog(context);
                        if (shouldDelete) {
                          onDeleteAccount(account);
                        }
                      },
                    ),
                  ],
                  secondaryActions: <Widget>[
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
            //------------------
          ),
        ],
      ),
    );
  }
}

void doNothing(BuildContext context) {
  const Text('Co tu ma być');
}
