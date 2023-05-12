import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContextualFeedbackPage extends StatefulWidget {
  final String formatted_date;

  ContextualFeedbackPage({required this.formatted_date});

  @override
  _ContextualFeedbackPageState createState() => _ContextualFeedbackPageState();
}

class _ContextualFeedbackPageState extends State<ContextualFeedbackPage> {
  String contextualResponse = '';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    // Fetch entries from Cloud Firestore
    FirebaseFirestore.instance
        .collection(widget.formatted_date)
        .doc('todaySummary')
        .get()
        .then((doc) {
      if (doc.exists) {
        setState(() {
          contextualResponse = doc['contextualSummary'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffdadada),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Contextual Response",
                style: TextStyle(
                    color: Color(0xff5d7599),
                    fontSize: 45,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
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
                      child: SingleChildScrollView(
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
                ),
            ],
          ),
        ),
      ),
    );
  }
}
