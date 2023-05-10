import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:intl/intl.dart';

import 'analytical.dart';
import 'contextual.dart';
import 'feedback.dart';

class FeedbackScreen extends StatefulWidget {
  final String entry;
  final List<String> previousEntries;

  FeedbackScreen({required this.entry, required this.previousEntries});

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  String title = '';
  String feedback = '';
  String analysis = '';
  String contextualResponse = '';
  late PageController _pageController;
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    generateTitle();
  }

  @override
  void dispose() {
    _pageController.dispose(); // Dispose the _pageController when not in use
    super.dispose();
  }

  Future<void> generateTitle() async {
    await processRequest('title', widget.entry, (String value) {
      setState(() {
        title = value;
      });
    });
  }

  Future<void> processRequest(
      String route, String entry, Function(String) callback) async {
    // final response = await http.post(
    //   Uri.parse('http://10.0.2.2:5000/$route'),
    //   headers: {'Content-Type': 'application/json'},
    //   body: jsonEncode({'entry': entry}),
    // );

    // if (response.statusCode == 200) {
    //   callback(jsonDecode(response.body)[route]);
    // } else {
    //   callback('Error: ${response.statusCode}');
    // }
    Future.delayed(Duration(seconds: 1), () {
      callback('Mock response for $route');
    });
  }

  @override
  Widget build(BuildContext context) {
    var formattedDate = getFormattedDate();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffdadada),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Center(
                child: SizedBox(
                  height: 10,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  formattedDate[0],
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff5d7599),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 5),
                Text(
                  formattedDate[1],
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff5d7599),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(height: 25),
            if (title != '')
              Container(
                width: 300,
                child: Center(
                  child: (AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        title,
                        textStyle: TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff5d7599),
                        ),
                        speed: const Duration(milliseconds: 100),
                      ),
                    ],
                    repeatForever: false,
                  )),
                ),
              ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                children: [
                  FeedbackPage(
                      entry: widget.entry,
                      previousEntries: widget.previousEntries),
                  AnalyticalFeedbackPage(
                      entry: widget.entry,
                      previousEntries: widget.previousEntries),
                  // ContextualFeedbackPage(
                  //     entry: widget.entry,
                  //     previousEntries: widget.previousEntries),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Neumorphic(
            style: NeumorphicStyle(
              shape: NeumorphicShape.convex,
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(50)),
              depth: 8.0,
              intensity: 0.7,
              lightSource: LightSource.topLeft,
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                  _pageController.jumpToPage(index);
                });
              },
              unselectedItemColor:
                  Color(0xffabb6c8), // color for unselected icons
              selectedItemColor: Color(0xff5981b1),
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.feedback),
                  label: 'Feedback',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.analytics),
                  label: 'Analytical',
                ),
                // BottomNavigationBarItem(
                //   icon: Icon(Icons.text_snippet),
                //   label: 'Contextual',
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// Container(
//   width: 200,
//   height: 50,
//   child: NeumorphicButton(
//     onPressed: () async {
//       await processRequest('feedback', widget.entry,
//           (String value) {
//         setState(() {
//           feedback = value;
//         });
//       });
//     },
//     child: Text(
//       'Get Feedback',
//       style: TextStyle(
//         fontSize: 20.0,
//         fontWeight: FontWeight.bold,
//         color: Colors.white,
//       ),
//     ),
//     style: NeumorphicStyle(
//       color:
//           Color(0xffabb6c8), // Set the button's background color
//       depth: 5,
//       shape: NeumorphicShape.concave,
//     ),
//   ),
// ),
//               SizedBox(
//                 height: 25,
//               ),
//               if (feedback != '')
//                 SizedBox(
//                   width: 350,
//                   height: 150,
//                   child: Neumorphic(
//                     style: NeumorphicStyle(
//                       depth: -5,
//                       intensity: 1,
//                       shape: NeumorphicShape.convex,
//                       color: Color(0xffabb6c8),
//                     ),
//                     child: Padding(
//                       padding: EdgeInsets.all(16.0),
//                       child: (AnimatedTextKit(
//                         animatedTexts: [
//                           TypewriterAnimatedText(
//                             feedback,
//                             speed: const Duration(milliseconds: 50),
//                             textStyle: TextStyle(
//                               fontSize: 12.0,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ],
//                         repeatForever: false, // Set this to false
//                         totalRepeatCount:
//                             1, // Set this to 1 to play the animation only once
//                       )),
//                     ),
//                   ),
//                 ),
//               //Text(feedback),
//               SizedBox(
//                 height: 25,
//               ),
//               NeumorphicButton(
//                 onPressed: () async {
//                   await processRequest('analytical_response', widget.entry,
//                       (String value) {
//                     setState(() {
//                       analysis = value;
//                     });
//                   });
//                 },
//                 child: Text(
//                   'Get Analytical Response',
//                   style: TextStyle(
//                     fontSize: 12.0,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 style: NeumorphicStyle(
//                   color: Color(0xffabb6c8), // Set the button's background color
//                   depth: 5,
//                   shape: NeumorphicShape.concave,
//                 ),
//               ),
//               SizedBox(
//                 height: 25,
//               ),
//               if (analysis != '')
//                 SizedBox(
//                   width: 350,
//                   height: 150,
//                   child: Neumorphic(
//                       style: NeumorphicStyle(
//                         depth: -5,
//                         intensity: 1,
//                         shape: NeumorphicShape.convex,
//                         color: Color(0xffabb6c8),
//                       ),
//                       child: Padding(
//                         padding: EdgeInsets.all(16.0),
//                         child: (AnimatedTextKit(
//                           animatedTexts: [
//                             TypewriterAnimatedText(
//                               analysis,
//                               textStyle: TextStyle(
//                                 fontSize: 12.0,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                               ),
//                               speed: const Duration(milliseconds: 50),
//                             ),
//                           ],
//                           repeatForever: false, // Set this to false
//                           totalRepeatCount:
//                               1, // Set this to 1 to play the animation only once
//                         )),
//                       )),
//                 ),
//               //Text(analysis),
//               SizedBox(
//                 height: 25,
//               ),
//               NeumorphicButton(
//                 onPressed: () async {
//                   final allEntries = widget.previousEntries + [widget.entry];
//                   await processRequest(
//                       'contextual_response', allEntries.join('\n'),
//                       (String value) {
//                     setState(() {
//                       contextualResponse = value;
//                     });
//                   });
//                 },
//                 child: Text(
//                   'Get Contextual Response',
//                   style: TextStyle(
//                     fontSize: 12.0,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 style: NeumorphicStyle(
//                   color: Color(0xffabb6c8), // Set the button's background color
//                   depth: 5,
//                   shape: NeumorphicShape.concave,
//                 ),
//               ),
//               SizedBox(
//                 height: 25,
//               ),
//               if (contextualResponse != '')
//                 SizedBox(
//                   width: 350,
//                   height: 150,
//                   child: Neumorphic(
//                     style: NeumorphicStyle(
//                       depth: -5,
//                       intensity: 1,
//                       shape: NeumorphicShape.concave,
//                       color: Color(0xffabb6c8),
//                     ),
//                     child: Padding(
//                       padding: EdgeInsets.all(16.0),
//                       child: (AnimatedTextKit(
//                         animatedTexts: [
//                           TypewriterAnimatedText(
//                             contextualResponse,
//                             textStyle: TextStyle(
//                               fontSize: 12.0,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                             speed: const Duration(milliseconds: 50),
//                           ),
//                         ],
//                         repeatForever: false, // Set this to false
//                         totalRepeatCount:
//                             1, // Set this to 1 to play the animation only once
//                       )),
//                     ),
//                   ),
//                 ),
//               //Text(contextualResponse),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

  List<String> getFormattedDate() {
    DateTime now = DateTime.now();
    String dayOfWeek = DateFormat('EEEE').format(now);
    String monthAndDay = DateFormat('MMMM d').format(now);
    return [dayOfWeek, monthAndDay];
  }
}
