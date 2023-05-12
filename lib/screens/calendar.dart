import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:howaiu/screens/diary_entries.dart';
import 'package:howaiu/screens/left.dart';
import 'package:howaiu/screens/right.dart' as howaiu_settings;
import 'package:table_calendar/table_calendar.dart';
import 'chat.dart';

class TableCalendarPage extends StatefulWidget {
  @override
  _TableCalendarPageState createState() => _TableCalendarPageState();
}

String name = "Jerery";

class _TableCalendarPageState extends State<TableCalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  String _getFormattedDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    Color baseColor = const Color(0xffdadada);

    return Center(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
              ),
              Text(
                'howaiu',
                style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff5d7599)),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.10,
              ),
              Neumorphic(
                style: NeumorphicStyle(
                  shape: NeumorphicShape.convex,
                  boxShape: NeumorphicBoxShape.circle(),
                  depth: 8,
                  intensity: 0.7,
                  lightSource: LightSource.topLeft,
                  color: Colors.grey[300],
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.13,
                  height: MediaQuery.of(context).size.width * 0.13,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.person_2,
                    color: Color(0xff5d7599),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.08,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Neumorphic(
              style: NeumorphicStyle(
                depth: 5,
                shape: NeumorphicShape.convex,
                lightSource: LightSource.topLeft,
                intensity: 0.7,
                color: baseColor,
              ),
              child: TableCalendar(
                calendarStyle: const CalendarStyle(
                  defaultTextStyle: TextStyle(
                      color: Color(0xff5d7599)), // changes the numbers color
                  weekendTextStyle: TextStyle(
                      color: Color(
                          0xff1e2f97)), // changes the weekend numbers color
                ),
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                      color:
                          Color(0xff1e2f97)), // changes the weekday text color
                  weekendStyle: TextStyle(
                      color:
                          Color(0xff1e2f97)), // changes the weekend text color
                ),
                firstDay: DateTime.utc(2020, 01, 01),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });

                  String formattedDate = _getFormattedDate(selectedDay);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DiaryScreen(
                        formattedDate: formattedDate,
                        entry: '',
                        previousEntries: [],
                      ),
                    ),
                  );
                },
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NeumorphicButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LeftPage()),
                  );
                },
                style: NeumorphicStyle(
                  shape: NeumorphicShape.convex,
                  boxShape: const NeumorphicBoxShape.circle(),
                  depth: 8,
                  intensity: 0.7,
                  lightSource: LightSource.topLeft,
                  color: Colors.grey[300],
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.16,
                  height: MediaQuery.of(context).size.width * 0.16,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.auto_graph_sharp,
                    color: Color(0xff5d7599),
                  ),
                ),
              ),
              NeumorphicButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatAiu()),
                  );
                },
                style: NeumorphicStyle(
                  shape: NeumorphicShape.convex,
                  boxShape: NeumorphicBoxShape.circle(),
                  depth: 8,
                  intensity: 0.7,
                  lightSource: LightSource.topLeft,
                  color: Colors.grey[300],
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.26,
                  height: MediaQuery.of(context).size.width * 0.26,
                  alignment: Alignment.center,
                  child: Text('AiU',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff5d7599))),
                ),
              ),
              NeumorphicButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => howaiu_settings.Settings()),
                  );
                },
                style: NeumorphicStyle(
                  shape: NeumorphicShape.convex,
                  boxShape: NeumorphicBoxShape.circle(),
                  depth: 8,
                  intensity: 0.7,
                  lightSource: LightSource.topLeft,
                  color: Colors.grey[300],
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.16,
                  height: MediaQuery.of(context).size.width * 0.16,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.settings,
                    color: Color(0xff5d7599),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
