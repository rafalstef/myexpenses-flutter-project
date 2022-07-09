import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myexpenses/services/cloud/cloud_storage_constants.dart';
import 'package:myexpenses/services/cloud/cloud_storage_exceptions.dart';

class FirebaseAppUser {
  final appUsers = FirebaseFirestore.instance.collection('user');

  Future<void> createAppUser({
    required String uid,
    required String name,
  }) async {
    final usersRef = appUsers.doc(uid);
    await usersRef.get().then((docSnapshot) => {
          if (!docSnapshot.exists)
            {
              usersRef.set({userNameFieldName: name})
            }
        });
  }

  Future<void> updateUserName({
    required documentId,
    required String name,
  }) async {
    try {
      await appUsers.doc(documentId).update({nameFieldName: name});
    } catch (e) {
      throw CouldNotCreateUpdateCategoryException();
    }
  }

  Future<String> getAppUser({required String uid}) async {
    try {
      final document = await appUsers.doc(uid).get();
      return document[userNameFieldName];
    } catch (e) {
      throw CouldNotGetUserNameExcepion();
    }
  }
}
