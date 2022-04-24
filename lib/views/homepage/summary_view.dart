import 'package:flutter/material.dart';
import 'package:myexpenses/constants/routes.dart';
import 'package:myexpenses/services/cloud/account/account.dart';
import 'package:myexpenses/services/cloud/operation/operation.dart';
import 'package:myexpenses/services/cloud/operation/firebase_operation.dart';
import 'package:myexpenses/views/navBar.dart';
import '../../services/auth/auth_service.dart';
import 'package:myexpenses/services/cloud/account/firebase_account.dart';
import 'package:myexpenses/views/homepage/summary_list_view.dart';

class SummaryView extends StatefulWidget {
  const SummaryView({Key? key}) : super(key: key);

  @override
  State<SummaryView> createState() => _SummaryViewState();
}

class _SummaryViewState extends State<SummaryView> {
  late final FirebaseOperation _operationService;
  late final FirebaseAccount _accountService;

  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _operationService = FirebaseOperation();
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
        stream: _operationService.allOperations(ownerUserId: userId),
        builder: (context, snapshot) {
          // Iterable<Operation> allOperations = snapshot.data as Iterable<Operation>;
          // allOperations ??= const Iterable.empty();
          Iterable<Operation> allOperations = (snapshot.data != null)
              ? snapshot.data as Iterable<Operation>
              : const Iterable.empty();
          return StreamBuilder(
            stream: _accountService.allAccounts(ownerUserId: userId),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.active:
                  if (snapshot.hasData) {
                    final allAccounts = snapshot.data as Iterable<Account>;
                    return SummaryListView(
                      expenses: allOperations,
                      accounts: allAccounts,
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
