import 'dart:io';
import 'package:fe_ecg/constants/server.dart';
import 'package:fe_ecg/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:fe_ecg/BottomNavigationBarWidget.dart';
import 'package:fe_ecg/analysing.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:typed_data';

import 'package:provider/provider.dart';

class CameraDiagnosisScreen extends StatefulWidget {
  @override
  _CameraDiagnosisScreenState createState() => _CameraDiagnosisScreenState();
}

class _CameraDiagnosisScreenState extends State<CameraDiagnosisScreen> {
  List<XFile>? _images = [];
  XFile? _image;
  String _predictedResult = "";
  String _date = "";
  String _time = "";
  String _user = "";
  String _disease_res = "";
  int currentIndex = 1;

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

  String getCurrentTime() {
    DateTime now = DateTime.now();
    int hour = now.hour;
    int minute = now.minute;
    int second = now.second;
    return '$hour:$minute:$second';
  }

  String getCurrentDate() {
    DateTime now = DateTime.now();
    String date = "";
    int year = now.year;
    int month = now.month;
    int day = now.day;
    DateTime currentDate = DateTime(year, month, day);
    date = currentDate.toString();
    return date;
  }

  void _getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage(
      maxWidth: 800,
      imageQuality: 100,
    );

    if (pickedFiles != null) {
      setState(() {
        _images!.clear();
        _images!.addAll(pickedFiles);
      });
    }
  }

  Future<void> Dignosis() async {
    if (_images!.isNotEmpty) {
      _image = _images!.first;
    }
    if (_image != null) {
      try {
        final uri = Uri.parse('${ServerConfig.serverUrl}/model/uploadoriginalcompatible');
        final request = http.MultipartRequest('POST', uri)
          ..files.add(await http.MultipartFile.fromPath('my_image', _image!.path));

        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200) {
          setState(() {
            _date = getCurrentDate();
            _time = getCurrentTime();
            _predictedResult = response.body;
            final jsonResponse = jsonDecode(_predictedResult);

            if (jsonResponse.containsKey("prediction")) {
              final predictionValue = jsonResponse["prediction"];
              if (predictionValue == 0) _disease_res = "Fusion beat";
              if (predictionValue == 1) _disease_res = "Normal beat";
              if (predictionValue == 2) _disease_res = "Unknown beat";
              if (predictionValue == 3) _disease_res = "Supraventricularectopicbeat";
              if (predictionValue == 4) _disease_res = "Ventricular ectopic beat";
              if (predictionValue != 0 && predictionValue != 1 && predictionValue != 2 && predictionValue != 3 && predictionValue != 4)
                _disease_res = "Unknown beat";

              createRecord();
              uploadPhoto(_user, _disease_res);
            }
          });
        }
      } catch (e) {
        setState(() {
          _predictedResult = "Error: $e";
        });
      }
    } else {
      setState(() {
        _predictedResult = "No image selected.";
      });
    }
  }

  Future<void> createRecord() async {
    final apiUrl = Uri.parse('${ServerConfig.serverUrl}/model/save');

    try {
      // [TAG]
      final requestData = {
        "user": _user,
        "prediction": _disease_res,
        "Date": _date,
        "Time": _time,
        "DoctorVeri": 'To Be Confirm'
      };

      final response = await http.post(
        apiUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        print('Record created successfully');
      } else {
        print('Failed to create record. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  Future uploadPhoto(String username, String dignosis) async {
    if (_images!.isNotEmpty) {
      _image = _images!.first;
    }
    if (_image != null) {
      final encodedUsername = Uri.encodeComponent(username);
      final encodedDiagnosis = Uri.encodeComponent(dignosis);

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ServerConfig.serverUrl}/crosscheck/upload/$username/$dignosis'),
      );

      File file = File(_image!.path);
      request.files.add(
        http.MultipartFile(
          'file',
          _image!.readAsBytes().asStream(),
          file.lengthSync(),
          filename: _image!.path.split('/').last,
        ),
      );

      var response = await request.send();

      if (response.statusCode == 200) {
        print('Image uploaded successfully');
      } else {
        print('Image upload failed');
      }
    } else {
      print('No image selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (context, user, child) {
        _user = user.userName; // Get the userName from the User provider
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
              'Cardiovascular Detection',
              style: TextStyle(color: Colors.black),
            ),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 45.0, bottom: 10), // Add margin here
                    child: Row(
                      children: <Widget>[

                        _images != null && _images!.isNotEmpty
                            ? Image.file(
                          File(_images!.first.path),
                          height: 200.0,
                          width: 200.0,
                        )
                            : Container(
                          margin: EdgeInsets.only(left: 50.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blueAccent, // Border color
                              width: 2.0, // Border width
                            ),
                          ),
                          child: Image.asset(
                            'assets/logo.jpg', // Replace with the path to your placeholder image
                            height: 200.0,
                            width: 200.0,
                          ),
                        ),
                        if (_images != null && _images!.length > 1 && _images!.length >= 3)
                          Row(
                            children: <Widget>[
                              Column(
                                children: _images!.getRange(1, 3).map((image) {
                                  return Image.file(
                                    File(image.path),
                                    height: 100.0,
                                    width: 100.0,
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        if (_images != null && _images!.length > 1 && _images!.length < 3)
                          Row(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _images!.getRange(1, _images!.length).map((image) {
                                  return Image.file(
                                    File(image.path),
                                    height: 100.0,
                                    width: 100.0,
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _getImageFromGallery();
                    },
                    child: Text('Select Photos'),
                  ),
                  SizedBox(height: 10),
                  if (_images!.isNotEmpty) Text(
                    'Files Count: ${_images!.length}',
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(height: 10),
                  if (_images!.isNotEmpty)
                    ElevatedButton(
                    onPressed: () async {
                      await Dignosis();

                      if (_disease_res.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AnalysingScreen(
                              diseaseResult: _disease_res,
                            ),
                          ),
                        );
                      }
                    },
                    child: Text('Diagnosis Disease'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue, // Blue background
                      minimumSize: Size(200, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0), // Round corners
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
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


