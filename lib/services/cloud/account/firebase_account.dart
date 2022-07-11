import 'package:cloud_firestore/cloud_firestore.dart';
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

  Stream<Iterable<Account>> allAccounts() =>
      accounts
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

  Future<Account> createNewAccount() async {
    final document = await accounts.add({
      nameFieldName: '',
      amountFieldName: 0,
      includeInBalanceFieldName: false,
    });
    final fetchedAccount = await document.get();
    return Account(
      documentId: fetchedAccount.id,
      name: '',
      amount: 0,
      includeInBalance: false,
    );
  }
}
