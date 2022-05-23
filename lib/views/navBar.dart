// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:myexpenses/constants/routes.dart';
import 'package:myexpenses/services/auth/auth_service.dart';
import 'package:myexpenses/utilities/dialogs/show_logout_dialog.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          const DrawerHeader(
            child: Center(),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      'https://i.postimg.cc/DzQzcPXz/money-background.png'),
                  fit: BoxFit.cover),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () => {Navigator.pushNamed(context, summaryViewRoute)},
          ),
          ListTile(
            leading: const Icon(Icons.attach_money_sharp),
            title: const Text('Accounts'),
            onTap: () => {Navigator.pushNamed(context, accountsViewRoute)},
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Categories'),
            onTap: () => {Navigator.pushNamed(context, categoryViewRoute)},
          ),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('Logout'),
                onTap: () async => {
                  showLogOutDialog(context),
                  if (await showLogOutDialog(context))
                    {
                      await AuthService.firebase().logOut(),
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        loginRoute,
                        (_) => false,
                      )
                    }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
