import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:fe_ecg/BottomNavigationBarWidget.dart';
import 'package:fe_ecg/analysing.dart';

class cameradiagnosisscreen extends StatefulWidget {
  @override
  _MyAppHomePageState createState() => _MyAppHomePageState();
}

class _MyAppHomePageState extends State<cameradiagnosisscreen> {
  File? _image; // Add ? to indicate it can be null
  String _predictedResult = "";
  String _date = "";
  String _time = "";
  String _user = "oshini wathsala";
  String _disease_res = "";
  int currentIndex = 3;

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

  String getCurrentTime() {
    DateTime now = DateTime.now();

    // Extract time components
    int hour = now.hour;
    int minute = now.minute;
    int second = now.second;

    return '$hour:$minute:$second'; // Prints the current time in "hh:mm:ss" format
  }

  String getCurrentDate() {
    DateTime now = DateTime.now();
    String date = "";

    // Extract date components
    int year = now.year;
    int month = now.month;
    int day = now.day;

    // Create a new DateTime object with just the date
    DateTime currentDate = DateTime(year, month, day);
    date = currentDate.toString();

    return date;
  }

  Future getImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 100, // Set image quality to 100 (no compression)
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100, // Set image quality to 100 (no compression)
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> Dignosis() async {
    if (_image != null) {
      try {
        final uri = Uri.parse(
            'https://1880-112-134-168-221.ngrok-free.app/model/uploadoriginalcompatible');
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
            final jsonResponse =
                jsonDecode(_predictedResult); // Parse the JSON response

            if (jsonResponse.containsKey("prediction")) {
              final predictionValue = jsonResponse["prediction"];
              if (predictionValue == 0) _disease_res = "Fusion beat";
              if (predictionValue == 1) _disease_res = "Normal beat";
              if (predictionValue == 2) _disease_res = "Unknown beat";
              if (predictionValue == 3)
                _disease_res = "Supraventricular ectopic beat";
              if (predictionValue == 4)
                _disease_res = "Ventricular ectopic beat";
              if (predictionValue != 0 &&
                  predictionValue != 1 &&
                  predictionValue != 2 &&
                  predictionValue != 3 &&
                  predictionValue != 4) _disease_res = "Unknown beat";

              createRecord();
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
    // Define the API endpoint URL
    final apiUrl =
        Uri.parse('https://1880-112-134-168-221.ngrok-free.app/model/save');

    try {
      // Create a JSON payload with the data you want to send
      final requestData = {
        // Replace with the data you want to send
        "user": _user,
        "prediction": _disease_res,
        "Date": _date,
        "Time": _time
      };

      // Send the POST request with the JSON payload
      final response = await http.post(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        // Request was successful
        print('Record created successfully');
      } else {
        // Request failed
        print('Failed to create record. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that may occur
      print('An error occurred: $e');
    }
  }

  void _showSelectPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('Take a Photo'),
                onTap: () {
                  getImageFromCamera();
                  Navigator.pop(context); // Close the bottom sheet
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choose from Gallery'),
                onTap: () {
                  getImageFromGallery();
                  Navigator.pop(context); // Close the bottom sheet
                },
              ),
              Divider(),
              ListTile(
                title: Text('Cancel'),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cardiovascular Detection'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              _image == null
                  ? Text('Select an image.')
                  : Image.file(_image!,
                      height: 200.0,
                      width: 200.0), // Add ! to indicate it's not null
              ElevatedButton(
                onPressed: () {
                  _showSelectPhotoOptions(
                      context); // Show the options for selecting photos
                },
                child: Text('Select Photo'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await Dignosis();

                  // Check if _disease_res is not empty before navigating
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
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/verify');
                },
                child: Text('Further Verification'),
              ),
              //Text('Diagnosis: $_disease_res'),
            ],
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
//verification