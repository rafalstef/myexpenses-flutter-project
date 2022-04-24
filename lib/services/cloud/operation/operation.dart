import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myexpenses/services/cloud/account/account.dart';
import 'package:myexpenses/services/cloud/category/category.dart';
import 'package:myexpenses/services/cloud/cloud_storage_constants.dart';
import 'package:flutter/foundation.dart';

@immutable
class Operation {
  final String documentId;
  final String ownerUserId;
  final OperationCategory? category;
  final Account? account;
  final double cost;
  final DateTime date;

  const Operation({
    required this.documentId,
    required this.ownerUserId,
    required this.category,
    required this.account,
    required this.cost,
    required this.date,
  });

  Operation.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        category = OperationCategory.fromMap(
          snapshot.data()[categoryFieldName],
          snapshot.data()[ownerUserIdFieldName],
        ),
        account = Account.fromMap(
          snapshot.data()[accountFieldName],
          snapshot.data()[ownerUserIdFieldName],
        ),
        cost = double.parse(snapshot.data()[costFieldName].toString()),
        date = snapshot.data()[dateFieldName].toDate();
}