import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myexpenses/services/cloud/cloud_storage_constants.dart';
import 'package:flutter/foundation.dart';

@immutable
class OperationCategory {
  final String documentId;
  final String name;
  final bool isIncome;

  const OperationCategory({
    required this.documentId,
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

  OperationCategory.fromMap(Map<String, dynamic> categoryMap)
      : documentId = categoryMap[documentIdFieldName],
        name = categoryMap[nameFieldName],
        isIncome = categoryMap[isIncomeNameField];


  OperationCategory.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        name = snapshot.data()[nameFieldName],
        isIncome = snapshot.data()[isIncomeNameField];
}
