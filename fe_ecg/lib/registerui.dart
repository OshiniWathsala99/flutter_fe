import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fe_ecg/registration.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegistrationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: RegistrationForm(),
        ),
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
        Uri.parse('https://e2c3-112-134-175-95.ngrok-free.app/user/add');

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
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 5),
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(75),
                child: Image.asset(
                  'assets/logo.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Register',
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.blue,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                } else {
                  _name = value;
                }
              },
            ),
            SizedBox(height: 5),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Age',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.blue,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your age';
                } else {
                  _age = int.parse(value);
                }
              },
            ),
            SizedBox(height: 5),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.blue,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                } else {
                  _email = value;
                }
              },
            ),
            SizedBox(height: 5),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Known Cardiovascular Disease Status',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.blue,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your current disease status';
                } else {
                  _pre = value;
                }
              },
            ),
            SizedBox(height: 5),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.blue,
                  ),
                ),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
              onSaved: (value) => _password = value!,
            ),
            SizedBox(height: 5),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Confirm-Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.blue,
                  ),
                ),
              ),
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
                  final result = await registerWithEmailAndPassword(_email, _password);
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
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0), // No rounded corners
                ), // Set the button's height
                minimumSize: Size(double.infinity, 50), // Make it full width
              ),
              child: Text('Register'),
            ),
            if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            SizedBox(height: 16),
            Row(children: <Widget>[
              Expanded(child: Divider(color: Colors.black)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('or'),
              ),
              Expanded(child: Divider(color: Colors.black)),
            ]),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.favorite,
                  color: Colors.black,
                ),
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                        text: "Already have an account?",
                        style: TextStyle(
                          color: Colors.black45,
                        ),
                      ),
                      TextSpan(text: ' '),
                      TextSpan(
                        text: 'Sign In',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context, '/login');
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),

          ],
        ),
      )
    );
  }
}
