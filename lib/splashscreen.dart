import 'package:flutter/material.dart';
import 'package:howaiu/screens/login.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    });

    return Scaffold(
      backgroundColor: Color(0xff5d7599),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 300,
            ),
            Lottie.asset(
              'assets/images/uwu.json',
              width: 200, // set the width of the Lottie animation
              height: 200,
            ),
            Text(
              'howaiu?',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffcc2c4b6)), // Set the font size of the text
            ),
          ],
        ),
      ),
    );
  }
}
