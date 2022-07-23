import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myexpenses/enums/user_transaction_enum.dart';
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

  Future<void> createNewCategory({
    required String name,
    required bool isIncome,
    required Color color,
    required IconData icon,
  }) async {
    await categories.add({
      nameFieldName: name,
      isIncomeNameField: isIncome,
      colorFieldName: color.value,
      iconFieldName: icon.codePoint,
    });
  }

  Future<void> updateCategory({
    required String documentId,
    required String name,
    required bool isIncome,
    required Color color,
    required IconData icon,
  }) async {
    try {
      await categories.doc(documentId).update({
        nameFieldName: name,
        isIncomeNameField: isIncome,
        colorFieldName: color.value,
        iconFieldName: icon.codePoint,
      });
    } catch (e) {
      throw CouldNotCreateUpdateCategoryException();
    }
  }

  Future<void> deleteCategory({required String documentId}) async {
    try {
      await categories.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteCategoryException();
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

  Stream<Iterable<OperationCategory>> onTypeCategory({
    required UserTransaction type,
  }) {
    bool isIncome = (type == UserTransaction.income) ? true : false;
    return categories.snapshots().map((event) => event.docs
        .map((doc) => OperationCategory.fromSnapshot(doc))
        .where((element) => element.isIncome == isIncome));
  }

  Future<Iterable<OperationCategory>> oneTypeCategories({
    required UserTransaction type,
  }) async {
    bool isIncome = (type == UserTransaction.income) ? true : false;
    try {
      return await categories
          .where(
            isIncomeNameField,
            isEqualTo: isIncome,
          )
          .get()
          .then(
            (value) => value.docs.map(
              (doc) => OperationCategory.fromSnapshot(doc),
            ),
          );
    } catch (e) {
      throw CouldNotGetAllCategoriesException();
    }
  }
}
