import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:howaiu/screens/calendar.dart';
import 'package:howaiu/screens/camera.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/custom.dart';
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
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String _result = '';

  Future<void> processRequest(String route) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/$route'),
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

  void getAndSummarizeData() async {
    print("hoy");
    String collectionName = DateFormat('yyyy-MM-dd').format(DateTime.now());
    CollectionReference collection = firestore.collection(collectionName);
    print(collection);
    print("err");
    QuerySnapshot querySnapshot = await collection.get();
    print("daw bi");
    print(collection.get());
    print("oi!");
    for (var doc in querySnapshot.docs) {
      print("hoy");
      List<String> entries = doc.get('entries').cast<String>();
      String summary = await getSummaryFromPythonAPI(entries);
      print(summary);
      print("ey");
      // create "day_summary" document
      await collection.doc('day_summary').set({'summary': summary});
    }
  }

  Future<String> getSummaryFromPythonAPI(List<String> entries) async {
    final response = await http.post(
      Uri.parse('http://localhost:5000/summary'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'all_entries': entries,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['contextual_response'];
    } else {
      throw Exception('Failed to load summary');
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
          entries = List<String>.from(doc['entries'] as List<dynamic>);
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
            body: Column(children: [
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
                  entries.insert(
                      0,
                      entryController
                          .text); // add new entry to the beginning of the list
                  FirebaseFirestore.instance
                      .collection(widget.formattedDate)
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .set({
                    'entries': entries,
                  });
                  setState(() {
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
              NeumorphicButton(
                onPressed: () {
                  getAndSummarizeData();
                },
                style: NeumorphicStyle(
                  color: Colors.grey[300], // Set the button's background color
                  depth: 8,
                  intensity: 0.7,
                  lightSource: LightSource.topLeft,
                  shape: NeumorphicShape.convex,
                ),
                child: Text(
                  'Get Summary',
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
                        return CustomTile(
                            text: entries[index],
                            onFeedbackTap: () {
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
                            onOtherTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Camera()));
                            });
                      }))
            ])));
  }
}
