import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'chat.dart';

class LeftPage extends StatefulWidget {
  @override
  _LeftPageState createState() => _LeftPageState();
}

class _LeftPageState extends State<LeftPage> {
  @override
  Widget build(BuildContext context) {
    Color baseColor = const Color(0xffdadada);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: baseColor,
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.08,
            ),
            Text(
              "GARFIELD'S EMOTIONAL STATS",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff5d7599)),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: screenHeight * 0.15,
            ),
            Container(
              width: screenWidth * 0.85, // adjust the value as needed
              height: screenHeight * 0.4,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/stats.png'),
                  fit: BoxFit.cover,
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
                depth: 8,
                intensity: 0.7,
                lightSource: LightSource.topLeft,
                color: Colors.grey[300],
              ),
              child: Container(
                width: screenWidth * 0.5, // adjust the value as needed
                height: screenHeight * 0.075,
                alignment: Alignment.center,
                child: Text('Chat AiU',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff5d7599))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
