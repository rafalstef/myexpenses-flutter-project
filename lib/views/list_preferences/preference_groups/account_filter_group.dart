import 'package:flutter/material.dart';
import 'package:myexpenses/services/cloud/account/account.dart';
import 'package:myexpenses/utilities/UI_components/preferences_sheet/list_filter.dart/filter_list_group.dart';
import 'package:myexpenses/utilities/UI_components/preferences_sheet/list_filter.dart/filter_list_option.dart';

class AccountFilterGroup extends StatelessWidget {
  final List<Account> accounts;
  final Iterable<String> selectedAccountsIds;
  final ValueChanged<List<String>> onOptionTap;

  const AccountFilterGroup({
    required this.accounts,
    required this.selectedAccountsIds,
    required this.onOptionTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FilterListGroup(
      title: 'Account',
      subtitle: 'Choose account',
      icon: Icons.wallet_rounded,
      options: accounts
          .map(
            (account) => FilterListOption(
              id: account.documentId,
              name: account.name,
            ),
          )
          .toList(),
      selectedOptions: selectedAccountsIds,
      onOptionTap: onOptionTap,
    );
  }
}
