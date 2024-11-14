import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LiveChatScreen extends StatefulWidget {
  @override
  _LiveChatScreenState createState() => _LiveChatScreenState();
}

class _LiveChatScreenState extends State<LiveChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser;

  // Send a message
  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(user!.uid)
        .collection('messages')
        .add({
      'senderId': user!.uid,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
      'isAdmin': false, // To identify user vs admin messages
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Live Chat')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(user!.uid)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final messageData = messages[index];
                    final isAdmin = messageData['isAdmin'] as bool;
                    return ListTile(
                      title: Align(
                        alignment: isAdmin
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color:
                                isAdmin ? Colors.grey[300] : Colors.blue[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            messageData['message'],
                            style: TextStyle(
                                color: isAdmin ? Colors.black : Colors.white),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => sendMessage(_messageController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
