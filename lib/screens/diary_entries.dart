import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:howaiu/screens/calendar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'feedback_screen.dart';

class DiaryScreen extends StatefulWidget {
  final String formattedDate;

  const DiaryScreen({required this.formattedDate});
  @override
  _DiaryScreenState createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  List<String> entries = [];
  TextEditingController entryController = TextEditingController();

  String _result = '';

  Future<void> processRequest(String route) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/$route'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'entry': entryController.text}),
    );

    if (response.statusCode == 200) {
      setState(() {
        _result = jsonDecode(response.body)[route];
      });
    } else {
      setState(() {
        _result = 'Error: ${response.statusCode}';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch entries from Cloud Firestore
    FirebaseFirestore.instance
        .collection(widget.formattedDate)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((doc) {
      if (doc.exists) {
        setState(() {
          entries.add(doc['entry']);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Color baseColor = const Color(0xffdadada);

    return SafeArea(
      child: Scaffold(
        backgroundColor: baseColor,
        body: Column(
          children: [
            SizedBox(
              height: 25,
            ),
            Text(
              "How was your day?",
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff5d7599)),
            ),
            SizedBox(
              height: 25,
            ),
            SizedBox(
              width: 350,
              height: 300,
              child: Neumorphic(
                style: NeumorphicStyle(
                  depth: -5,
                  intensity: 7,
                  shape: NeumorphicShape.concave,
                  color: baseColor,
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 10, left: 20),
                  child: TextField(
                    controller: entryController,
                    decoration: InputDecoration(
                      hintText: "Write your thoughts...",
                      hintStyle: TextStyle(
                        color: Color(0xff5d7599),
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            NeumorphicButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection(widget.formattedDate)
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .set({
                  'entry': entryController.text,
                });
                setState(() {
                  entries.insert(
                      0,
                      entryController
                          .text); // add new entry to the beginning of the list
                  entryController.clear();
                });
              },
              style: NeumorphicStyle(
                color: Colors.grey[300], // Set the button's background color
                depth: 8,
                intensity: 0.7,
                lightSource: LightSource.topLeft,
                shape: NeumorphicShape.convex,
              ),
              child: Text(
                'Add Entry',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff5d7599)),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(entries[index]),
                    // in the ListView.builder
                    trailing: NeumorphicButton(
                      onPressed: () {
                        // Call API and functions here
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FeedbackScreen(
                              entry: entries[index],
                              previousEntries: entries.sublist(index + 1),
                            ),
                          ),
                        );
                      },
                      style: NeumorphicStyle(
                        color: Colors
                            .grey[300], // Set the button's background color
                        depth: 8,
                        intensity: 0.7,
                        lightSource: LightSource.topLeft,
                        shape: NeumorphicShape.convex,
                      ),
                      child: Text(
                        'Feedback',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff5d7599)),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
