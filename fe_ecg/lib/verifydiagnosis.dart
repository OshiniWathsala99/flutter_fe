import 'package:fe_ecg/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fe_ecg/BottomNavigationBarWidget.dart';
import 'package:fe_ecg/declaration.dart';

class VerificationScreen extends StatelessWidget {
  final String diseaseResult;

  VerificationScreen({required this.diseaseResult});
  int currentIndex = 0;

  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure to send the verification request?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(120, 82, 207, 248),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              context.read<User>().updateUserName('');
              Navigator.pushNamed(context, '/login');
            },
            icon: Icon(Icons.logout, color: Colors.black),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return DeclarationPage();
                },
              );
            },
            icon: Icon(Icons.info, color: Colors.black),
          ),
        ],
        title: Text(
          '2-Step Verification',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: buildBody(context),
      backgroundColor: Color.fromARGB(255, 76, 218, 239),
    );
  }

  Widget buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Align(
                alignment: Alignment(0, 4),
                child: Text(
                  'Your Diagnosis Result:',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.88),
                    fontSize: 25,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    height: 1.4,
                  ),
                ),
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(top: 13),
              child: Text(
                diseaseResult,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.88),
                  fontSize: 19,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  height: 1.4,
                ),
              ),
            ),
            SizedBox(height: 100),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                'To Future Verification Send your Report to Medical Professional...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.88),
                  fontSize: 19,
                  fontFamily: 'Poppins',
                  //fontWeight: FontWeight.w700,
                  height: 1.4,
                ),
              ),
            ),
            SizedBox(height: 22),
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: ElevatedButton(
                onPressed: () async {
                  bool confirmation = await _showConfirmationDialog(context);
                  if (confirmation) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Successfully sent the verification request!'),
                      ),
                    );

                    // Navigate to the homepage
                    Navigator.of(context).pushReplacementNamed('/');
                  } else {
                    // Navigate to the homepage
                    Navigator.of(context).pushReplacementNamed('/');
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  minimumSize: Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                ),
                child: Text('Get Verified'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
