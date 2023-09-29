import 'package:firebase_auth/firebase_auth.dart';

// Function to register a user with email and password
Future<void> registerWithEmailAndPassword(String email, String password) async {
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    // Registration successful, you can navigate to the home screen or perform other actions.
  } catch (e) {
    // Handle registration failure, e.g., display an error message to the user.
    print('Registration failed: $e');
  }
}
