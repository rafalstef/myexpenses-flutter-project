import 'package:flutter/material.dart';
import 'package:myexpenses/constants/routes.dart';
import 'package:myexpenses/services/auth/auth_service.dart';
import 'package:myexpenses/views/expenses/accounts_view.dart';
import 'package:myexpenses/views/expenses/create_update_accounts_view.dart';
import 'package:myexpenses/views/user_authentication/forgot_password_view.dart';
import 'package:myexpenses/views/user_authentication/login_view.dart';
import 'package:myexpenses/views/user_authentication/register_view.dart';
import 'package:myexpenses/views/user_authentication/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        myexpensesRoute: (context) => const AccountsView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        forgotPasswordRoute: (context) => const ForgotPasswordView(),
        createOrUpdateAccountRoute: (context) =>
            const CreateUpdateAccountView(),
        accountsViewRoute: (context) => const AccountsView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const AccountsView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
