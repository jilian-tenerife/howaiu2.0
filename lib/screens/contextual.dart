import 'package:flutter/material.dart';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ContextualFeedbackPage extends StatefulWidget {
  final String entry;
  final List<String> previousEntries;

  ContextualFeedbackPage({required this.entry, required this.previousEntries});

  @override
  _ContextualFeedbackPageState createState() => _ContextualFeedbackPageState();
}

class _ContextualFeedbackPageState extends State<ContextualFeedbackPage> {
  String contextualResponse = '';

  @override
  void initState() {
    super.initState();
    getContextualFeedback();
  }

  Future<void> getContextualFeedback() async {
    await processRequest('contextual_response', widget.entry, (String value) {
      if (mounted) {
        setState(() {
          contextualResponse = value;
        });
      }
    });
  }

  Future<void> processRequest(
      String route, String entry, Function(String) callback) async {
    // Uncomment the following lines and replace with your server logic
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/$route'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'entry': entry}),
    );

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
              if (contextualResponse != '')
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
                        contextualResponse,
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
