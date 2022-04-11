import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myexpenses/services/cloud/cloud_storage_constants.dart';
import 'package:flutter/foundation.dart';

@immutable
class ExpenseCategory {
  final String documentId;
  final String ownerUserId;
  final String name;
  final bool isIncome;

  const ExpenseCategory({
    required this.documentId,
    required this.ownerUserId,
    required this.name,
    required this.isIncome,
  });

  Map<String, dynamic> toMap() {
    return {
      documentIdFieldName: documentId,
      nameFieldName: name,
      isIncomeNameField: isIncome,
    };
  }

  ExpenseCategory.fromMap(Map<String, dynamic> categoryMap, String owner)
      : documentId = categoryMap[documentIdFieldName],
        ownerUserId = owner,
        name = categoryMap[nameFieldName],
        isIncome = categoryMap[isIncomeNameField];


  ExpenseCategory.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        name = snapshot.data()[nameFieldName],
        isIncome = snapshot.data()[isIncomeNameField];
}
