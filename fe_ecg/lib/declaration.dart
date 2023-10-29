import 'package:flutter/material.dart';

class DeclarationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text("Declaration"),
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "     This Model Has 80% accuracy in diagnosing diseases and 90% accuracy in identifying arrhythmia absence patients. To get 100% accuracy result, please follow the 2-Step Verification as well.",
                style: TextStyle(
                  color: Colors.black.withOpacity(0.88),
                  fontSize: 15,
                  fontFamily: 'Poppins',
                  height: 1.4,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        ),
      ],
    );
  }
}
