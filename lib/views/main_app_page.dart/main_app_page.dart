import 'package:flutter/material.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';
import 'package:myexpenses/constants/routes.dart';
import 'package:myexpenses/utilities/UI_components/bottom_navigation_bar.dart/bottom_navigation_bar.dart';
import 'package:myexpenses/views/all_transactions_view.dart/all_transactions_view.dart';
import 'package:myexpenses/views/budgets.dart/budgets_page.dart';
import 'package:myexpenses/views/homepage/homepage_view.dart';
import 'package:myexpenses/views/more_page.dart/more_page.dart';

class MainAppPage extends StatefulWidget {
  const MainAppPage({Key? key}) : super(key: key);

  @override
  State<MainAppPage> createState() => _MainAppPageState();
}

class _MainAppPageState extends State<MainAppPage> {
  int pageIndex = 0;

  final pages = <Widget>[
    const HomePageView(),
    const AllTransactionsView(),
    const BudgetsPage(),
    const MorePage(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[pageIndex],
      bottomNavigationBar: AppNavigationBar(
        index: pageIndex,
        onChangedTab: onChangedTab,
      ),
      floatingActionButton: _addOperationButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void onChangedTab(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  FloatingActionButton _addOperationButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).pushNamed(createOrUpdateExpenseRoute);
      },
      backgroundColor: AppColors.violet100,
      child: const IconTheme(
        data: IconThemeData(size: 34.0, color: AppColors.light100),
        child: Icon(Icons.add),
      ),
    );
  }
}
