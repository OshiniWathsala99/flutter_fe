import 'package:firebase_auth/firebase_auth.dart';

// Function to log in a user with email and password
Future<void> loginWithEmailAndPassword(String email, String password) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    // Login successful, you can navigate to the home screen or perform other actions.
  } catch (e) {
    // Handle login failure, e.g., display an error message to the user.
    print('Login failed: $e');
  }
}
