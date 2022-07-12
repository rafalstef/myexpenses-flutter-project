import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myexpenses/services/cloud/cloud_storage_constants.dart';

@immutable
class OperationCategory {
  final String documentId;
  final String name;
  final bool isIncome;
  final Color color;
  final IconData icon;

  const OperationCategory({
    required this.documentId,
    required this.name,
    required this.isIncome,
    required this.color,
    required this.icon,
  });

  Map<String, dynamic> toMap() {
    return {
      documentIdFieldName: documentId,
      nameFieldName: name,
      isIncomeNameField: isIncome,
      iconFieldName: icon.codePoint,
      colorFieldName: color.value,
    };
  }

  OperationCategory.fromMap(Map<String, dynamic> categoryMap)
      : documentId = categoryMap[documentIdFieldName],
        name = categoryMap[nameFieldName],
        isIncome = categoryMap[isIncomeNameField],
        color = Color(categoryMap[colorFieldName]),
        icon = IconData(
          categoryMap[iconFieldName],
          fontFamily: 'MaterialIcons',
        );

  OperationCategory.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        name = snapshot.data()[nameFieldName],
        isIncome = snapshot.data()[isIncomeNameField],
        color = Color(snapshot.data()[colorFieldName]),
        icon = IconData(
          snapshot.data()[iconFieldName],
          fontFamily: 'MaterialIcons',
        );
}
