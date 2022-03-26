import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myexpenses/services/cloud/cloud_storage_constants.dart';
import 'package:flutter/foundation.dart';

@immutable
class CloudAccount {
  final String documentId;
  final String ownerUserId;
  final String name;
  final double amount;
  final bool includeInBalance;

  const CloudAccount({
    required this.documentId,
    required this.ownerUserId,
    required this.name,
    required this.amount,
    required this.includeInBalance,
  });

  CloudAccount.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        name = snapshot.data()[accountNameFieldName],
        amount = double.parse(snapshot.data()[amountFieldName].toString()),
        includeInBalance = snapshot.data()[includeInBalanceFieldName];
}
