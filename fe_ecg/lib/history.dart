import 'package:fe_ecg/constants/server.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fe_ecg/BottomNavigationBarWidget.dart';
import 'package:provider/provider.dart';
import 'package:fe_ecg/models/user.dart';

class historyscreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<historyscreen> {
  int currentIndex = 2;

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

  Map<String, Map<String, String>> progressData = {};

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

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 82, 206, 248),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              context.read<User>().updateUserName('');
              Navigator.pushNamed(context, '/login');
            },
            icon: Icon(Icons.logout, color: Colors.black),
          ),
        ],
        title: Text('Diagnosis History', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: DataTable(
            headingRowHeight: 50,
            dataRowHeight: 50,
            columns: <DataColumn>[
              DataColumn(
                label: Text('Date',
                    style: TextStyle(
                        fontWeight: FontWeight.bold)), // Add a bold heading
              ),
              DataColumn(
                label: Text('Diagnosis',
                    style: TextStyle(
                        fontWeight: FontWeight.bold)), // Add a bold heading
              ),
              DataColumn(
                label: Text('Verified',
                    style: TextStyle(
                        fontWeight: FontWeight.bold)), // Add a bold heading
              ),
            ],
            rows: progressData.entries.map((entry) {
              final Map<String, String> values = entry.value;
              final isOddRow =
                  progressData.entries.toList().indexOf(entry) % 2 == 1;

              return DataRow(
                color: (values['DoctorVeri'] == "To Be Confirm")
                    ? MaterialStateProperty.all(
                        Color.fromARGB(255, 248, 247, 243))
                    : MaterialStateProperty.all(Colors.blue),
                cells: <DataCell>[
                  DataCell(Text(values['Date'] ?? 'N/A')),
                  DataCell(Text(values['prediction'] ?? 'N/A')),
                  DataCell(Text(values['DoctorVeri'] ?? 'N/A')),
                ],
              );
            }).toList(),
          ),
        ),
      ),
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTabTapped,
      ),
    );
  }
}
