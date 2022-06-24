import 'package:flutter/material.dart';
import 'package:myexpenses/enums/sort_method.dart';
import 'package:myexpenses/services/cloud/account/account.dart';
import 'package:myexpenses/utilities/UI_components/bars/financial_report_bar.dart';
import 'package:myexpenses/services/cloud/operation/operation.dart';
import 'package:myexpenses/utilities/UI_components/no_operations_widget.dart/no_operation_widget.dart';
import 'package:myexpenses/utilities/UI_components/operations_lists/grouped_operations.dart';
import 'package:myexpenses/utilities/UI_components/operations_lists/sorted_operations.dart';
import 'package:myexpenses/utilities/preference_groups/list_preferences.dart';

class AllTransactionsWidgets extends StatelessWidget {
  final Iterable<Operation> operations;
  final Iterable<Account> accounts;
  final ListPreferences preferences;

  const AllTransactionsWidgets({
    Key? key,
    required this.accounts,
    required this.operations,
    required this.preferences,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: <Widget>[
          const FinancialReportBar(),
          _getExpensesListView(context),
        ],
      ),
    );
  }

  Widget _getExpensesListView(BuildContext context) {
    final List<Operation> operationList = operations.toList();
    return (operationList.isEmpty)
        ? const NoOperations()
        : (preferences.sortMethod == SortMethod.newest ||
                preferences.sortMethod == SortMethod.oldest)
            ? GroupedOperations(
                operations: operationList, sortMethod: preferences.sortMethod)
            : SortedOperations(operations: operationList);
  }
}
