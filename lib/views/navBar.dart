// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:myexpenses/constants/routes.dart';
import 'package:myexpenses/enums/menu_action.dart';
import 'package:myexpenses/services/auth/auth_service.dart';
import 'package:myexpenses/utilities/show_logout_dialog.dart';
import 'package:myexpenses/views/expenses/accounts_view.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          const DrawerHeader(
            child: Center(
              child: Text(
                'Menu',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () => {},
          ),
          ListTile(
            leading: const Icon(Icons.account_balance_wallet),
            title: const Text('Accounts'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AccountsView(),
                ),
              )
            },
          ),
          ListTile(
            leading: const Icon(Icons.analytics),
            title: const Text('Summary'),
            onTap: () => {
              Navigator.of(context).pushNamedAndRemoveUntil(
                summaryViewRoute,
                (route) => false,
              ),
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () async => {
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
            },
          ),
        ],
      ),
    );
  }
}
