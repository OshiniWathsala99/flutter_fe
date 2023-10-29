import 'package:flutter/material.dart';
import 'package:fe_ecg/constants/server.dart';
import 'package:fe_ecg/BottomNavigationBarWidget.dart';
import 'package:provider/provider.dart';
import 'package:fe_ecg/models/user.dart';
import 'package:fe_ecg/declaration.dart';
import 'package:fe_ecg/models/record.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class homeScreen extends StatefulWidget {
  homeScreen();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<homeScreen> {
  int currentIndex = 0;
  List<TableRow> recordRows = [];
  Map<String, Map<String, String>> progressData = {};

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final userName = context.read<User>().userName;
    final response = await http.get(
        Uri.parse('${ServerConfig.serverUrl}/model/previous?name=$userName'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        progressData = data.map<String, Map<String, String>>((key, value) {
          return MapEntry(key, Map<String, String>.from(value));
        });
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/diagnosis');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/history');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (context, user, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 82, 206, 248),
            elevation: 0,
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Tooltip(
                        message: user.userName,
                        child: InkWell(
                          onTap: () {},
                          onHover: (isHovered) {},
                          child: Icon(
                            Icons.person,
                            color: Colors.black,
                            size: 40,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
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
            centerTitle: false,
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 24),
                  Card(
                    elevation: 3,
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.assignment,
                          color: const Color.fromARGB(222, 255, 255, 255)),
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/diagnosis');
                      },
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Diagnosis',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Card(
                    elevation: 3,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.history, color: Colors.blue),
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/history');
                      },
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Diagnosis History',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  if (progressData.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Card(
                        elevation: 4,
                        color:
                            (progressData.entries.first.value['DoctorVeri'] ==
                                    "To Be Confirm")
                                ? Color.fromARGB(255, 81, 207, 249)
                                : Color.fromARGB(255, 155, 250, 82),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Date: ${progressData.entries.first.value['Date']?.split(' ')[0] ?? 'N/A'}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Diagnosis: ${progressData.entries.first.value['prediction'] != null && progressData.entries.first.value['prediction']!.length > 25 ? progressData.entries.first.value['prediction']!.substring(0, 23) + "..." : progressData.entries.first.value['prediction'] ?? "N/A"}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          trailing: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Result: ${progressData.entries.first.value['DoctorVeri'] ?? 'N/A'}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: MyBottomNavigationBar(
            currentIndex: currentIndex,
            onTap: onTabTapped,
          ),
        );
      },
    );
  }
}
