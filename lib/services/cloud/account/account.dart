import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myexpenses/services/cloud/cloud_storage_constants.dart';
import 'package:flutter/foundation.dart';

@immutable
class Account {
  final String documentId;
  final String ownerUserId;
  final String name;
  final double amount;
  final bool includeInBalance;

  const Account({
    required this.documentId,
    required this.ownerUserId,
    required this.name,
    required this.amount,
    required this.includeInBalance,
  });

  Map<String, dynamic> toMap() {
    return {
      documentIdFieldName: documentId,
      nameFieldName: name,
      amountFieldName: amount,
      includeInBalanceFieldName: includeInBalance,
    };
  }

  Account.fromMap(Map<String, dynamic> accountMap, String owner)
      : documentId = accountMap[documentIdFieldName],
        ownerUserId = owner,
        name = accountMap[nameFieldName],
        amount = accountMap[amountFieldName],
        includeInBalance = accountMap[includeInBalanceFieldName];

  Account.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        name = snapshot.data()[nameFieldName],
        amount = double.parse(snapshot.data()[amountFieldName].toString()),
        includeInBalance = snapshot.data()[includeInBalanceFieldName];
}
