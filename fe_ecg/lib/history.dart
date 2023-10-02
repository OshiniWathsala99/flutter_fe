import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fe_ecg/BottomNavigationBarWidget.dart';

class historyscreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<historyscreen> {
  int currentIndex = 3;
  Map<String, Map<String, String>> progressData = {};

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

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://1880-112-134-168-221.ngrok-free.app/model/previous?name=oshini wathsala'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        // Handle dynamic types here
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: DataTable(
            columns: <DataColumn>[
              DataColumn(label: Text('Date')),
              DataColumn(label: Text('Diagnosis')),
              DataColumn(label: Text('User')),
            ],
            rows: progressData.entries.map((entry) {
              //final String user = entry.key;
              final Map<String, String> values = entry.value;
              return DataRow(
                cells: <DataCell>[
                  DataCell(Text(values['Date'] ?? 'N/A')),
                  DataCell(Text(values['prediction'] ?? 'N/A')),
                  DataCell(
                      Text(values['user'] ?? 'N/A')), // Display 'user' data
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
