class AppFormsValidator {
  AppFormsValidator._();

  static final RegExp _emailRegExp = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  static String? validateLoginEmail({required String? email}) {
    if (email == null || !_emailRegExp.hasMatch(email)) {
      return 'Please enter your email address.';
    }
    return null;
  }

  static String? validateRegisterEmail({required String? email}) {
    if (email != null) {
      if (email.isEmpty) {
        return "Email can't be empty";
      } else if (!_emailRegExp.hasMatch(email)) {
        return 'Please enter correct email address.';
      }
    }
    return null;
  }

  static String? validateLoginPassword({required String? password}) {
    if (password == null || password.length < 6) {
      return 'Please enter your password.';
    }
    return null;
  }

  static String? validateRegisterPassword({required String? password}) {
    if (password != null) {
      if (password.isEmpty) {
        return "Password can't be empty";
      } else if (password.length < 6) {
        return 'Password is too short.';
      }
    }
    return null;
  }
}
