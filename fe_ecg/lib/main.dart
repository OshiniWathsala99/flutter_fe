import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:fe_ecg/app_routes.dart';
import 'package:fe_ecg/loginui.dart';
import 'package:fe_ecg/registerui.dart';
import 'package:fe_ecg/diagnosisui.dart';
import 'package:fe_ecg/homeui.dart';
import 'package:fe_ecg/cameradiagnosisui.dart';
import 'package:fe_ecg/history.dart';
import 'package:fe_ecg/verifydiagnosis.dart';
import 'package:fe_ecg/analysing.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp();
  }
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCcTCP0G1XxBIZsKr5TJPMLU9RLoisEius",
          appId: "1:871830581613:web:2bd0f7b245bbbe1a68ea64",
          messagingSenderId: "871830581613",
          projectId: "ecg-diagnosis-system"));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ECG Based Diagnosis System',
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (context) => LoginScreen(),
        AppRoutes.home: (context) => homeScreen(),
        AppRoutes.registration: (context) => RegistrationScreen(),
        AppRoutes.diagnosis: (context) =>
            DiagnosisScreen(), // Add the DiagnosisScreen route
        AppRoutes.camdiagnosis: (context) =>
            CameraDiagnosisScreen(), // Add the DiagnosisScreen route
        AppRoutes.history: (context) => historyscreen(),
        AppRoutes.verification: (context) =>
            VerificationScreen(diseaseResult: AppRoutes.analyzing),
        AppRoutes.analyzing: (context) =>
            AnalysingScreen(diseaseResult: AppRoutes.camdiagnosis),
      },
    );
  }
}
