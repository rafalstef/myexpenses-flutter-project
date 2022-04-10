import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myexpenses/services/cloud/account/account.dart';
import 'package:myexpenses/services/cloud/category/category.dart';
import 'package:myexpenses/services/cloud/cloud_storage_constants.dart';
import 'package:myexpenses/services/cloud/cloud_storage_exceptions.dart';
import 'package:myexpenses/services/cloud/expense/expense.dart';

class FirebaseExpense {
  final expenses = FirebaseFirestore.instance.collection('expense');

  Future<void> deleteExpense({required String documentId}) async {
    try {
      await expenses.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteExpenseException();
    }
  }

  Future<void> updateExpense({
    required String documentId,
    required ExpenseCategory category,
    required Account account,
    required double cost,
    required DateTime date,
  }) async {
    try {
      await expenses.doc(documentId).update({
        categoryFieldName: category.toMap(),
        accountFieldName: account.toMap(),
        costFieldName: cost,
        dateFieldName: date,
      });
    } catch (e) {
      throw CouldNotCreateUpdateExpenseException();
    }
  }

  Stream<Iterable<Expense>> allExpenses({required String ownerUserId}) =>
      expenses.snapshots().map((event) => event.docs
          .map((doc) => Expense.fromSnapshot(doc))
          .where((expense) => expense.ownerUserId == ownerUserId));

  Future<Iterable<Expense>> getExpenses({required String owenrUserId}) async {
    try {
      return await expenses
          .where(
            ownerUserIdFieldName,
            isEqualTo: owenrUserId,
          )
          .get()
          .then(
            (value) => value.docs.map(
              (doc) => Expense.fromSnapshot(doc),
            ),
          );
    } catch (e) {
      throw CouldNotGetAllExpensesException();
    }
  }

  Future<Expense> createNewExpense({required String ownerUserId}) async {
    final document = await expenses.add({
      ownerUserIdFieldName: ownerUserId,
      categoryFieldName: null,
      accountFieldName: null,
      costFieldName: 0,
      dateFieldName: null,
    });
    final fetchedExpense = await document.get();
    return Expense(
      documentId: fetchedExpense.id,
      ownerUserId: ownerUserId,
      category: null,
      account: null,
      cost: 0,
      date: DateTime.now(),
    );
  }
}
