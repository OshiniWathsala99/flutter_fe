import 'package:flutter/material.dart';
import 'package:fe_ecg/BottomNavigationBarWidget.dart';

class homeScreen extends StatefulWidget {
  //final String userName = "John"; // Retrieve this from Firebase
  String userName = "John";

  //HomePage(this.userName);
  homeScreen();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<homeScreen> {
  int currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });

    // Handle navigation based on the selected index
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/camdiagnosis');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/history');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Hello ${widget.userName}'), // Display the user's name
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Let\'s Diagnosis your cardiovascular disease',
              textAlign: TextAlign.center,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/camdiagnosis');
            },
            child: Text('Diagnosis'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/history');
            },
            child: Text('Diagnosis History'),
          ),
        ],
      ),
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTabTapped,
      ),
    );
  }
}
