// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:myexpenses/constants/routes.dart';
import '../../services/auth/auth_service.dart';
import '../../services/cloud/firebase_cloud_storage.dart';

class SummaryView extends StatefulWidget {
  const SummaryView({Key? key}) : super(key: key);

  @override
  State<SummaryView> createState() => _SummaryViewState();
}

class _SummaryViewState extends State<SummaryView> {
  late final FirebaseCloudStorage _summaryService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _summaryService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Your summary"),
          backgroundColor: Colors.blue,
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              accountsViewRoute,
              (route) => false,
            );
          },
          icon: const Icon(Icons.analytics),
          label: const Text("Details"),
        ),
      ),
    );
  }
}
