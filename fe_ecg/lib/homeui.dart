import 'package:flutter/material.dart';
import 'package:fe_ecg/constants/server.dart';
import 'package:fe_ecg/BottomNavigationBarWidget.dart';
import 'package:provider/provider.dart';
import 'package:fe_ecg/models/user.dart';
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
    final response = await http.get(Uri.parse(
        '${ServerConfig.serverUrl}/model/previous?name=$userName'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      Map<String, Map<String, String>> processedData = Map();
      data.forEach((key, value) {
        if (value is Map<String, dynamic>) {
          Map<String, String> innerData = Map();
          value.forEach((innerKey, innerValue) {
            if (innerValue is String) {
              innerData[innerKey] = innerValue;
            }
          });
          processedData[key] = innerData;
        }
      });

      setState(() {
        progressData = processedData;
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
        Navigator.pushReplacementNamed(context, '/camdiagnosis');
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
            backgroundColor: Colors.transparent,
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
            title: Text(
              user.userName,
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
          ),
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20,),
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(75),
                    child: Image.asset(
                      'assets/user.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Hello ${user.userName}.',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Let\'s Diagnosis your cardiovascular disease',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black45,
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/camdiagnosis');
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    minimumSize: Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                  ),
                  child: Text('Diagnosis'),
                ),
                SizedBox(height: 15),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/history');
                  },
                  style: OutlinedButton.styleFrom(
                    primary: Colors.blue,
                    minimumSize: Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                  ),
                  child: Text('Diagnosis History'),
                ),
                SizedBox(height: 16),
                Container(
                  margin: EdgeInsets.all(20),
                  width: double.infinity,
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: DataTable(
                    headingRowHeight: 50,
                    dataRowHeight: 50,
                    columns: <DataColumn>[
                      DataColumn(
                        label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Text('Diagnosis', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Text('Verified', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                    rows: progressData.entries.take(3).map((entry) {
                      final Map<String, String> values = entry.value;
                      final isOddRow = progressData.entries.toList().indexOf(entry) % 2 == 1;

                      final dateValue = values['Date']?.split(' ')[0];
                      return DataRow(
                        color: (values['DoctorVeri'] == "To Be Confirm") ? MaterialStateProperty.all(Colors.yellow) : MaterialStateProperty.all(Colors.blue),
                        cells:  <DataCell>[
                          DataCell(Text(dateValue ?? 'N/A')),
                          DataCell(
                            Text(
                              (values['prediction'] != null && values['prediction']!.length > 25)
                                  ? values['prediction']!.substring(0, 23) + "..."
                                  : values['prediction'] ?? "N/A",
                            ),
                          ),
                          DataCell(
                              Text(values['DoctorVeri'] ?? 'N/A')),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
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