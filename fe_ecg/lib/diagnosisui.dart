// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:fe_ecg/BottomNavigationBarWidget.dart';

// class DiagnosisScreen extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<DiagnosisScreen> {
//   File? _image; // Add ? to indicate it can be null
//   String _predictedResult = "";
//   int currentIndex = 0;

//   Future getImage() async {
//     final picker = ImagePicker();
//     final pickedFile =
//         await picker.pickImage(source: ImageSource.gallery); // Use pickImage

//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//       });
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
//         Navigator.pushReplacementNamed(context, '/diagnosis');
//         break;
//       case 2:
//         Navigator.pushReplacementNamed(context, '/history');
//         break;
//     }
//   }

//   Future Dignosis() async {
//     if (_image != null) {
//       final uri = Uri.parse(
//           'https://1880-112-134-168-221.ngrok-free.app/model/uploadoriginalcompatible');
//       final request = http.MultipartRequest('POST', uri)
//         ..files
//             .add(await http.MultipartFile.fromPath('my_image', _image!.path));

//       final streamedResponse = await request.send();
//       final response = await http.Response.fromStream(streamedResponse);

//       if (response.statusCode == 200) {
//         setState(() {
//           _predictedResult = response.body;
//         });
//       }
//     } else {
//       setState(() {
//         _predictedResult = "No image selected.";
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('ECG Diagnosis'),
//         ),
//         body: SingleChildScrollView(
//           child: Center(
//             child: Column(
//               children: <Widget>[
//                 _image == null
//                     ? Text('Select an image.')
//                     : Image.file(_image!,
//                         height: 200.0,
//                         width: 200.0), // Add ! to indicate it's not null
//                 ElevatedButton(
//                   onPressed: getImage,
//                   child: Text('Select Image'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () async {
//                     await Dignosis();
//                   },
//                   child: Text('Diagnosis'),
//                 ),
//                 Text('Diagnosis: $_predictedResult'),
//               ],
//             ),
//           ),
//         ),
//         bottomNavigationBar: MyBottomNavigationBar(
//           currentIndex: currentIndex,
//           onTap: onTabTapped,
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fe_ecg/BottomNavigationBarWidget.dart';

class DiagnosisScreen extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<DiagnosisScreen> {
  int currentIndex = 0;

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              title: Text('ECG Diagnosis'),
              floating: true,
              snap: true,
              pinned: true,
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Center(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(50.0),
                          child: Text(
                            'Get Ready To Diagnosis',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.88),
                              fontSize: 19,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              height: 1.4, // Adjust this value for line spacing
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(30.0), // Added padding
                          child: Text(
                            'Please Capture Lead II and Lead V ECG as two images before going to the next step...',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.88),
                              fontSize: 19,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              height: 1.4, // Adjust this value for line spacing
                            ),
                          ),
                        ),
                        SizedBox(height: 80.0), // Added bottom padding
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/camdiagnosis');
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    40.0), // Increase horizontal padding
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/camdiagnosis');
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  'Next',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
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
                                  color: Color(0xff1ecbe1), // #1ecbe1 color
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
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: MyBottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTabTapped,
        ),
      ),
    );
  }
}
