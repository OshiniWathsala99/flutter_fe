//

import 'package:firebase_auth/firebase_auth.dart';

// Custom error codes
const int loginSuccess = 1;
const int invalidEmailPassword = 2;
const int userNotFound = 3;
const int accountDisabled = 4;
const int unknownError = 5;

Future<int> loginWithEmailAndPassword(String email, String password) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    // Login successful, return success code.
    return loginSuccess;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'invalid-email' || e.code == 'wrong-password') {
      // Invalid email or password.
      return invalidEmailPassword;
    } else if (e.code == 'user-not-found') {
      // User not found.
      return userNotFound;
    } else if (e.code == 'user-disabled') {
      // User account is disabled.
      return accountDisabled;
    } else {
      // Handle other errors here.
      return unknownError;
    }
  } catch (e) {
    // Handle any other exceptions here.
    return unknownError;
  }
}
