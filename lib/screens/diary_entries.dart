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
import 'contextual.dart';
import 'feedback_screen.dart';

class DiaryScreen extends StatefulWidget {
  final String formattedDate;
  final String entry;
  final List<String> previousEntries;
  const DiaryScreen(
      {required this.formattedDate,
      required this.entry,
      required this.previousEntries});
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

  Future<void> getAndSummarizeData(String collectionName) async {
    print("getAndSummarizeData: collectionName = $collectionName");
    CollectionReference collection = firestore.collection(collectionName);
    QuerySnapshot querySnapshot = await collection.get();
    for (var doc in querySnapshot.docs) {
      print("getAndSummarizeData: doc = ${doc.id}");
      List<String> entries = doc.get('entries').cast<String>();
      String summary = await getSummaryFromPythonAPI(entries);
      print("getAndSummarizeData: summary = $summary");
      // create "day_summary" document
      await collection.doc('day_summary').set({'summary': summary});
      print("getAndSummarizeData: day_summary document created");
    }
  }

  Future<void> getContextToday() async {
    String startCollection = "2023-05-01";
    String today = widget.formattedDate;
    String todaySummary = "";
    int count = 0;
    DateTime start = DateTime.parse(startCollection);
    DateTime end = DateTime.parse(today);

    print("getContextToday: start = $start, end = $end");

    for (int i = 0; i <= end.difference(start).inDays; i++) {
      // Format the date for the collection name
      String collectionName =
          DateFormat('yyyy-MM-dd').format(start.add(Duration(days: i)));
      print("Checking collection: $collectionName");

      // Check if the collection exists and contains documents
      QuerySnapshot querySnapshot =
          await firestore.collection(collectionName).get();
      if (querySnapshot.size == 0) {
        print("No documents found in collection: $collectionName");
        continue;
      }

      // Try to get the 'day_summary' document from the collection
      DocumentSnapshot doc =
          await firestore.collection(collectionName).doc('day_summary').get();

      if (doc.exists) {
        // If the 'day_summary' document exists, append its summary to 'todaySummary'
        print(
            "Found existing 'day_summary' document in collection: $collectionName");
        todaySummary += doc.get('summary');
        count++; // Increment count here
      } else {
        // If the 'day_summary' document does not exist, create it and append its summary to 'todaySummary'
        print(
            "'day_summary' document does not exist in collection: $collectionName. Creating now...");
        await getAndSummarizeData(collectionName);
        DocumentSnapshot updatedDoc =
            await firestore.collection(collectionName).doc('day_summary').get();
        String newSummary = updatedDoc.get('summary');
        todaySummary += newSummary;
        count++; // Increment count here
      }
      print("Today's summary for collection $collectionName: $todaySummary");
    }

    // create "todaySummary" document
    await firestore
        .collection(today)
        .doc('todaySummary')
        .set({'contextualSummary': todaySummary});
    print("getContextToday: todaySummary document created");
  }

  Future<String> getSummaryFromPythonAPI(List<String> entries) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/summary'),
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
            SizedBox(
              height: 10,
            ),
            NeumorphicButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20.0), // you can adjust the radius here
                      ),
                      title: Text(""),
                      content: Text(
                        "You will not be able to add any journals for the day if you continue ",
                        style: TextStyle(color: Color(0xff5d7599)),
                        textAlign: TextAlign.center,
                      ),
                      actions: [
                        TextButton(
                          child: Text(
                            "Close",
                            style: TextStyle(
                                color: Color(0xff5d7599),
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text(
                            "Continue",
                            style: TextStyle(
                                color: Color(0xff5d7599),
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            getContextToday();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text(
                "Contextual",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff5d7599),
                ),
              ),
              style: NeumorphicStyle(
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                color: baseColor,
                depth: 5,
                intensity: 0.7, // Set the intensity of the button's surface
                lightSource: LightSource
                    .bottomLeft, // Set the direction of the light source
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
                          MaterialPageRoute(builder: (context) => Camera()),
                        );
                      });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
