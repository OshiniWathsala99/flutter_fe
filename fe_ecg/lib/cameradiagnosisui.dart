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
import 'dart:math';
import 'package:fe_ecg/declaration.dart';

import 'package:provider/provider.dart';

class CameraDiagnosisScreen extends StatefulWidget {
  @override
  _CameraDiagnosisScreenState createState() => _CameraDiagnosisScreenState();
}

class _CameraDiagnosisScreenState extends State<CameraDiagnosisScreen> {
  List<XFile>? _images = [];
  XFile? _image;
  XFile? _image0;
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
        Navigator.pushReplacementNamed(context, '/diagnosis');
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
      _image0 = _images!.last;
    }
    if (_image != null) {
      try {
        final uri = Uri.parse(
            '${ServerConfig.serverUrl}/model/uploadoriginalcompatible');
        final request = http.MultipartRequest('POST', uri)
          ..files
              .add(await http.MultipartFile.fromPath('my_image', _image!.path));

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
              if (predictionValue == 3)
                _disease_res = "Supraventricularectopicbeat";
              if (predictionValue == 4)
                _disease_res = "Ventricular ectopic beat";
              if (predictionValue != 0 &&
                  predictionValue != 1 &&
                  predictionValue != 2 &&
                  predictionValue != 3 &&
                  predictionValue != 4) _disease_res = "Unknown beat";

              uploadPhotos(_user, _disease_res);
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

  Future<void> createRecord(String url1, String url2) async {
    final apiUrl = Uri.parse('${ServerConfig.serverUrl}/model/save');

    try {
      final requestData = {
        "user": _user,
        "prediction": _disease_res,
        "Date": _date,
        "Time": _time,
        "DoctorVeri": 'To Be Confirm',
        "img_Lead_II": url1,
        "img_Lead_VI": url2
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

  Future uploadPhotos(String username, String diagnosis) async {
    if (_images!.length >= 2) {
      final image1 = _images!.first;
      final image2 = _images![1];

      var uri = Uri.parse('${ServerConfig.serverUrl}/crosscheck/upload');
      var request = http.MultipartRequest('POST', uri);

      Random random = Random();
      double randomDouble =
          random.nextDouble(); // Generate a random double between 0.0 and 1.0

      // Add the first image
      var imageFile1 = File(image1.path);
      request.files.add(
        http.MultipartFile(
          'file1', // Use a different field name for the first image
          imageFile1.readAsBytes().asStream(),
          imageFile1.lengthSync(),
          filename: randomDouble.toString() + imageFile1.path.split('/').last,
        ),
      );

      // Add the second image
      var imageFile2 = File(image2.path);
      request.files.add(
        http.MultipartFile(
          'file2', // Use a different field name for the second image
          imageFile2.readAsBytes().asStream(),
          imageFile2.lengthSync(),
          filename: randomDouble.toString() + imageFile2.path.split('/').last,
        ),
      );

      // Add other form fields if necessary
      request.fields['username'] = username;
      request.fields['diagnosis'] = diagnosis;

      var response = await request.send();
      var responseString = await response.stream.bytesToString();
      var responseData = json.decode(responseString);

      // Access properties from the response data
      String url1 = responseData['image1_url'];
      String url2 = responseData['image2_url'];

      createRecord(url1, url2);

      if (response.statusCode == 200) {
        print('Images uploaded successfully');
      } else {
        print('Image upload failed with status code: ${response.statusCode}');
      }
    } else {
      print('Two images are required');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (context, user, child) {
        _user = user.userName; // Get the userName from the User provider
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
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return DeclarationPage(); // Show the DeclarationPage as a dialog
                    },
                  );
                },
                icon: Icon(Icons.info, color: Colors.black),
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
                    margin: EdgeInsets.only(left: 45.0, bottom: 10),
                    child: Row(
                      children: <Widget>[
                        if (_images != null && _images!.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              _getImageFromGallery();
                            },
                            child: Image.file(
                              File(_images!.first.path),
                              height: 200.0,
                              width: 200.0,
                            ),
                          ),
                        if (_images == null || _images!.isEmpty)
                          GestureDetector(
                            onTap: () {
                              _getImageFromGallery();
                            },
                            child: Padding(
                              padding: EdgeInsets.all(30.0),
                              child: Container(
                                height: 250.0,
                                width: 250.0,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color.fromARGB(255, 61, 211, 249),
                                    style: BorderStyle.solid,
                                    width: 2.0,
                                  ),
                                ),
                                child: Image.asset(
                                  'assets/Vector.png',
                                  height: 200.0,
                                  width: 200.0,
                                ),
                              ),
                            ),
                          ),
                        if (_images != null &&
                            _images!.length > 1 &&
                            _images!.length >= 3)
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
                        if (_images != null &&
                            _images!.length > 1 &&
                            _images!.length < 3)
                          Row(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _images!
                                    .getRange(1, _images!.length)
                                    .map((image) {
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
                  SizedBox(height: 10),
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
                      primary: Colors.blue,
                      minimumSize: Size(200, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 100.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey, // #1ecbe1 color
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xff1ecbe1),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
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
