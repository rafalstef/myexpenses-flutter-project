// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:myexpenses/constants/routes.dart';
import '../../enums/menu_action.dart';
import '../../services/auth/auth_service.dart';
import 'package:myexpenses/services/cloud/account/firebase_account.dart';
import '../../utilities/show_logout_dialog.dart';

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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Your summary'),
          actions: [
            PopupMenuButton<MenuAction>(
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                    final shouldLogout = await showLogOutDialog(context);
                    if (shouldLogout) {
                      await AuthService.firebase().logOut();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        loginRoute,
                        (_) => false,
                      );
                    }
                    break;
                }
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem<MenuAction>(
                    value: MenuAction.logout,
                    child: Text('Log out'),
                  ),
                ];
              },
            )
          ],
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton.extended(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    categoryViewRoute,
                  );
                },
                icon: const Icon(Icons.analytics),
                label: const Text('Category'),
              ),
              const SizedBox(height: 30),
              FloatingActionButton.extended(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    accountsViewRoute,
                  );
                },
                icon: const Icon(Icons.account_balance_wallet),
                label: const Text("Accounts"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
