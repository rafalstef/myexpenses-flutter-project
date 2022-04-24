import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myexpenses/services/cloud/account/account.dart';
import 'package:myexpenses/services/cloud/category/category.dart';
import 'package:myexpenses/services/cloud/cloud_storage_constants.dart';
import 'package:myexpenses/services/cloud/cloud_storage_exceptions.dart';
import 'package:myexpenses/services/cloud/operation/operation.dart';

class FirebaseOperation {
  final operations = FirebaseFirestore.instance.collection('operation');

  Future<void> deleteOperation({required String documentId}) async {
    try {
      await operations.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteOperationException();
    }
  }

  Future<void> updateOperation({
    required String documentId,
    required OperationCategory category,
    required Account account,
    required double cost,
    required DateTime date,
  }) async {
    try {
      await operations.doc(documentId).update({
        categoryFieldName: category.toMap(),
        accountFieldName: account.toMap(),
        costFieldName: cost,
        dateFieldName: date,
      });
    } catch (e) {
      throw CouldNotCreateUpdateOperationException();
    }
  }

  Stream<Iterable<Operation>> allOperations({required String ownerUserId}) =>
      operations.snapshots().map((event) => event.docs
          .map((doc) => Operation.fromSnapshot(doc))
          .where((operation) => operation.ownerUserId == ownerUserId));

  Future<Iterable<Operation>> getOperations({required String owenrUserId}) async {
    try {
      return await operations
          .where(
            ownerUserIdFieldName,
            isEqualTo: owenrUserId,
          )
          .get()
          .then(
            (value) => value.docs.map(
              (doc) => Operation.fromSnapshot(doc),
            ),
          );
    } catch (e) {
      throw CouldNotGetAllOperationsException();
    }
  }

  Future<Iterable<Operation>> getExpenseOperations(
      {required String ownerUserId}) async {
    try {
      return await operations
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          )
          .where(
            categoryFieldName + '.' + isIncomeNameField,
            isEqualTo: false,
          )
          .get()
          .then(
            (value) => value.docs.map(
              (doc) => Operation.fromSnapshot(doc),
            ),
          );
    } catch (e) {
      throw CouldNotGetAllOperationsException();
    }
  }

  Future<Iterable<Operation>> getIncomeOperations(
      {required String ownerUserId}) async {
    try {
      return await operations
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          )
          .where(
            categoryFieldName + '.' + isIncomeNameField,
            isEqualTo: true,
          )
          .get()
          .then(
            (value) => value.docs.map(
              (doc) => Operation.fromSnapshot(doc),
            ),
          );
    } catch (e) {
      throw CouldNotGetAllOperationsException();
    }
  }

  Future<Operation> createNewOperation({required String ownerUserId}) async {
    final document = await operations.add({
      ownerUserIdFieldName: ownerUserId,
      categoryFieldName: null,
      accountFieldName: null,
      costFieldName: 0,
      dateFieldName: null,
    });
    final fetchedOperation = await document.get();
    return Operation(
      documentId: fetchedOperation.id,
      ownerUserId: ownerUserId,
      category: null,
      account: null,
      cost: 0,
      date: DateTime.now(),
    );
  }
}
