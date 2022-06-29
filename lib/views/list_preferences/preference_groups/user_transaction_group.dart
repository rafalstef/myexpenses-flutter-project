import 'package:flutter/material.dart';
import 'package:myexpenses/enums/user_transaction_enum.dart';
// ignore: unused_import
import 'package:myexpenses/extensions/string_extensions.dart';
import 'package:myexpenses/utilities/UI_components/preferences_sheet/multiple_choice_filter/multiple_choice_filter_group.dart';
import 'package:myexpenses/utilities/UI_components/preferences_sheet/multiple_choice_filter/multiple_filter_option.dart';

class TransactionFilterGroup extends StatelessWidget {
  final List<UserTransaction> transactions;
  final List<UserTransaction> selectedItemsIds;
  final ValueChanged<MultipleFilterOption> onOptionTap;

  const TransactionFilterGroup({
    required this.transactions,
    required this.selectedItemsIds,
    required this.onOptionTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultipleChoiceFilterGroup(
      title: 'Filter by',
      icon: Icons.filter_list_rounded,
      onOptionTap: onOptionTap,
      options: transactions
          .map(
            (transaction) => MultipleFilterOption(
              id: transaction,
              name: transaction.name.capitalize(),
              isSelected: selectedItemsIds.contains(transaction),
            ),
          )
          .toList(),
    );
  }
}
