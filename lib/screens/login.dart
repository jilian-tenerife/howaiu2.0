import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:howaiu/screens/forgotpass.dart';
import 'package:howaiu/screens/home_page.dart';
import 'package:howaiu/screens/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../main.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    Color baseColor = Color(0xffdadada);

    return SafeArea(
      child: Scaffold(
        backgroundColor: baseColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height *
                    0.1, // 10% of screen height
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.width * 0.7,
                    width: MediaQuery.of(context).size.width * 0.7,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/howaiu.png'),
                        fit: BoxFit
                            .cover, // Specify how the image should be fitted inside the box
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Container(
                  width: MediaQuery.of(context).size.width *
                      0.8, // 80% of screen width
                  height: MediaQuery.of(context).size.height *
                      0.08, // 8% of screen height
                  child: Neumorphic(
                    style: NeumorphicStyle(
                        depth: -3,
                        shape: NeumorphicShape.concave,
                        color: baseColor),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: _emailController,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xffabb6c8)),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Email',
                          hintStyle: const TextStyle(
                            color: Color(0xff5d7599),
                          ),
                          filled: true,
                          fillColor: baseColor,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                        ),
                      ),
                    ),
                  )),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.025,
              ),
              Container(
                  width: MediaQuery.of(context).size.width *
                      0.8, // 80% of screen width
                  height: MediaQuery.of(context).size.height *
                      0.08, // 8% of screen height
                  child: Neumorphic(
                    style: NeumorphicStyle(
                        depth: -3,
                        shape: NeumorphicShape.flat,
                        color: baseColor),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff5d7599)),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Password',
                          hintStyle: TextStyle(
                            color: Color(0xff5d7599),
                          ),
                          filled: true,
                          fillColor: baseColor,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.04,
                              vertical:
                                  MediaQuery.of(context).size.height * 0.01),
                        ),
                      ),
                    ),
                  )),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.015,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff5d7599),
                          decoration: TextDecoration.underline,
                          decorationColor: Color(0xff5d7599)),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => forgotPassword()));
                    },
                  ),
                  SizedBox(
                    width: 60,
                  )
                ],
              ),
              SizedBox(
                height: 45,
              ),
              Container(
                width: MediaQuery.of(context).size.width *
                    0.7, // 70% of screen width
                height: MediaQuery.of(context).size.height *
                    0.07, // 8% of screen height
                // other code

                child: Neumorphic(
                  style: NeumorphicStyle(
                      depth: 5,
                      shape: NeumorphicShape.convex,
                      lightSource: LightSource.topLeft,
                      intensity: 0.7,
                      color: baseColor),
                  child: NeumorphicButton(
                    onPressed: () async {
                      try {
                        final UserCredential userCredential =
                            await _auth.signInWithEmailAndPassword(
                                email: _emailController.text.trim(),
                                password: _passwordController.text);
                        if (userCredential.user != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TableCalendarExample()),
                          );
                        }
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          print('No user found for that email.');
                        } else if (e.code == 'wrong-password') {
                          print('Wrong password provided for that user.');
                        }
                      }
                    },
                    style: NeumorphicStyle(
                      shape: NeumorphicShape.convex,
                      depth: 8,
                      intensity: 0.7,
                      lightSource: LightSource.bottomRight,
                      color: Colors.grey[300],
                    ),
                    child: Center(
                      child: Text(
                        'Log In', // Set the text of the button
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(
                                0xff5d7599)), // Set the font size of the text
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 35,
              ),
              InkWell(
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                      color: Color(0xff5d7599),
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xff5d7599)),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Signup()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
