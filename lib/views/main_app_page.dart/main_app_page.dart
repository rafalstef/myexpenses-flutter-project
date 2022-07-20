import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:myexpenses/config/styles/text_styles/app_text_styles.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';
import 'package:myexpenses/enums/user_transaction_enum.dart';
import 'package:myexpenses/utilities/UI_components/bottom_navigation_bar.dart/bottom_navigation_bar.dart';
import 'package:myexpenses/views/all_transactions_view.dart/all_transactions_view.dart';
import 'package:myexpenses/views/budgets.dart/budgets_page.dart';
import 'package:myexpenses/views/create_update_operation/create_update_operation.dart';
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
      floatingActionButton: _buildExpandedFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void onChangedTab(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  Widget _buildExpandedFab() {
    return SpeedDial(
      elevation: 0,
      spacing: 10.0,
      spaceBetweenChildren: 10.0,
      overlayOpacity: 0.2,
      overlayColor: AppColors.violet60,
      backgroundColor: AppColors.violet100,
      activeBackgroundColor: AppColors.violet100,
      animationCurve: Curves.linear,
      useRotationAnimation: true,
      childrenButtonSize: const Size(64.0, 64.0),
      icon: Icons.add,
      activeIcon: Icons.close,
      children: [
        SpeedDialChild(
          label: 'Expense',
          labelStyle: AppTextStyles.smallMedium(AppColors.dark100),
          backgroundColor: AppColors.red100,
          foregroundColor: AppColors.light100,
          child: const Icon(Icons.arrow_downward_rounded),
          elevation: 0,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return const CreateUpdateOperation(
                    operation: null,
                    userTransaction: UserTransaction.expense,
                  );
                },
              ),
            );
          },
        ),
        SpeedDialChild(
          label: 'Income',
          labelStyle: AppTextStyles.smallMedium(AppColors.dark100),
          backgroundColor: AppColors.green100,
          foregroundColor: AppColors.light100,
          child: const Icon(Icons.arrow_upward_rounded),
          elevation: 0,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return const CreateUpdateOperation(
                    operation: null,
                    userTransaction: UserTransaction.income,
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
