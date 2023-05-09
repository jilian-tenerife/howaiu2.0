import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';

class DiaryEntriesPage extends StatefulWidget {
  @override
  _DiaryEntriesPageState createState() => _DiaryEntriesPageState();
}

class DiaryEntry {
  final String content;
  final DateTime date;

  DiaryEntry({required this.content, required this.date});
}

class _DiaryEntriesPageState extends State<DiaryEntriesPage> {
  List<DiaryEntry> diaryEntries = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  void addDiaryEntry() {
    setState(() {
      diaryEntries.add(
        DiaryEntry(
          content: contentController.text,
          date: DateTime.now(),
        ),
      );
      titleController.clear();
      contentController.clear();
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
              style: TextStyle(fontSize: 34),
            ),
            SizedBox(
              height: 25,
            ),
            SizedBox(
              width: 350,
              height: 300,
              child: Neumorphic(
                style: NeumorphicStyle(
                  depth: 5,
                  shape: NeumorphicShape.convex,
                  lightSource: LightSource.topLeft,
                  intensity: 0.7,
                  color: baseColor,
                ),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: TextField(
                    controller: contentController,
                    decoration: InputDecoration(
                      hintText: "Write your thoughts...",
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
            SizedBox(
              width: 300,
              height: 50,
              child: NeumorphicButton(
                onPressed: addDiaryEntry,
                style: NeumorphicStyle(
                  color: baseColor, // Set the button's background color
                  depth: 5, // Set the depth of the button's shadow
                  shape: NeumorphicShape.convex,
                ),
                child: Center(
                  child: Text(
                    'Add Entry', // Set the text of the button
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color:
                            Color(0xff5d7599)), // Set the font size of the text
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: diaryEntries.length,
                itemBuilder: (context, index) {
                  final entry = diaryEntries[index];
                  return ListTile(
                    subtitle: Text(entry.content),
                    trailing:
                        Text(DateFormat('MM/dd/yyyy HH:mm').format(entry.date)),
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
