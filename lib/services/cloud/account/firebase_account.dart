import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myexpenses/services/cloud/account/account.dart';
import 'package:myexpenses/services/cloud/cloud_storage_constants.dart';
import 'package:myexpenses/services/cloud/cloud_storage_exceptions.dart';

class FirebaseAccount {
  final String userUid;
  final CollectionReference<Map<String, dynamic>> accounts;

  FirebaseAccount({required this.userUid})
      : accounts = FirebaseFirestore.instance
            .collection('user')
            .doc(userUid)
            .collection('account');

  Future<void> createNewAccount({
    required String name,
    required double amount,
    required bool includeInBalance,
    required Color color,
    required IconData icon,
  }) async {
    await accounts.add({
      nameFieldName: name,
      amountFieldName: amount,
      includeInBalanceFieldName: includeInBalance,
      colorFieldName: color.value,
      iconFieldName: icon.codePoint,
    });
  }

  Future<void> updateAccount({
    required String documentId,
    required String name,
    required double ammount,
    required bool includeToBalance,
    required Color color,
    required IconData icon,
  }) async {
    try {
      await accounts.doc(documentId).update(
        {
          nameFieldName: name,
          amountFieldName: ammount,
          includeInBalanceFieldName: includeToBalance,
          colorFieldName: color.value,
          iconFieldName: icon.codePoint,
        },
      );
    } catch (e) {
      throw CouldNotCreateUpdateAccountException();
    }
  }

  Future<void> updateAccountAmmount({
    required String documentId,
    required double amount,
  }) async {
    try {
      await accounts.doc(documentId).update(
        {amountFieldName: amount},
      );
    } catch (e) {
      throw CouldNotCreateUpdateAccountException();
    }
  }

  Future<void> deleteAccount({required String documentId}) async {
    try {
      await accounts.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteAccountException();
    }
  }

  Stream<Iterable<Account>> allAccounts() => accounts
      .snapshots()
      .map((event) => event.docs.map((doc) => Account.fromSnapshot(doc)));

  Future<Iterable<Account>> getAccounts() async {
    try {
      return await accounts.get().then(
            (value) => value.docs.map(
              (doc) => Account.fromSnapshot(doc),
            ),
          );
    } catch (e) {
      throw CouldNotGetAllAccountsException();
    }
  }

  Future<double> getAccountAmount({required String documentId}) async {
    try {
      return await accounts.doc(documentId).get().then(
            (value) => value.data()![amountFieldName],
          );
    } catch (e) {
      throw CouldNotGetAccountAmountException();
    }
  }
}
