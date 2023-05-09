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

    return Scaffold(
      backgroundColor: baseColor,
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 65,
            ),
            Text(
              "GARFIELD'S EMOTIONAL STATS",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(
              height: 125,
            ),
            // Container(
            //   width: 350,
            //   height: 350,
            //   decoration: BoxDecoration(
            //     image: DecorationImage(
            //       image: AssetImage('assets/images/stats.jpg'),
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
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
                width: 200,
                height: 50,
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
