import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myexpenses/services/cloud/category/category.dart';
import 'package:myexpenses/services/cloud/cloud_storage_constants.dart';
import 'package:myexpenses/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCategory {
  final String userUid;
  final CollectionReference<Map<String, dynamic>> categories;

  FirebaseCategory({required this.userUid})
      : categories = FirebaseFirestore.instance
            .collection('user')
            .doc(userUid)
            .collection('category');

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

  Stream<Iterable<OperationCategory>> allCategories() =>
      categories.snapshots().map((event) =>
          event.docs.map((doc) => OperationCategory.fromSnapshot(doc)));

  Future<Iterable<OperationCategory>> getCategories() async {
    try {
      return await categories.get().then(
            (value) => value.docs.map(
              (doc) => OperationCategory.fromSnapshot(doc),
            ),
          );
    } catch (e) {
      throw CouldNotGetAllCategoriesException();
    }
  }

  Future<OperationCategory> createNewCategory() async {
    final document = await categories.add({
      nameFieldName: '',
      isIncomeNameField: false,
    });
    final fetchedAccount = await document.get();
    return OperationCategory(
      documentId: fetchedAccount.id,
      name: '',
      isIncome: false,
    );
  }
}
