import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class CameraDiagnosisScreen extends StatefulWidget {
  @override
  _CameraDiagnosisScreenState createState() => _CameraDiagnosisScreenState();
}

class _CameraDiagnosisScreenState extends State<CameraDiagnosisScreen> {
  File? _image;
  String _predictedResult = "";

  Future getImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
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
      imageQuality: 100,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> diagnoseOnIsolate() async {
    if (_image != null) {
      try {
        final uri = Uri.parse(
            'https://8329-112-134-168-201.ngrok-free.app/model/uploadoriginalcompatible');
        final request = http.MultipartRequest('POST', uri)
          ..files
              .add(await http.MultipartFile.fromPath('my_image', _image!.path));

        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200) {
          final predictedResult =
              await compute(parsePredictedResult, response.body);
          setState(() {
            _predictedResult = predictedResult;
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

  // Function to perform parsing and ML model inference
  static Future<String> parsePredictedResult(String responseBody) async {
    // Parse response and run ML model inference here
    // Replace this with your actual model inference code
    await Future.delayed(Duration(seconds: 2)); // Simulating processing time
    return "Diagnosis result: $responseBody";
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
        title: Text('Emotion Predictor'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              _image == null
                  ? Text('Select an image.')
                  : Image.file(_image!, height: 200.0, width: 200.0),
              ElevatedButton(
                onPressed: () {
                  _showSelectPhotoOptions(context);
                },
                child: Text('Select Photo'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await diagnoseOnIsolate();
                },
                child: Text('Diagnose Disease'),
              ),
              Text('Diagnosis: $_predictedResult'),
            ],
          ),
        ),
      ),
    );
  }
}
