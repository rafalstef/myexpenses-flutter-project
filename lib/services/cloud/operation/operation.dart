import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myexpenses/services/cloud/account/account.dart';
import 'package:myexpenses/services/cloud/category/category.dart';
import 'package:myexpenses/services/cloud/cloud_storage_constants.dart';
import 'package:flutter/foundation.dart';

@immutable
class Operation {
  final String documentId;
  final double cost;
  final DateTime date;
  final String description;
  final Account account;
  final OperationCategory category;

  const Operation({
    required this.documentId,
    required this.cost,
    required this.date,
    required this.description,
    required this.account,
    required this.category,
  });

  Operation.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        cost = double.parse(snapshot.data()[costFieldName].toString()),
        date = snapshot.data()[dateFieldName].toDate(),
        description = snapshot.data()[descriptionFieldName],
        account = Account.fromMap(snapshot.data()[accountFieldName]),
        category = OperationCategory.fromMap(
          snapshot.data()[categoryFieldName],
        );
}
