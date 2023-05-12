import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class FeedbackPage extends StatefulWidget {
  final String entry;
  final List<String> previousEntries;

  FeedbackPage({required this.entry, required this.previousEntries});

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  String feedback = '';

  @override
  void initState() {
    super.initState();
    getFeedback();
  }

  Future<void> getFeedback() async {
    await processRequest('feedback', widget.entry, (String value) {
      setState(() {
        feedback = value;
      });
    });
  }

  Future<void> processRequest(
      String route, String entry, Function(String) callback) async {
    // Uncomment the following lines and replace with your server logic
    final response = await http.post(
      Uri.parse('http://192.168.244.88:5001/$route'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'entry': entry}),
    );
    print(response);

    if (response.statusCode == 200) {
      callback(jsonDecode(response.body)[route]);
    } else {
      callback('Error: ${response.statusCode}');
    }

    // Mock response
    // Future.delayed(Duration(seconds: 1), () {
    //   callback('Mock response for $route');
    // });
  }

  PageRouteBuilder _createCustomPageRoute(Widget destination) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => destination,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffdadada),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (feedback != '')
                SizedBox(
                  width: 350,
                  height: 450,
                  child: Neumorphic(
                    style: NeumorphicStyle(
                      depth: -5,
                      intensity: 1,
                      shape: NeumorphicShape.convex,
                      color: Color(0xffdadada),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        feedback,
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff5d7599),
                        ),
                      ),
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
