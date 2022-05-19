import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:myexpenses/constants/routes.dart';
import 'package:myexpenses/enums/sort_method.dart';
import 'package:myexpenses/services/cloud/account/account.dart';
import 'package:myexpenses/utilities/formats/money_formats.dart';
import 'package:myexpenses/services/cloud/operation/operation.dart';
import 'package:myexpenses/utilities/preference_groups/list_preferences.dart';
import 'package:myexpenses/views/expenses/expense_card.dart';
import 'package:myexpenses/views/homepage/homepage_top_cards.dart';

class SummaryListView extends StatelessWidget {
  final Iterable<Operation> operations;
  final Iterable<Account> accounts;
  final ListPreferences preferences;

  const SummaryListView({
    Key? key,
    required this.accounts,
    required this.operations,
    required this.preferences,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<double> summary = getFinancialSummary();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            HomePageTopCards(
              balance: summary[0],
              income: summary[1],
              expense: summary[2],
            ),
            summaryPreferences(context),
            Expanded(child: getExpensesListView(context)),
          ],
        ),
      ),
    );
  }

  String getSelectedAccountsNames() {
    List<String> names = List.empty(growable: true);
    List<Account> selectedAccounts = accounts.toList();
    for (var item in selectedAccounts) {
      if (preferences.filteredAccountIds.contains(item.documentId)) {
        names.add(item.name);
      }
    }

    if (names.isEmpty) {
      return '';
    }

    if (names.length == accounts.length) {
      return 'All accounts/ ';
    }

    String result = '';
    for (String name in names) {
      result += name + ', ';
    }
    return result.substring(0, result.length - 2) + '/ ';
  }

  Widget summaryPreferences(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 14, 0, 10),
      child: Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.transparent,
        ),
        child: Text(
          getSelectedAccountsNames() +
              DateFormat('yMMMM').format(preferences.preferedMonth),
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget getExpensesListView(BuildContext context) {
    final operationList = operations.toList();
    return (operationList.isEmpty)
        ? noOperationsWidget(context)
        : (preferences.sortMethod == SortMethod.newest ||
                preferences.sortMethod == SortMethod.oldest)
            ? groupedOperationsList(operationList)
            : sortByCostOperations(operationList);
  }

  SizedBox noOperationsWidget(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Center(
        child: Text(
          _noOperationMessage,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontStyle: FontStyle.normal,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  GroupedListView<dynamic, String> groupedOperationsList(
      List<Operation> operationList) {
    return GroupedListView<dynamic, String>(
      padding: const EdgeInsets.only(bottom: 100),
      elements: operationList,
      groupBy: (element) => DateFormat('dd-MM-yyyy').format(element.date),
      groupSeparatorBuilder: (String groupByValue) {
        double sum = calculateGroupedOperationsSum(operationList, groupByValue);
        return groupedOperationsLabel(groupByValue, sum);
      },
      itemComparator: (item1, item2) {
        return (item1.date).compareTo(item2.date);
      },
      order: (preferences.sortMethod == SortMethod.newest)
          ? GroupedListOrder.DESC
          : GroupedListOrder.ASC,
      itemBuilder: (context, dynamic element) {
        return getExpenseCard(element, context);
      },
    );
  }

  Widget sortByCostOperations(List<Operation> operationList) {
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 100),
      separatorBuilder: (context, index) => const SizedBox(height: 1),
      itemCount: operationList.length,
      itemBuilder: (context, index) {
        final expense = operationList.elementAt(index);
        return getExpenseCard(expense, context);
      },
    );
  }

  double calculateGroupedOperationsSum(
      List<Operation> operationList, String groupByValue) {
    double sum = 0;
    for (var element in operationList) {
      if ((DateFormat('dd-MM-yyyy').format(element.date) == groupByValue)) {
        (element.category!.isIncome)
            ? sum += element.cost
            : sum -= element.cost;
      }
    }
    return sum;
  }

  Widget groupedOperationsLabel(String groupByValue, double sum) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 15, 10, 5),
      child: Row(
        children: [
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  DateFormat('MMMMEEEEd')
                      .format(DateFormat('dd-MM-yyyy').parse(groupByValue)),
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Text(
                  moneyFormat(sum),
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  List<double> getFinancialSummary() {
    // summary = [balance, incomes, expenses]
    List<double> summary = List.filled(3, 0, growable: false);
    for (final operation in operations) {
      operation.category!.isIncome
          ? summary[1] += operation.cost
          : summary[2] += operation.cost;
    }
    summary[0] = summary[1] - summary[2];
    return summary;
  }

  ExpenseCard getExpenseCard(element, BuildContext context) {
    return ExpenseCard(
      expense: element,
      onTap: (expense) {
        Navigator.of(context).pushNamed(
          createOrUpdateExpenseRoute,
          arguments: expense,
        );
      },
    );
  }

  final String _noOperationMessage =
      'There are no expenses here. Try changing the time span or accounts to find them.';
}
