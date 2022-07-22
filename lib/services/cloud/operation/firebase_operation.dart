import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myexpenses/enums/sort_method.dart';
import 'package:myexpenses/enums/user_transaction_enum.dart';
import 'package:myexpenses/services/cloud/account/account.dart';
import 'package:myexpenses/services/cloud/category/category.dart';
import 'package:myexpenses/services/cloud/cloud_storage_constants.dart';
import 'package:myexpenses/services/cloud/cloud_storage_exceptions.dart';
import 'package:myexpenses/services/cloud/operation/operation.dart';
import 'package:myexpenses/views/list_preferences/list_preferences.dart';

class FirebaseOperation {
  final String userUid;
  final CollectionReference<Map<String, dynamic>> operations;

  FirebaseOperation({required this.userUid})
      : operations = FirebaseFirestore.instance
            .collection('user')
            .doc(userUid)
            .collection('operation');

  Future<void> createNewOperation({
    required double cost,
    required DateTime date,
    required String description,
    required Account account,
    required OperationCategory category,
  }) async {
    await operations.add({
      costFieldName: cost,
      dateFieldName: date,
      descriptionFieldName: description,
      accountFieldName: account.toMap(),
      categoryFieldName: category.toMap(),
    });
  }

  Future<void> updateOperation({
    required String documentId,
    required double cost,
    required DateTime date,
    required String description,
    required Account account,
    required OperationCategory category,
  }) async {
    try {
      await operations.doc(documentId).update({
        costFieldName: cost,
        dateFieldName: date,
        descriptionFieldName: description,
        accountFieldName: account.toMap(),
        categoryFieldName: category.toMap(),
      });
    } catch (e) {
      throw CouldNotCreateUpdateOperationException();
    }
  }

  Future<void> deleteOperation({required String documentId}) async {
    try {
      await operations.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteOperationException();
    }
  }

  Stream<Iterable<Operation>> preferredOperations({
    required ListPreferences preferences,
  }) {
    List<UserTransaction> transactions = preferences.userTransactions;

    if (transactions.length == 1) {
      return _getOneTypeOfOperations(
        preferences: preferences,
        type: transactions[0],
      );
    }

    if (transactions.length == 2) {
      return _allOperations(
        preferences: preferences,
      );
    }
    return operations.snapshots().map((event) => event.docs
        .map((doc) => Operation.fromSnapshot(doc))
        .where((operation) => false));
  }

  Stream<Iterable<Operation>> _allOperations({
    required ListPreferences preferences,
  }) {
    DateTime startDate = preferences.startDate;
    DateTime endDate = preferences.endDate;
    SortMethod sort = preferences.sortMethod;
    String fieldSort = (sort == SortMethod.newest || sort == SortMethod.oldest)
        ? dateFieldName
        : costFieldName;
    bool descending = (sort == SortMethod.newest || sort == SortMethod.biggest)
        ? true
        : false;
    return operations
        .orderBy(fieldSort, descending: descending)
        .snapshots()
        .map(
          (event) => event.docs
              .map((doc) => Operation.fromSnapshot(doc))
              .where((operation) => preferences.filteredAccountIds
                  .contains(operation.account.documentId))
              .where(
                (operation) =>
                    (operation.date.compareTo(startDate) >= 0) &&
                    (operation.date.compareTo(endDate) <= 0),
              ),
        );
  }

  Stream<Iterable<Operation>> _getOneTypeOfOperations({
    required ListPreferences preferences,
    required UserTransaction type,
  }) {
    bool isIncome = (type == UserTransaction.income) ? true : false;
    DateTime startDate = preferences.startDate;
    DateTime endDate = preferences.endDate;
    SortMethod sort = preferences.sortMethod;
    String fieldSort = (sort == SortMethod.newest || sort == SortMethod.oldest)
        ? dateFieldName
        : costFieldName;
    bool descending = (sort == SortMethod.newest || sort == SortMethod.biggest)
        ? true
        : false;
    return operations
        .orderBy(fieldSort, descending: descending)
        .snapshots()
        .map(
          (event) => event.docs
              .map((doc) => Operation.fromSnapshot(doc))
              .where((operation) => operation.category.isIncome == isIncome)
              .where((operation) => preferences.filteredAccountIds
                  .contains(operation.account.documentId))
              .where(
                (operation) =>
                    (operation.date.compareTo(startDate) >= 0) &&
                    (operation.date.compareTo(endDate) <= 0),
              ),
        );
  }

  Stream<Iterable<Operation>> recentOperation({
    required int number,
  }) {
    return operations
        .orderBy(dateFieldName, descending: true)
        .limit(number)
        .snapshots()
        .map((event) => event.docs.map((doc) => Operation.fromSnapshot(doc)));
  }

  Future<Iterable<Operation>> getOperations({
    required ListPreferences preferences,
  }) async {
    try {
      DateTime startDate = preferences.startDate;
      DateTime endDate = preferences.endDate;
      SortMethod sort = preferences.sortMethod;
      String fieldSort =
          (sort == SortMethod.newest || sort == SortMethod.oldest)
              ? dateFieldName
              : costFieldName;
      bool descending =
          (sort == SortMethod.newest || sort == SortMethod.biggest)
              ? true
              : false;
      return await operations
          .orderBy(fieldSort, descending: descending)
          .get()
          .then((value) => value.docs
              .map(
                (doc) => Operation.fromSnapshot(doc),
              )
              .where((operation) => preferences.filteredAccountIds
                  .contains(operation.account.documentId))
              .where(
                (operation) =>
                    (operation.date.compareTo(startDate) >= 0) &&
                    (operation.date.compareTo(endDate) <= 0),
              ));
    } catch (e) {
      throw CouldNotGetAllOperationsException();
    }
  }

  Future<Iterable<Operation>> getExpenseOperations() async {
    try {
      return await operations
          .where(
            categoryFieldName + '.' + isIncomeNameField,
            isEqualTo: false,
          )
          .get()
          .then(
            (value) => value.docs.map((doc) => Operation.fromSnapshot(doc)),
          );
    } catch (e) {
      throw CouldNotGetAllOperationsException();
    }
  }

  Future<Iterable<Operation>> getIncomeOperations() async {
    try {
      return await operations
          .where(
            categoryFieldName + '.' + isIncomeNameField,
            isEqualTo: true,
          )
          .get()
          .then(
              (value) => value.docs.map((doc) => Operation.fromSnapshot(doc)));
    } catch (e) {
      throw CouldNotGetAllOperationsException();
    }
  }
}
