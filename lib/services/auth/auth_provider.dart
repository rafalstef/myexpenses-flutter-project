import 'package:myexpenses/services/auth/auth_user.dart';

abstract class AuthProvider {
  Future<void> initialize();
  AuthUser? get currentUser;
  Future<AuthUser> logIn({
    required String email,
    required String password,
  });

  Future<AuthUser> createUser({
    required String email,
    required String password,
  });

  Future<void> logOut();
  Future<void> sendEmailVerification();
  Future<AuthUser> signInWithGoogle();
  Future<void> sendPasswordReset({required String toEmail});
  Future<void> createUserCollection({required String name});
}
