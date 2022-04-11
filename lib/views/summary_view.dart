import 'package:flutter/material.dart';
import 'package:myexpenses/constants/routes.dart';
import 'package:myexpenses/services/cloud/expense/expense.dart';
import 'package:myexpenses/services/cloud/expense/firebase_expense.dart';
import 'package:myexpenses/views/navBar.dart';
import '../../services/auth/auth_service.dart';
import 'package:myexpenses/services/cloud/account/firebase_account.dart';
import 'package:myexpenses/views/summary_list_view.dart';
import '../services/cloud/account/account.dart';

class SummaryView extends StatefulWidget {
  const SummaryView({Key? key}) : super(key: key);

  @override
  State<SummaryView> createState() => _SummaryViewState();
}

class _SummaryViewState extends State<SummaryView> {
  late final FirebaseExpense _expenseService;
  late final FirebaseAccount _accountService;

  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _expenseService = FirebaseExpense();
    _accountService = FirebaseAccount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Summary'),
      ),
      drawer: const SideDrawer(),
      body: StreamBuilder(
        stream: _expenseService.allExpenses(ownerUserId: userId),
        builder: (context, snapshot) {
          final allExpenses = snapshot.data as Iterable<Expense>;
          return StreamBuilder(
            stream: _accountService.allAccounts(ownerUserId: userId),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.active:
                  if (snapshot.hasData) {
                    final allAccounts = snapshot.data as Iterable<Account>;
                    return SummaryListView(
                      expenses: allExpenses,
                      accounts: allAccounts,
                      onDeleteExpense: (expense) async {
                        await _expenseService.deleteExpense(
                            documentId: expense.documentId);
                      },
                      onTap: (account) {
                        Navigator.of(context).pushNamed(
                          createOrUpdateAccountRoute,
                          arguments: account,
                        );
                      },
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                default:
                  return const CircularProgressIndicator();
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(createOrUpdateExpenseRoute);
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
