import 'package:flutter/material.dart';
import 'package:myexpenses/constants/routes.dart';
import 'package:myexpenses/services/auth/auth_service.dart';
import 'package:myexpenses/services/cloud/account/account.dart';
import 'package:myexpenses/services/cloud/account/firebase_account.dart';
import 'package:myexpenses/views/accounts/accounts_list_view.dart';
import 'package:myexpenses/views/navBar.dart';

class AccountsView extends StatefulWidget {
  const AccountsView({Key? key}) : super(key: key);

  @override
  State<AccountsView> createState() => _AccountsViewState();
}

class _AccountsViewState extends State<AccountsView> {
  late final FirebaseAccount _accountsService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _accountsService = FirebaseAccount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts'),
      ),
      drawer: const SideDrawer(),
      body: StreamBuilder(
        stream: _accountsService.allAccounts(ownerUserId: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allAccounts = snapshot.data as Iterable<Account>;
                return AccountsListView(
                  accounts: allAccounts,
                  onDeleteAccount: (account) async {
                    await _accountsService.deleteAccount(
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
