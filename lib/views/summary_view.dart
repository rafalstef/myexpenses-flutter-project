// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:myexpenses/constants/routes.dart';
import 'package:myexpenses/views/navBar.dart';
import '../../services/auth/auth_service.dart';
import 'package:myexpenses/services/cloud/account/firebase_account.dart';
import 'package:myexpenses/views/summary_list_view.dart';

import '../services/cloud/account/account.dart';

var sumup = 0;

class SummaryView extends StatefulWidget {
  const SummaryView({Key? key}) : super(key: key);

  @override
  State<SummaryView> createState() => _SummaryViewState();
}

class _SummaryViewState extends State<SummaryView> {
  late final FirebaseAccount _summaryService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _summaryService = FirebaseAccount();
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
        stream: _summaryService.allAccounts(ownerUserId: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allAccounts = snapshot.data as Iterable<Account>;
                return SummaryListView(
                  accounts: allAccounts,
                  onDeleteAccount: (account) async {
                    await _summaryService.deleteAccount(
                        documentId: account.documentId);
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(createOrUpdateAccountRoute);
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
