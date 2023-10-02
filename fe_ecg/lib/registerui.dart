import 'package:flutter/material.dart';
import 'package:fe_ecg/registration.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegistrationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RegistrationForm(),
      ),
    );
  }
}

class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _email;
  late String _password;
  late int suc = 10;
  String errorMessage = "";
  late String _name;
  late int _age;
  late String _pre;

  Future<void> createUser() async {
    // Define the API endpoint URL
    final apiUrl =
        Uri.parse('https://1880-112-134-168-221.ngrok-free.app/user/add');

    try {
      // Create a JSON payload with the data you want to send
      final requestData = {
        "name": _name, // Replace with the actual value of _name
        "age": _age, // Replace with the actual value of _age
        "previous": _pre, // Replace with the actual value of _pre
        "email": _email, // Replace with the actual value of _email
      };

      // Send the POST request with the JSON payload
      final response = await http.post(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        // Request was successful
        print('User created successfully');
      } else {
        // Request failed
        print('Failed to create user. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that may occur
      print('An error occurred: $e');
    }
  }

// Call the createUser function to send the POST request
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: 'Full Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              } else {
                _name = value;
              }
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Age'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your age';
              } else {
                _age = int.parse(value);
              }
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Email'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              } else {
                _email = value;
              }
            },
            onSaved: (value) => _email = value!,
          ),
          TextFormField(
            decoration: InputDecoration(
                labelText: 'Known Cardiovascular Disease Status'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your current disease status';
              } else {
                _pre = value;
              }
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
            onSaved: (value) => _password = value!,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Confirm-Password'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please re-enter your password';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                final result =
                    await registerWithEmailAndPassword(_email, _password);
                setState(() {
                  suc = result;
                  if (suc == 1) {
                    createUser();
                    Navigator.pushNamed(context, '/login');
                  }
                  if (suc != 1) {
                    errorMessage = "Something Went Wrong!";
                  }
                });
              }
            },
            child: Text('Register'),
          ),
          if (errorMessage.isNotEmpty) // Display error message if not empty
            Text(
              errorMessage,
              style: TextStyle(
                color: Colors.red, // You can customize the color
              ),
            ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            child: Text('Sign in'),
          )
        ],
      ),
    );
  }
}
