import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myexpenses/services/cloud/account/account.dart';
import 'package:myexpenses/services/cloud/category/category.dart';
import 'package:myexpenses/services/cloud/cloud_storage_constants.dart';
import 'package:flutter/foundation.dart';

@immutable
class Operation {
  final String documentId;
  final OperationCategory? category;
  final Account? account;
  final double cost;
  final DateTime date;

  const Operation({
    required this.documentId,
    required this.category,
    required this.account,
    required this.cost,
    required this.date,
  });

  Operation.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        date = snapshot.data()[dateFieldName].toDate(),
        cost = double.parse(snapshot.data()[costFieldName].toString()),
        account = Account.fromMap(snapshot.data()[accountFieldName]),
        category = OperationCategory.fromMap(
          snapshot.data()[categoryFieldName],
        );
}
