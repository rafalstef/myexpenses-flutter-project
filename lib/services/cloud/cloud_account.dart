import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myexpenses/services/cloud/cloud_storage_constants.dart';
import 'package:flutter/foundation.dart';

@immutable
class CloudAccount {
  final String documentId;
  final String ownerUserId;
  final String accountName;
  final double accountAmount;
  final bool includeInBalance;

  const CloudAccount({
    required this.documentId,
    required this.ownerUserId,
    required this.accountName,
    required this.accountAmount,
    required this.includeInBalance,
  });

  CloudAccount.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        accountName = snapshot.data()[accountNameFieldName],
        accountAmount = snapshot.data()[accountAmountFieldName],
        includeInBalance = snapshot.data()[includeInBalanceFieldName];
}
