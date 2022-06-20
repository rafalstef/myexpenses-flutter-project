import 'package:flutter/material.dart';
import 'package:myexpenses/services/cloud/account/account.dart';
import 'package:myexpenses/utilities/UI_components/icons_containers/icon_container.dart';
import 'package:myexpenses/utilities/formats/money_formats.dart';

typedef AccountCallback = void Function(Account account);

class AccountTile extends StatelessWidget {
  const AccountTile({
    Key? key,
    required this.account,
    required this.onTap,
  }) : super(key: key);

  final Account account;
  final AccountCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onTap(account),
      leading: const TileIcon(
        icon: Icons.account_balance_wallet,
        iconColor: Color(0xFF5233FF),
        containerColor: Color(0xFFF1F1FA),
      ),
      title: accountName(),
      trailing: accountAmount(),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
    );
  }

  Widget accountIcon() {
    return Container(
      height: 48,
      width: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: const Color(0xFFF1F1FA),
      ),
      child: const Icon(
        Icons.account_balance_wallet,
        color: Color(0xFF5233FF),
        size: 28.0,
      ),
    );
  }

  Text accountName() {
    return Text(
      account.name.toString(),
      style: TextStyle(
        color: Colors.grey[900],
        fontSize: 17,
        fontWeight: FontWeight.bold,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Text accountAmount() {
    return Text(
      moneyFormat(account.amount),
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.bold,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
