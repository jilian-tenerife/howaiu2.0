import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:howaiu/screens/login.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // do something with the newly created user here
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    Color baseColor = Color(0xffdadada);

    return SafeArea(
      child: Scaffold(
        backgroundColor: baseColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 90,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'howaiu?',
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff5d7599)),
                  ),
                ],
              ),
              const SizedBox(
                height: 95,
              ),
              const SizedBox(
                height: 45,
              ),
              Container(
                  width: 300,
                  height: 60,
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
                          hintText: 'Username',
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
                height: 25,
              ),
              Container(
                  width: 300,
                  height: 60,
                  child: Neumorphic(
                    style: NeumorphicStyle(
                        depth: -3,
                        shape: NeumorphicShape.flat,
                        color: baseColor),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        controller: _passwordController,
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
                              horizontal: 16, vertical: 10),
                        ),
                      ),
                    ),
                  )),
              SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 45,
              ),
              Container(
                width: 250,
                height: 60,
                child: Neumorphic(
                  style: NeumorphicStyle(
                      depth: 5,
                      shape: NeumorphicShape.concave,
                      lightSource: LightSource.topLeft,
                      intensity: 0.7,
                      color: baseColor),
                  child: NeumorphicButton(
                    onPressed: () async {
                      final username = _emailController.text;
                      final password = _passwordController.text;
                      try {
                        await signUpWithEmailAndPassword(username, password);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                      } catch (e) {
                        print('Error: $e');
                      }
                    },
                    style: NeumorphicStyle(
                      color: baseColor, // Set the button's background color
                      depth: 5, // Set the depth of the button's shadow
                      shape: NeumorphicShape.convex,
                    ),
                    child: Center(
                      child: Text(
                        'Sign Up', // Set the text of the button
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
            ],
          ),
        ),
      ),
    );
  }
}
