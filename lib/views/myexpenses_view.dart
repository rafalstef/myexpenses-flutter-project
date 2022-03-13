import 'package:flutter/material.dart';
import 'package:myexpenses/constants/routes.dart';
import 'package:myexpenses/enums/menu_action.dart';
import 'package:myexpenses/services/auth/auth_service.dart';
import 'package:myexpenses/utilities/show_logout_dialog.dart';

class MyexpensesView extends StatefulWidget {
  const MyexpensesView({Key? key}) : super(key: key);

  @override
  State<MyexpensesView> createState() => _MyexpensesViewState();
}

class _MyexpensesViewState extends State<MyexpensesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Expenses - Main UI'),
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
      body: const Text('Hello World!'),
    );
  }
}
