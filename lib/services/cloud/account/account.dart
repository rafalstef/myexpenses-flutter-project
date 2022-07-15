import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myexpenses/services/cloud/cloud_storage_constants.dart';

@immutable
class Account {
  final String documentId;
  final String name;
  final double amount;
  final bool includeInBalance;
  final Color color;
  final IconData icon;

  const Account({
    required this.documentId,
    required this.name,
    required this.amount,
    required this.includeInBalance,
    required this.color,
    required this.icon,
  });

  Map<String, dynamic> toMap() {
    return {
      documentIdFieldName: documentId,
      nameFieldName: name,
      amountFieldName: amount,
      includeInBalanceFieldName: includeInBalance,
      iconFieldName: icon.codePoint,
      colorFieldName: color.value,
    };
  }

  Account.fromMap(Map<String, dynamic> accountMap)
      : documentId = accountMap[documentIdFieldName],
        name = accountMap[nameFieldName],
        amount = accountMap[amountFieldName],
        includeInBalance = accountMap[includeInBalanceFieldName],
        color = Color(accountMap[colorFieldName]),
        icon = IconData(
          accountMap[iconFieldName],
          fontFamily: 'MaterialIcons',
        );

  Account.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        name = snapshot.data()[nameFieldName],
        amount = double.parse(snapshot.data()[amountFieldName].toString()),
        includeInBalance = snapshot.data()[includeInBalanceFieldName],
        color = Color(snapshot.data()[colorFieldName]),
        icon = IconData(
          snapshot.data()[iconFieldName],
          fontFamily: 'MaterialIcons',
        );
}
