import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ContextualFeedbackPage extends StatefulWidget {
  final String formatted_date;

  ContextualFeedbackPage({required this.formatted_date});

  @override
  _ContextualFeedbackPageState createState() => _ContextualFeedbackPageState();
}

class _ContextualFeedbackPageState extends State<ContextualFeedbackPage> {
  String contextualResponse = '';

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
