import 'package:flutter/material.dart';
import 'package:myexpenses/config/styles/decorations/app_decorations.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';
import 'package:myexpenses/services/cloud/operation/operation.dart';
import 'package:myexpenses/services/cloud/operation/firebase_operation.dart';
import 'package:myexpenses/utilities/loading_widgets/loading_widget.dart';
import 'package:myexpenses/services/auth/auth_service.dart';
import 'package:myexpenses/views/homepage/homepage_widgets.dart';
import 'package:myexpenses/views/navBar.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({Key? key}) : super(key: key);

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView>
    with AutomaticKeepAliveClientMixin<HomePageView> {
  String get userId => AuthService.firebase().currentUser!.id;
  late final FirebaseOperation _operationService;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _operationService = FirebaseOperation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      decoration: AppDecorations.homePageGradient(),
      child: Scaffold(
        drawer: const SideDrawer(),
        extendBody: true,
        body: NestedScrollView(
          body: _homePageData(),
          floatHeaderSlivers: false,
          headerSliverBuilder: (context, innerBoxIsScrolled) =>
              [_homePageAppBar()],
        ),
        backgroundColor: AppColors.transparent,
      ),
    );
  }

  StreamBuilder _homePageData() {
    return StreamBuilder(
      stream: _operationService.recentOperation(
        ownerUserId: userId,
        number: 5,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
            if (snapshot.hasData) {
              Iterable<Operation> allOperations = (snapshot.data != null)
                  ? snapshot.data as Iterable<Operation>
                  : const Iterable.empty();
              return HomePageWidgets(operations: allOperations);
            } else {
              return loadingWidget();
            }
          default:
            return loadingWidget();
        }
      },
    );
  }

  SliverAppBar _homePageAppBar() {
    return const SliverAppBar(
      centerTitle: true,
      floating: true,
      pinned: false,
      backgroundColor: AppColors.transparent,
      elevation: 0,
    );
  }
}
