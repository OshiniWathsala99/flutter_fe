import 'package:flutter/material.dart';
import 'package:fe_ecg/registration.dart';

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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: 'Email'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
            onSaved: (value) => _email = value!,
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
