import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../constants_chat.dart';

final _firestore = FirebaseFirestore.instance;
late User loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  late String messageText;
  final messageTextController = TextEditingController();

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }


  void getCurrentUser() async{
    try {
      final user = await _auth.currentUser!;
      if(user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    }
    catch (e){
      print(e);
    }
  }




  /*void getMessages() async {
    try {
      final messages = await _firestore.collection('messages').get();
      for (var message in messages.docs) {
        print(message.data()); // Utilisez .data() pour accéder aux données du document
      }
    } catch (e) {
      print("Erreur lors de la récupération des messages : $e");
    }
  }*/



/*
  void messageStream() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
  }
*/


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading:IconButton(
          icon: const Icon(
              CupertinoIcons.back,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                //getMessages();
                //messageStream();
                _auth.signOut();
                Navigator.pop(context);
              },
          ),
        ],
        title: const Text('Chats'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            /*StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection("messages").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final messages = snapshot.data!.docs;
                    List<Text> messageWidgets = [];
                    for (var message in messages) {
                      final messageText = message.data['text'];
                      final messageSender = message.data['sender'];

                      final messageWidget = Text(
                          '$messageText from $messageSender');
                      messageWidgets.add(messageWidget);
                    }
                    return Column(
                      children: messageWidgets,
                    );
                  }
                },
            ),*/
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      messageTextController.clear();
                     _firestore.collection('messages').add({
                       'text': messageText,
                       'sender': loggedInUser.email,
                     });
                    },
                    icon:  const Icon(
                     Icons.send,
                      color: Colors.lightBlueAccent,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class MessageStream extends StatelessWidget {
  const MessageStream({super.key});

  @override
  Widget build(BuildContext context) {
    return    StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection("messages").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final messages = snapshot.data!.docs.reversed;
          List<MessageBubble> messageBubbles = [];
          for (var message in messages) {
            // Conversion explicite en Map<String, dynamic>
            final data = message.data() as Map<String, dynamic>;

            final messageText = data['text'] ?? 'Message inconnu';
            final messageSender = data['sender'] ?? 'Expéditeur inconnu';

            final currentUser = loggedInUser.email;

            if(currentUser == messageSender) {

            }

            final messageBubble = MessageBubble(
                sender: messageSender,
                text: messageText,
              isMe: currentUser == messageSender,
            );
            messageBubbles.add(messageBubble);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              children: messageBubbles,
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Une erreur s\'est produite lors du chargement. Vérifiez votre connexion internet!');
        } else {
          return  const Padding(
            padding: EdgeInsets.only(top: 18.0),
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            ),
          );
        }
      },
    );
  }
}




class MessageBubble extends StatelessWidget {
  MessageBubble({required this.sender, required this.text, required this.isMe});
  late final String sender;
  late final String text;
  bool isMe;



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
              sender,
            style: const TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Material(
            borderRadius:  isMe ? const BorderRadius.only(
              topLeft: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),

            ) :
            const BorderRadius.only(
              topRight: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),

            ),
            elevation: 5.0,
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                  '$text',
                style:  TextStyle(
                  color: isMe ? Colors.white : Colors.black,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
