import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class Camera extends StatefulWidget {
  const Camera({Key? key}) : super(key: key);

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  String _emotion = '';
  double _confidence = 0.0;
  XFile? _userImage;

  Future<void> _takePicture() async {
    final imagePicker = ImagePicker();
    final image = await imagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _userImage = image;
    });
  }

  Future<void> _findAndRecognize() async {
    if (_userImage == null) {
      Fluttertoast.showToast(msg: 'Please take a picture first');
      return;
    }

    try {
      final dio = Dio();
      final userImgBytes = await _userImage!.readAsBytes();

      final userImgB64 = base64Encode(userImgBytes);

      final response = await dio.post(
        'http://172.30.1.84:5000/find_and_recognize',
        data: jsonEncode({
          'new_image': userImgB64,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['error'] != null) {
          Fluttertoast.showToast(msg: responseData['error']);
        } else {
          setState(() {
            _emotion = responseData['emotion'];
            _confidence = responseData['confidence'];
          });
        }
      }
    } on DioError catch (e) {
      Fluttertoast.showToast(msg: 'Error: ${e.response?.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffdadada),
      body: Center(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              SizedBox(height: 50),
              Text(
                'AIseeU',
                style: TextStyle(
                    color: Color(0xff5d7599),
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
              SizedBox(height: 100),
              if (_emotion.isNotEmpty)
                Neumorphic(
                  style: NeumorphicStyle(
                    shape: NeumorphicShape.concave,
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                    depth: -8,
                    intensity: 8,
                    lightSource: LightSource.topLeft,
                    color: Colors.grey[300],
                  ),
                  child: Container(
                    width: 250,
                    height: 190,
                    padding: EdgeInsets.all(16),
                    child: Text(
                      '\nEmotion: $_emotion\n\n\nConfidence: $_confidence',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: Color(0xff5d7599)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              SizedBox(height: 30),
              Container(
                width: 150,
                height: 45,
                child: NeumorphicButton(
                  onPressed: _takePicture,
                  style: NeumorphicStyle(
                    shape: NeumorphicShape.convex,
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                    depth: 8,
                    intensity: 0.7,
                    lightSource: LightSource.topLeft,
                    color: Colors.grey[300],
                  ),
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Take Picture',
                    style: TextStyle(
                      color: Color(0xff5d7599),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 25),
              Container(
                width: 150,
                height: 45,
                child: NeumorphicButton(
                  onPressed: _findAndRecognize,
                  style: NeumorphicStyle(
                    shape: NeumorphicShape.convex,
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                    depth: 8,
                    intensity: 0.7,
                    lightSource: LightSource.topLeft,
                    color: Colors.grey[300],
                  ),
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Detect Emotion',
                    style: TextStyle(
                        color: Color(0xff5d7599), fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
