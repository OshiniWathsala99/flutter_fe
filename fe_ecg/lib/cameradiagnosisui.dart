// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'dart:convert';
// import 'package:fe_ecg/BottomNavigationBarWidget.dart';
// import 'package:fe_ecg/analysing.dart';
// import 'package:http_parser/http_parser.dart';
// import 'dart:typed_data';

// class CameraDiagnosisScreen extends StatefulWidget {
//   @override
//   _CameraDiagnosisScreenState createState() => _CameraDiagnosisScreenState();
// }

// class _CameraDiagnosisScreenState extends State<CameraDiagnosisScreen> {
//   List<XFile> _images = []; // List to store selected images
//   String _predictedResult = "";
//   String _date = "";
//   String _time = "";
//   String _user = "oshini wathsala";
//   String _disease_res = "";
//   int currentIndex = 3;

//   void onTabTapped(int index) {
//     setState(() {
//       currentIndex = index;
//     });

//     // Handle navigation based on the selected index
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

//   String getCurrentTime() {
//     DateTime now = DateTime.now();

//     // Extract time components
//     int hour = now.hour;
//     int minute = now.minute;
//     int second = now.second;

//     return '$hour:$minute:$second'; // Prints the current time in "hh:mm:ss" format
//   }

//   String getCurrentDate() {
//     DateTime now = DateTime.now();
//     String date = "";

//     // Extract date components
//     int year = now.year;
//     int month = now.month;
//     int day = now.day;

//     // Create a new DateTime object with just the date
//     DateTime currentDate = DateTime(year, month, day);
//     date = currentDate.toString();

//     return date;
//   }

// void _getImageFromGallery() async {
//     final picker = ImagePicker();
//     final pickedFiles = await picker.pickMultiImage(
//       maxWidth: 800, // Set the maximum width for selected images
//       imageQuality: 100, // Set image quality to 100 (no compression)
//     );

//     if (pickedFiles != null) {
//       setState(() {
//         _images.clear();
//         _images.addAll(pickedFiles);
//       });
//     }
//   }

//   Future<void> Dignosis() async {
//     if (_image != null) {
//       try {
//         final uri = Uri.parse(
//             'https://e2c3-112-134-175-95.ngrok-free.app/model/uploadoriginalcompatible');
//         final request = http.MultipartRequest('POST', uri)
//           ..files
//               .add(await http.MultipartFile.fromPath('my_image', _image!.path));

//         final streamedResponse = await request.send();
//         final response = await http.Response.fromStream(streamedResponse);

//         if (response.statusCode == 200) {
//           setState(() {
//             _date = getCurrentDate();
//             _time = getCurrentTime();
//             _predictedResult = response.body;
//             final jsonResponse =
//                 jsonDecode(_predictedResult); // Parse the JSON response

//             if (jsonResponse.containsKey("prediction")) {
//               final predictionValue = jsonResponse["prediction"];
//               if (predictionValue == 0) _disease_res = "Fusion beat";
//               if (predictionValue == 1) _disease_res = "Normal beat";
//               if (predictionValue == 2) _disease_res = "Unknown beat";
//               if (predictionValue == 3)
//                 _disease_res = "Supraventricularectopicbeat";
//               if (predictionValue == 4)
//                 _disease_res = "Ventricular ectopic beat";
//               if (predictionValue != 0 &&
//                   predictionValue != 1 &&
//                   predictionValue != 2 &&
//                   predictionValue != 3 &&
//                   predictionValue != 4) _disease_res = "Unknown beat";

//               createRecord();
//               uploadPhoto(_user, _disease_res);
//             }
//           });
//         }
//       } catch (e) {
//         setState(() {
//           _predictedResult = "Error: $e";
//         });
//       }
//     } else {
//       setState(() {
//         _predictedResult = "No image selected.";
//       });
//     }
//   }

//   Future<void> createRecord() async {
//     // Define the API endpoint URL
//     final apiUrl =
//         Uri.parse('https://e2c3-112-134-175-95.ngrok-free.app/model/save');

//     try {
//       // Create a JSON payload with the data you want to send
//       final requestData = {
//         // Replace with the data you want to send
//         "user": _user,
//         "prediction": _disease_res,
//         "Date": _date,
//         "Time": _time,
//         "DoctorVeri": 'To Be Confirm'
//       };

//       // Send the POST request with the JSON payload
//       final response = await http.post(
//         apiUrl,
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode(requestData),
//       );

//       if (response.statusCode == 200) {
//         // Request was successful
//         print('Record created successfully');
//       } else {
//         // Request failed
//         print('Failed to create record. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       // Handle any exceptions that may occur
//       print('An error occurred: $e');
//     }
//   }

