import 'package:flutter/material.dart';
import 'package:myexpenses/services/cloud/account/account.dart';
import 'package:myexpenses/utilities/preference_groups/filter_group.dart';

class AccountFilterGroup extends StatelessWidget {
  final ValueChanged<FilterOption> onOptionTap;
  final List<Account> accounts;
  final List<String> selectedItemsIds;

  const AccountFilterGroup({
    required this.accounts,
    required this.selectedItemsIds,
    required this.onOptionTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => FilterGroup(
        title: 'Choose accounts',
        onOptionTap: onOptionTap,
        options: accounts
            .map(
              (account) => FilterOption(
                id: account.documentId,
                name: account.name,
                isSelected: selectedItemsIds.contains(account.documentId),
              ),
            )
            .toList(),
      );
}
