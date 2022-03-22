import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myexpenses/services/cloud/cloud_account.dart';
import 'package:myexpenses/services/cloud/cloud_storage_constants.dart';
import 'package:myexpenses/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  final accounts = FirebaseFirestore.instance.collection('accounts');

  Future<void> deleteAccount({required String documentId}) async {
    try {
      await accounts.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteAccountException();
    }
  }

  Future<void> updateAccount(
      {required String documentId, required double ammount}) async {
    try {
      await accounts.doc(documentId).update({amountFieldName: ammount});
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
            (value) => value.docs.map((doc) {
              return CloudAccount(
                documentId: doc.id,
                ownerUserId: doc.data()[ownerUserIdFieldName] as String,
                accountName: doc.data()[accountNameFieldName] as String,
                accountAmount: doc.data()[amountFieldName] as double,
                includeInBalance: doc.data()[includeInBalanceFieldName] as bool,
              );
            }),
          );
    } catch (e) {
      throw CouldNotGetAllAccountsException();
    }
  }

  void createNewAccount({required String ownerUserId}) async {
    await accounts.add({
      ownerUserIdFieldName: ownerUserId,
      accountNameFieldName: '',
      amountFieldName: 0,
      includeInBalanceFieldName: false,
    });
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}
