import 'package:flutter/material.dart';
import 'dart:io';
import 'package:fe_ecg/verifydiagnosis.dart';

class AnalysingScreen extends StatefulWidget {
  final String diseaseResult;

  AnalysingScreen({required this.diseaseResult});

  @override
  _AnalysingScreenState createState() => _AnalysingScreenState();
}

class _AnalysingScreenState extends State<AnalysingScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 10), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerificationScreen(
            diseaseResult: widget.diseaseResult,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/1.gif',
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
                height: 1.4,
              ),
            ),

          ],
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';

// import 'dart:io';

// class AnalysingScreen extends StatelessWidget {
//   final String diseaseResult; // Add this field

//   AnalysingScreen({required this.diseaseResult}); // Update the constructor

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               'assets/1.gif', // Use the correct asset path
//               width: 450,
//               height: 450,
//               fit: BoxFit.cover,
//             ),
//             Text(
//               'We are analyzing your ECG. Keep waiting to get your Heart Condition...',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Colors.black.withOpacity(0.88),
//                 fontSize: 19,
//                 fontFamily: 'Poppins',
//                 fontWeight: FontWeight.w700,
//                 height: 1.4, // Adjust this value for line spacing
//               ),
//             ),
//             Text(
//               'Diagnosis Result: $diseaseResult', // Display the disease result
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Colors.black.withOpacity(0.88),
//                 fontSize: 19,
//                 fontFamily: 'Poppins',
//                 fontWeight: FontWeight.w700,
//                 height: 1.4, // Adjust this value for line spacing
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
