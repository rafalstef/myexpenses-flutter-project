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
      nameFieldName: name,
      isIncomeNameField: isIncome,
    };
  }

  ExpenseCategory.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        name = snapshot.data()[nameFieldName],
        isIncome = snapshot.data()[isIncomeNameField];
}
