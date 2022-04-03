import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myexpenses/services/cloud/account/account.dart';
import 'package:myexpenses/services/cloud/cloud_storage_constants.dart';
import 'package:flutter/foundation.dart';

@immutable
class Expense {
  final String documentId;
  final String ownerUserId;
  final Category? category;
  final Account? account;
  final double cost;
  final DateTime date;

  const Expense({
    required this.documentId,
    required this.ownerUserId,
    required this.category,
    required this.account,
    required this.cost,
    required this.date,
  });

  Expense.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        category = snapshot.data()[categoryFieldName],
        account = snapshot.data()[accountFieldName],
        cost = double.parse(snapshot.data()[costFieldName].toString()),
        date = snapshot.data()[dateFieldName];
}
