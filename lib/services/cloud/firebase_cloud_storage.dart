import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myexpenses/services/cloud/cloud_account.dart';
import 'package:myexpenses/services/cloud/cloud_storage_constants.dart';
import 'package:myexpenses/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
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
          accountNameFieldName: name,
          amountFieldName: ammount,
          includeInBalanceFieldName: includeToBalance,
        },
      );
    } catch (e) {
      throw CouldNotCreateUpdateAccontException();
    }
  }

  Stream<Iterable<CloudAccount>> allAccounts({required String ownerUserId}) =>
      accounts.snapshots().map((event) => event.docs
          .map((doc) => CloudAccount.fromSnapshot(doc))
          .where((account) => account.ownerUserId == ownerUserId));

  Future<Iterable<CloudAccount>> getAccounts(
      {required String owenrUserId}) async {
    try {
      return await accounts
          .where(
            ownerUserIdFieldName,
            isEqualTo: owenrUserId,
          )
          .get()
          .then(
            (value) => value.docs.map(
              (doc) => CloudAccount.fromSnapshot(doc),
            ),
          );
    } catch (e) {
      throw CouldNotGetAllAccountsException();
    }
  }

  Future<CloudAccount> createNewAccount({required String ownerUserId}) async {
    final document = await accounts.add({
      ownerUserIdFieldName: ownerUserId,
      accountNameFieldName: '',
      amountFieldName: 0,
      includeInBalanceFieldName: false,
    });
    final fetchedAccount = await document.get();
    return CloudAccount(
      documentId: fetchedAccount.id,
      ownerUserId: ownerUserId,
      name: '',
      amount: 0,
      includeInBalance: false,
    );
  }
}
