import 'package:flutter/material.dart';
import 'package:myexpenses/services/cloud/account/account.dart';
import 'package:myexpenses/utilities/UI_components/tiles/tile_icon.dart';
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
      leading: TileIcon(
        icon: account.icon,
        iconColor: account.color,
        containerColor: account.color.withOpacity(0.1),
      ),
      title: accountName(),
      trailing: accountAmount(),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
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
