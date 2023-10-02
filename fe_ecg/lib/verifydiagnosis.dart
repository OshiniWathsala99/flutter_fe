import 'package:flutter/material.dart';

class VerificationScreen extends StatelessWidget {
  final String diseaseResult; // Add this field

  VerificationScreen({required this.diseaseResult}); // Update the constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Diagnosis Result from Previous Screen:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              diseaseResult, // Display the disease result
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            // Add your verification UI components here
          ],
        ),
      ),
    );
  }
}
