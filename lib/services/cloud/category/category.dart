import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myexpenses/services/cloud/cloud_storage_constants.dart';
import 'package:flutter/foundation.dart';

@immutable
class Category {
  final String documentId;
  final String ownerUserId;
  final String name;
  final bool isIncome;

  const Category({
    required this.documentId,
    required this.ownerUserId,
    required this.name,
    required this.isIncome,
  });

  Category.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        name = snapshot.data()[nameFieldName],
        isIncome = snapshot.data()[isIncomeNameField];
}
