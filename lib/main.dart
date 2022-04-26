import 'package:flutter/material.dart';
import 'package:myexpenses/constants/routes.dart';
import 'package:myexpenses/services/auth/auth_service.dart';
import 'package:myexpenses/views/expenses/create_update_expense_view.dart';
import 'package:myexpenses/views/expenses/expenses_chart_view.dart';
import 'package:myexpenses/views/homepage/operation_preferences.dart';
import 'package:myexpenses/views/homepage/summary_view.dart';
import 'package:myexpenses/views/accounts/accounts_view.dart';
import 'package:myexpenses/views/accounts/create_update_accounts_view.dart';
import 'package:myexpenses/views/categories/category_view.dart';
import 'package:myexpenses/views/categories/create_update_category_view.dart';
import 'package:myexpenses/views/incomes/incomes_chart_view.dart';
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
        myexpensesRoute: (context) => const SummaryView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        forgotPasswordRoute: (context) => const ForgotPasswordView(),
        createOrUpdateAccountRoute: (context) =>
            const CreateUpdateAccountView(),
        accountsViewRoute: (context) => const AccountsView(),
        summaryViewRoute: (context) => const SummaryView(),
        categoryViewRoute: (context) => const CategoryView(),
        createOrUpdateCategoryRoute: (context) =>
            const CreateUpdateCategoryView(),
        createOrUpdateExpenseRoute: (context) =>
            const CreateUpdateExpenseView(),
        expensesChartRoute: (context) => const ExpensesPieChart(),
        incomesChartRoute: (context) => const IncomesPieChart(),
        operationsPreferencesRoute: (context) => const OperationPreferences(),
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
                return const SummaryView();
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
