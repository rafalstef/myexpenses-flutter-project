import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myexpenses/services/cloud/category/category.dart';
import 'package:myexpenses/services/cloud/cloud_storage_constants.dart';
import 'package:myexpenses/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCategory {
  final categories = FirebaseFirestore.instance.collection('category');

  Future<void> deleteCategory({required String documentId}) async {
    try {
      await categories.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteCategoryException();
    }
  }

  Future<void> updateCategory({
    required String documentId,
    required String name,
    required bool isIncome,
  }) async {
    try {
      await categories.doc(documentId).update({
        nameFieldName: name,
        isIncomeNameField: isIncome,
      });
    } catch (e) {
      throw CouldNotCreateUpdateCategoryException();
    }
  }

  Stream<Iterable<ExpenseCategory>> allCategories({required String ownerUserId}) =>
      categories.snapshots().map((event) => event.docs
          .map((doc) => ExpenseCategory.fromSnapshot(doc))
          .where((category) => category.ownerUserId == ownerUserId));

  Future<Iterable<ExpenseCategory>> getCategories(
      {required String ownerUserId}) async {
    try {
      return await categories
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          )
          .get()
          .then(
            (value) => value.docs.map(
              (doc) => ExpenseCategory.fromSnapshot(doc),
            ),
          );
    } catch (e) {
      throw CouldNotGetAllCategoriesException();
    }
  }

  Future<ExpenseCategory> createNewCategory({required String ownerUserId}) async {
    final document = await categories.add({
      ownerUserIdFieldName: ownerUserId,
      nameFieldName: '',
      isIncomeNameField: false,
    });
    final fetchedAccount = await document.get();
    return ExpenseCategory(
      documentId: fetchedAccount.id,
      ownerUserId: ownerUserId,
      name: '',
      isIncome: false,
    );
  }
}
