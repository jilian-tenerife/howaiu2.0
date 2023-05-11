import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
        'http://192.168.68.110:5001/find_and_recognize',
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
      appBar: AppBar(
        title: Text('Face Emotion Detector'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_emotion.isNotEmpty)
              Text(
                'Emotion: $_emotion\nConfidence: $_confidence',
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
            SizedBox(height: 30),
            ElevatedButton(
              child: Text('Take Picture'),
              onPressed: _takePicture,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              child: Text('Detect Emotion'),
              onPressed: _findAndRecognize,
            ),
          ],
        ),
      ),
    );
  }
}
