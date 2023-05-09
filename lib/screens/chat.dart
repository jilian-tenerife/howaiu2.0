import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../widgets/chat_bubble.dart';

class ChatAiu extends StatefulWidget {
  const ChatAiu({Key? key}) : super(key: key);

  @override
  State<ChatAiu> createState() => _ChatAiuState();
}

// test
class _ChatAiuState extends State<ChatAiu> {
  final TextEditingController _controller = TextEditingController();
  final DocumentReference userDocument = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid);

  List<ChatBubble> _messages = [
    const ChatBubble(
      text: 'How can I help you?',
      isCurrentUser: false,
    ),
  ];

  Future<void> _saveChatMessage(ChatBubble chatBubble) async {
    final Map<String, dynamic> data = {
      'text': chatBubble.text,
      'isCurrentUser': chatBubble.isCurrentUser,
      'timestamp': FieldValue.serverTimestamp(),
    };
    await userDocument.collection('chats').add(data);
  }

  Future<String> _sendMessage(String message, String name) async {
    String text = _controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _messages.add(ChatBubble(text: text, isCurrentUser: true));
        _saveChatMessage(_messages.last);
      });
      _controller.clear();
    }

    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/chat'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'message': message, 'name': name}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['response'];
    } else {
      throw Exception('Failed to load chatbot response');
    }
  }

  @override
  Widget build(BuildContext context) {
    Color baseColor = const Color(0xffdadada);

    return Scaffold(
      backgroundColor: Color(0xffabb6c8),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16.0)),
          child: Neumorphic(
            style: NeumorphicStyle(
              depth: 10,
              shape: NeumorphicShape.concave,
              lightSource: LightSource.bottomLeft,
              color: baseColor,
            ),
            child: AppBar(
              backgroundColor: Color(0xffabb6c8),
              elevation: 10,
              title: const Text('AiU'),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: userDocument
                  .collection('chats')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                final List<ChatBubble> chatBubbles =
                    snapshot.data!.docs.map<ChatBubble>((doc) {
                  return ChatBubble(
                    text: doc['text'],
                    isCurrentUser: doc['isCurrentUser'],
                  );
                }).toList();

                return ListView.builder(
                  itemCount: chatBubbles.length,
                  itemBuilder: (context, index) => chatBubbles[index],
                );
              },
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
            child: Row(
              children: [
                Expanded(
                  child: Neumorphic(
                    style: NeumorphicStyle(
                      depth: -4,
                      shape: NeumorphicShape.convex,
                      lightSource: LightSource.topLeft,
                      color: Color(0xffabb6c8),
                    ),
                    child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Type your message...',
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 10.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        minLines: 1, // Minimum number of lines
                        maxLines:
                            null, // Expands the TextField when text reaches the end
                        keyboardType: TextInputType.multiline),
                  ),
                ),
                NeumorphicButton(
                  onPressed: () async {
                    String message = _controller.text;
                    String response = await _sendMessage(message, 'JiwJiw');
                    setState(() {
                      _messages.add(
                          ChatBubble(text: response, isCurrentUser: false));
                      _saveChatMessage(_messages.last);
                    });
                  },
                  style: NeumorphicStyle(
                    shape: NeumorphicShape.flat,
                    depth: 1,
                    color: Color(0xffabb6c8), // Set the button color here
                  ),
                  child: Container(
                    constraints: BoxConstraints(minHeight: 30, maxHeight: 50),
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