//   Future uploadPhoto(String username, String dignosis) async {
//     if (_image != null) {
//       // Encode the username and emotion parameters
//       final encodedUsername = Uri.encodeComponent(username);
//       final encodedEmotion = Uri.encodeComponent(dignosis);

//       var request = http.MultipartRequest(
//         'POST',
//         Uri.parse(
//             'https://e2c3-112-134-175-95.ngrok-free.app/crosscheck/upload/$username/$dignosis'),
//       );

//       request.files.add(
//         http.MultipartFile(
//           'file',
//           _image!.readAsBytes().asStream(),
//           _image!.lengthSync(),
//           filename: _image!.path.split('/').last,
//         ),
//       );

//       var response = await request.send();

//       if (response.statusCode == 200) {
//         // Image uploaded successfully
//         print('Image uploaded successfully');
//       } else {
//         // Handle the error
//         print('Image upload failed');
//       }
//     } else {
//       // Handle the case where no image is selected
//       print('No image selected');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Cardiovascular Detection'),
//       ),
//       body: SingleChildScrollView(
//         child: Center(
//           child: Column(
//             children: <Widget>[
//               Column(
//                 children: _images.map((image) {
//                   return Image.file(
//                     File(image.path),
//                     height: 200.0,
//                     width: 200.0,
//                   );
//                 }).toList(),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   _getImageFromGallery();
//                 },
//                 child: Text('Select Photos'),
//               ),
//               ElevatedButton(
//                 onPressed: () async {
//                   await Dignosis();

//                   // Check if _disease_res is not empty before navigating
//                   if (_disease_res.isNotEmpty) {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => AnalysingScreen(
//                           diseaseResult: _disease_res,
//                         ),
//                       ),
//                     );
//                   }
//                 },
//                 child: Text('Diagnosis Disease'),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.pushReplacementNamed(context, '/verify');
//                 },
//                 child: Text('Further Verification'),
//               ),
//               //Text('Diagnosis: $_disease_res'),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: MyBottomNavigationBar(
//         currentIndex: currentIndex,
//         onTap: onTabTapped,
//       ),
//     );
//   }
//  }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:fe_ecg/BottomNavigationBarWidget.dart';
import 'package:fe_ecg/analysing.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:typed_data';

class CameraDiagnosisScreen extends StatefulWidget {
  @override
  _CameraDiagnosisScreenState createState() => _CameraDiagnosisScreenState();
}

class _CameraDiagnosisScreenState extends State<CameraDiagnosisScreen> {
  List<XFile>? _images = []; // List to store selected images
  XFile? _image;
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

  void _getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage(
      maxWidth: 800, // Set the maximum width for selected images
      imageQuality: 100, // Set image quality to 100 (no compression)
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
        final uri = Uri.parse(
            'https://9970-112-134-172-217.ngrok-free.app/model/uploadoriginalcompatible');
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
                _disease_res = "Supraventricularectopicbeat";
              if (predictionValue == 4)
                _disease_res = "Ventricular ectopic beat";
              if (predictionValue != 0 &&
                  predictionValue != 1 &&
                  predictionValue != 2 &&
                  predictionValue != 3 &&
                  predictionValue != 4) _disease_res = "Unknown beat";

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
    // Define the API endpoint URL
    final apiUrl =
        Uri.parse('https://9970-112-134-172-217.ngrok-free.app/model/save');

    try {
      // Create a JSON payload with the data you want to send
      final requestData = {
        // Replace with the data you want to send
        "user": _user,
        "prediction": _disease_res,
        "Date": _date,
        "Time": _time,
        "DoctorVeri": 'To Be Confirm'
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

  Future uploadPhoto(String username, String dignosis) async {
    if (_images!.isNotEmpty) {
      _image = _images!.first;
    }
    if (_image != null) {
      // Encode the username and emotion parameters
      final encodedUsername = Uri.encodeComponent(username);
      final encodedDiagnosis = Uri.encodeComponent(dignosis);

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://9970-112-134-172-217.ngrok-free.app/crosscheck/upload/$username/$dignosis'),
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
        // Image uploaded successfully
        print('Image uploaded successfully');
      } else {
        // Handle the error
        print('Image upload failed');
      }
    } else {
      // Handle the case where no image is selected
      print('No image selected');
    }
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
              Column(
                children: _images!.map((image) {
                  return Image.file(
                    File(image.path),
                    height: 200.0,
                    width: 200.0,
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: () {
                  _getImageFromGallery();
                },
                child: Text('Select Photos'),
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
