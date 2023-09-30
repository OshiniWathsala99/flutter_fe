import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class cameradiagnosisscreen extends StatefulWidget {
  @override
  _MyAppHomePageState createState() => _MyAppHomePageState();
}

class _MyAppHomePageState extends State<cameradiagnosisscreen> {
  File? _image; // Add ? to indicate it can be null
  String _predictedResult = "";

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

  Future Dignosis() async {
    if (_image != null) {
      final uri = Uri.parse(
          'https://c77f-112-134-168-201.ngrok-free.app/model/uploadoriginalcompatible');
      final request = http.MultipartRequest('POST', uri)
        ..files
            .add(await http.MultipartFile.fromPath('my_image', _image!.path));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        setState(() {
          _predictedResult = response.body;
        });
      }
    } else {
      setState(() {
        _predictedResult = "No image selected.";
      });
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
        title: Text('Emotion Predictor'),
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
                },
                child: Text('Diagnosis Disease'),
              ),
              Text('Diagnosis: $_predictedResult'),
            ],
          ),
        ),
      ),
    );
  }
}
