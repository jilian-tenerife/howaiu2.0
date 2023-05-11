import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:howaiu/screens/login.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  File? _userImage; // Variable to store the user's selected image

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> signUpWithEmailAndPassword(
      String email, String password, File? userImage) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Upload the user image to Firebase Storage
      if (userImage != null) {
        String userId = userCredential.user!.uid;
        String imagePath = 'user_images/$userId.jpg';

        UploadTask uploadTask =
            FirebaseStorage.instance.ref().child(imagePath).putFile(userImage);
        await uploadTask.whenComplete(() {});
        String imageUrl =
            await FirebaseStorage.instance.ref(imagePath).getDownloadURL();

        // Save the image URL to the user's document in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .set({'image_url': imageUrl}, SetOptions(merge: true));
      }

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

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(source: ImageSource.camera);

    if (imageFile != null) {
      setState(() {
        _userImage = File(imageFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color baseColor = Color(0xffdadada);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: baseColor,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: screenHeight * 0.05,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.width * 0.4,
                      width: MediaQuery.of(context).size.width * 0.4,
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
                  height: screenHeight * 0.03,
                ),
                Container(
                  width: screenWidth * 0.8,
                  height: screenHeight * 0.2,
                  child: GestureDetector(
                    onTap: _takePicture,
                    child: _userImage != null
                        ? Image.file(_userImage!)
                        : Neumorphic(
                            style: NeumorphicStyle(
                                depth: -7,
                                intensity: 8,
                                lightSource: LightSource.topRight,
                                shape: NeumorphicShape.convex,
                                color: baseColor),
                            child: Icon(
                              Icons.camera_alt,
                              size: 50,
                              color: Color(0xff5d7599),
                            ),
                          ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.03,
                ),
                Container(
                  width: screenWidth * 0.8,
                  height: screenHeight * 0.08,
                  child: Neumorphic(
                    style: NeumorphicStyle(
                        depth: -3,
                        shape: NeumorphicShape.concave,
                        color: baseColor),
                    child: Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.02),
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
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width *
                                0.04, // For example, set horizontal padding to be 4% of screen width
                            vertical: MediaQuery.of(context).size.height * 0.02,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.03,
                ),
                Container(
                  width: screenWidth * 0.8,
                  height: screenHeight * 0.08,
                  child: Neumorphic(
                    style: NeumorphicStyle(
                        depth: -3,
                        shape: NeumorphicShape.flat,
                        color: baseColor),
                    child: Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.02),
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
                            horizontal:
                                MediaQuery.of(context).size.width * 0.04,
                            vertical: MediaQuery.of(context).size.height * 0.02,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                ),
                Container(
                  width: screenWidth * 0.65,
                  height: screenHeight * 0.08,
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
                          await signUpWithEmailAndPassword(
                              username, password, _userImage);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
                          );
                        } catch (e) {
                          print('Error: $e');
                        }
                      },
                      style: NeumorphicStyle(
                        color: baseColor,
                        depth: 5,
                        shape: NeumorphicShape.convex,
                      ),
                      child: Center(
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff5d7599)),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
