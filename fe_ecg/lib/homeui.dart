// import 'package:flutter/material.dart';
// import 'package:fe_ecg/constants/server.dart';
// import 'package:fe_ecg/BottomNavigationBarWidget.dart';
// import 'package:provider/provider.dart';
// import 'package:fe_ecg/models/user.dart';
// import 'package:fe_ecg/models/record.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class homeScreen extends StatefulWidget {
//   homeScreen();

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<homeScreen> {
//   int currentIndex = 0;
//   List<TableRow> recordRows = [];
//   Map<String, Map<String, String>> progressData = {};

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   Future<void> fetchData() async {
//     final userName = context.read<User>().userName;
//     final response = await http.get(
//         Uri.parse('${ServerConfig.serverUrl}/model/previous?name=$userName'));
//     if (response.statusCode == 200) {
//       final Map<String, dynamic> data = json.decode(response.body);
//       setState(() {
//         progressData = data.map<String, Map<String, String>>((key, value) {
//           return MapEntry(key, Map<String, String>.from(value));
//         });
//       });
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }

//   void onTabTapped(int index) {
//     setState(() {
//       currentIndex = index;
//     });

//     switch (index) {
//       case 0:
//         Navigator.pushReplacementNamed(context, '/');
//         break;
//       case 1:
//         Navigator.pushReplacementNamed(context, '/camdiagnosis');
//         break;
//       case 2:
//         Navigator.pushReplacementNamed(context, '/history');
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<User>(
//       builder: (context, user, child) {
//         return Scaffold(
//           appBar: AppBar(
//             backgroundColor: Color.fromARGB(255, 82, 206, 248),
//             elevation: 0,
//             actions: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Center(
//                       child: Tooltip(
//                         message:
//                             user.userName, // Display username in the tooltip
//                         child: InkWell(
//                           onTap: () {
//                             // Handle tap on the user icon.
//                             // Add your logic here.
//                           },
//                           onHover: (isHovered) {
//                             // Handle hover event to change the appearance of the icon.
//                             // You can change the icon's color when hovered.
//                             // You can also show/hide the tooltip here.
//                             // Note: To show the tooltip, set isHovered to true.
//                             // To hide the tooltip, set isHovered to false.
//                           },
//                           child: Icon(
//                             Icons
//                                 .person, // Replace with the user icon of your choice.
//                             color: Colors.black,
//                             size: 40,
//                           ),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               IconButton(
//                 onPressed: () {
//                   context.read<User>().updateUserName('');
//                   Navigator.pushNamed(context, '/login');
//                 },
//                 icon: Icon(Icons.logout, color: Colors.black),
//               ),
//             ],
//             centerTitle: false,
//           ),
//           body: SingleChildScrollView(
//             child: Center(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   SizedBox(height: 24),
//                   Card(
//                     elevation: 3,
//                     color: Colors.blue,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: ListTile(
//                       leading: Icon(Icons.assignment,
//                           color: const Color.fromARGB(222, 255, 255, 255)),
//                       onTap: () {
//                         Navigator.pushReplacementNamed(
//                             context, '/camdiagnosis');
//                       },
//                       title: Text(
//                         'Diagnosis',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 20,
//                         ),
//                       ),
//                       trailing: Icon(
//                         Icons.arrow_forward,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 15),
//                   Card(
//                     elevation: 3,
//                     color: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: ListTile(
//                       leading: Icon(Icons.history, color: Colors.blue),
//                       onTap: () {
//                         Navigator.pushReplacementNamed(context, '/history');
//                       },
//                       title: Text(
//                         'Diagnosis History',
//                         style: TextStyle(
//                           color: Colors.blue,
//                           fontSize: 20,
//                         ),
//                       ),
//                       trailing: Icon(
//                         Icons.arrow_forward,
//                         color: Colors.blue,
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 24),
//                   Container(
//                     margin: EdgeInsets.all(20),
//                     width: double.infinity,
//                     padding: EdgeInsets.all(16.0),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(10.0),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.5),
//                           spreadRadius: 2,
//                           blurRadius: 4,
//                           offset: Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: SingleChildScrollView(
//                       // Add this SingleChildScrollView
//                       scrollDirection: Axis.horizontal,
//                       child: DataTable(
//                         headingRowHeight: 50,
//                         dataRowHeight: 50,
//                         columns: <DataColumn>[
//                           DataColumn(
//                             label: Text('Date',
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold, fontSize: 18)),
//                           ),
//                           DataColumn(
//                             label: Text('Diagnosis',
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold, fontSize: 18)),
//                           ),
//                           DataColumn(
//                             label: Text('Result',
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold, fontSize: 18)),
//                           ),
//                         ],
//                         rows: progressData.entries.take(1).map((entry) {
//                           final Map<String, String> values = entry.value;
//                           final isOddRow =
//                               progressData.entries.toList().indexOf(entry) %
//                                       2 ==
//                                   1;

//                           final dateValue = values['Date']?.split(' ')[0];
//                           return DataRow(
//                             color: (values['DoctorVeri'] == "To Be Confirm")
//                                 ? MaterialStateProperty.all(
//                                     Color.fromARGB(255, 246, 245, 240))
//                                 : MaterialStateProperty.all(
//                                     const Color.fromARGB(255, 119, 175, 221)),
//                             cells: <DataCell>[
//                               DataCell(
//                                 Text(
//                                   dateValue ?? 'N/A',
//                                   style: TextStyle(fontSize: 16),
//                                 ),
//                               ),
//                               DataCell(
//                                 Text(
//                                   (values['prediction'] != null &&
//                                           values['prediction']!.length > 25)
//                                       ? values['prediction']!.substring(0, 23) +
//                                           "..."
//                                       : values['prediction'] ?? "N/A",
//                                   style: TextStyle(fontSize: 16),
//                                 ),
//                               ),
//                               DataCell(
//                                 Text(values['DoctorVeri'] ?? 'N/A',
//                                     style: TextStyle(fontSize: 16)),
//                               ),
//                             ],
//                           );
//                         }).toList(),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           bottomNavigationBar: MyBottomNavigationBar(
//             currentIndex: currentIndex,
//             onTap: onTabTapped,
//           ),
//         );
//       },
//     );
//   }
// }

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
                        message:
                            user.userName, // Display username in the tooltip
                        child: InkWell(
                          onTap: () {
                            // Handle tap on the user icon.
                            // Add your logic here.
                          },
                          onHover: (isHovered) {
                            // Handle hover event to change the appearance of the icon.
                            // You can change the icon's color when hovered.
                            // You can also show/hide the tooltip here.
                            // Note: To show the tooltip, set isHovered to true.
                            // To hide the tooltip, set isHovered to false.
                          },
                          child: Icon(
                            Icons
                                .person, // Replace with the user icon of your choice.
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
                        Navigator.pushReplacementNamed(
                            context, '/camdiagnosis');
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
                  if (progressData
                      .isNotEmpty) // Check if there's data to display
                    Padding(
                      padding: const EdgeInsets.all(30.0), // Add padding here
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
