import 'package:fe_ecg/models/user.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fe_ecg/login.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(// Width of the form container
          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 50),

          child: LoginForm(),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _email;
  late String _password;
  late int suc = 10;
  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
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
              'Login',
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
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
                }
                return null;
              },
              onSaved: (value) => _email = value!,
            ),
            SizedBox(height: 20),
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
            SizedBox(height: 16),
            Container(
              width: double.infinity, // Full width
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final result = await loginWithEmailAndPassword(_email, _password);
                    setState(() {
                      suc = result;
                      if (suc == 1) {
                        context.read<User>().updateUserName(_email);
                        Navigator.pushNamed(context, '/');
                      }
                      if (suc != 1) {
                        errorMessage = "Something Went Wrong!";
                      }
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue, // Blue background
                  minimumSize: Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0), // Rectangle with sharp corners
                  ),
                ),
                child: Text('Login'),
              ),
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
                        text: " Don't have an account?",
                        style: TextStyle(
                          color: Colors.black45,
                        ),
                      ),
                      TextSpan(text: ' '),
                      TextSpan(
                        text: 'Sign Up',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context, '/registration');
                          },
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      )
    );
  }
}
