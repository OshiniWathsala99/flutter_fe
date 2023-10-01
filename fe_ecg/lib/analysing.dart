import 'package:flutter/material.dart';
import 'dart:io';

class AnalysingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/1.gif', // Use the correct asset path
              width: 450,
              height: 450,
              fit: BoxFit.cover,
            ),
            Text(
              'We are analyzing your ECG. Keep waiting to get your Heart Condition...',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black.withOpacity(0.88),
                fontSize: 19,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                height: 1.4, // Adjust this value for line spacing
              ),
            ),
          ],
        ),
      ),
    );
  }
}
