import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:http/http.dart' as http;

class AnalyticalFeedbackPage extends StatefulWidget {
  final String entry;
  final List<String> previousEntries;

  AnalyticalFeedbackPage({required this.entry, required this.previousEntries});

  @override
  _AnalyticalFeedbackPageState createState() => _AnalyticalFeedbackPageState();
}

class _AnalyticalFeedbackPageState extends State<AnalyticalFeedbackPage> {
  String analysis = '';

  @override
  void initState() {
    super.initState();
    getAnalyticalFeedback();
  }

  Future<void> getAnalyticalFeedback() async {
    await processRequest('analytical_response', widget.entry, (String value) {
      setState(() {
        analysis = value;
      });
    });
  }

  Future<void> processRequest(
      String route, String entry, Function(String) callback) async {
    // Uncomment the following lines and replace with your server logic
    // final response = await http.post(
    //   Uri.parse('http://10.0.2.2:5000/$route'),
    //   headers: {'Content-Type': 'application/json'},
    //   body: jsonEncode({'entry': entry}),
    // );

    // if (response.statusCode == 200) {
    //   callback(jsonDecode(response.body)[route]);
    // } else {
    //   callback('Error: ${response.statusCode}');
    // }

    // Mock response
    Future.delayed(Duration(seconds: 1), () {
      callback('Mock response for $route');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffdadada),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 25),
              if (analysis != '')
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
                        analysis,
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
