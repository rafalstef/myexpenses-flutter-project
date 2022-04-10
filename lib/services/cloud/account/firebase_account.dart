import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myexpenses/services/cloud/account/account.dart';
import 'package:myexpenses/services/cloud/cloud_storage_constants.dart';
import 'package:myexpenses/services/cloud/cloud_storage_exceptions.dart';

class FirebaseAccount {
  final accounts = FirebaseFirestore.instance.collection('account');

  Future<void> deleteAccount({required String documentId}) async {
    try {
      await accounts.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteAccountException();
    }
  }

  Future<void> updateAccount({
    required String documentId,
    required String name,
    required double ammount,
    required bool includeToBalance,
  }) async {
    try {
      await accounts.doc(documentId).update(
        {
          nameFieldName: name,
          amountFieldName: ammount,
          includeInBalanceFieldName: includeToBalance,
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

  Stream<Iterable<Account>> allAccounts({required String ownerUserId}) =>
      accounts.snapshots().map((event) => event.docs
          .map((doc) => Account.fromSnapshot(doc))
          .where((account) => account.ownerUserId == ownerUserId));

  Future<Iterable<Account>> getAccounts({required String owenrUserId}) async {
    try {
      return await accounts
          .where(
            ownerUserIdFieldName,
            isEqualTo: owenrUserId,
          )
          .get()
          .then(
            (value) => value.docs.map(
              (doc) => Account.fromSnapshot(doc),
            ),
          );
    } catch (e) {
      throw CouldNotGetAllAccountsException();
    }
  }

  Future<Account> createNewAccount({required String ownerUserId}) async {
    final document = await accounts.add({
      ownerUserIdFieldName: ownerUserId,
      nameFieldName: '',
      amountFieldName: 0,
      includeInBalanceFieldName: false,
    });
    final fetchedAccount = await document.get();
    return Account(
      documentId: fetchedAccount.id,
      ownerUserId: ownerUserId,
      name: '',
      amount: 0,
      includeInBalance: false,
    );
  }
}
