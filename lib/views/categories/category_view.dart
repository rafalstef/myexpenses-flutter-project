import 'package:flutter/material.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';
import 'package:myexpenses/config/styles/decorations/app_decorations.dart';
import 'package:myexpenses/constants/routes.dart';
import 'package:myexpenses/enums/user_transaction_enum.dart';
import 'package:myexpenses/services/auth/auth_service.dart';
import 'package:myexpenses/services/cloud/category/category.dart';
import 'package:myexpenses/services/cloud/category/firebase_category.dart';
import 'package:myexpenses/utilities/UI_components/app_bars/custom_app_bars.dart';
import 'package:myexpenses/utilities/UI_components/loading_widgets/loading_widget.dart';
import 'package:myexpenses/utilities/UI_components/tab_bars/switch_tab_bar.dart';
import 'package:myexpenses/utilities/UI_components/tiles/category_tile.dart';
import 'package:myexpenses/views/navBar.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({Key? key}) : super(key: key);

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  late final FirebaseCategory _categoryService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _categoryService = FirebaseCategory(userUid: userId);
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideDrawer(),
      backgroundColor: AppColors.light60,
      appBar: CustomAppBar.transparent(
          title: 'Categories', textColor: AppColors.dark100),
      floatingActionButton: _floatingButton(context),
      body: _buildTabBarView(),
    );
  }

  FloatingActionButton _floatingButton(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      backgroundColor: AppColors.violet100,
      onPressed: () =>
          Navigator.of(context).pushNamed(createOrUpdateCategoryRoute),
    );
  }

  Widget _buildTabBarView() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: SwitchTabBar(
            tabController: _tabController,
            first: 'Expense',
            second: 'Income',
          ),
        ),
        Expanded(
          child: Container(
            decoration: AppDecorations.newTransactionDecoration(),
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 8.0,
            ),
            child: TabBarView(
              controller: _tabController,
              children: [
                _categoryStream(
                  stream: _categoryService.onTypeCategory(
                      type: UserTransaction.expense),
                ),
                _categoryStream(
                  stream: _categoryService.onTypeCategory(
                      type: UserTransaction.income),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  StreamBuilder<Iterable<OperationCategory>> _categoryStream({
    required Stream<Iterable<OperationCategory>>? stream,
  }) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.active:
            if (snapshot.hasData) {
              final categories = snapshot.data as Iterable<OperationCategory>;
              return ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final OperationCategory category =
                      categories.elementAt(index);
                  return CategoryTile(
                    category: category,
                    onTap: (item) {
                      Navigator.of(context).pushNamed(
                        createOrUpdateCategoryRoute,
                        arguments: item,
                      );
                    },
                  );
                },
              );
            }
            return loadingWidget();
          default:
            return loadingWidget();
        }
      },
    );
  }
}
