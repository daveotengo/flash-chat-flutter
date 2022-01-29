import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ChatScreen extends StatefulWidget {
  static String id ='chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}
final _fireStore = FirebaseFirestore.instance;
final _auth= FirebaseAuth.instance;

class _ChatScreenState extends State<ChatScreen> {

  final msgTextController = TextEditingController();

  User loggedInUser;

  var messageText;

  void getCurrentUser() async{

    try {
      final user = await _auth.currentUser;

      if (user != null) {

        loggedInUser= user;
        print(user.email);
      }
    }catch(e){
      print(e);
    }

  }

  void getMessages()async{
   final messages = await _fireStore.collection('messages').get();

   for(var message in messages.docs){
     print(message.data());
   }
  }

  void getMessageStream() async {

    await for(var snapShots in _fireStore.collection('messages').snapshots()){

      for(var message in snapShots.docs){

        print(message.data());

      }

    }

  }


  void initState() {
    super.initState();
    getCurrentState();
    getCurrentUser();


  }

  void  getCurrentState(){
    _auth.authStateChanges().listen((User user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  void logOut() async{
    await _auth.signOut();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {

                 Navigator.pushNamed(context, WelcomeScreen.id);
                 logOut();
               // getMessageStream();

                //getMessages();

                //Implement logout functionality
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: msgTextController,
                      onChanged: (value) {
                        messageText = value;
                        //Do something with the user input.
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      msgTextController.clear();
                      _fireStore.collection('messages').add({
                        'text': messageText ,
                        'sender': loggedInUser.email
                      });
                      //Implement send functionality.
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
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

class MessageBubble extends StatelessWidget {

  MessageBubble({this.text,this.sender,this.isMe});
  final String text;
  final String sender;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:  isMe? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(sender,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54

            ),

          ),
          Material(
            //borderRadius: BorderRadius.circular(30.0),
            borderRadius: isMe? BorderRadius.only(topLeft: Radius.circular(30) ,bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)) : BorderRadius.only(topRight:  Radius.circular(30),bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)),
            elevation: 5.0,
            color: isMe?Colors.lightBlueAccent:Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
              child: Text(
                '$text',
                style: TextStyle(
                    fontSize: 15,
                    color: isMe? Colors.white:Colors.black54
                ),

              ),
            ),
          ),
        ],

      ),
    );
  }
}


class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _fireStore.collection('messages').snapshots(),
        builder: (context,snapshot){
          if(snapshot.hasData){

            Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );

          }
          final msgs = snapshot.data.docs.reversed;

          List<MessageBubble> msgWidgets = [];

          for(var msg in msgs){

            final msgText = msg.data()['text'];

            final msgSender = msg.data()['sender'];

            final currentUser =  _auth.currentUser;

            final msgWidget = MessageBubble(sender: msgSender,text: msgText,isMe:currentUser.email==msgSender);

            msgWidgets.add(msgWidget);

          }

          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 20
              ),
              children: msgWidgets,
            ),
          );

        }
    );
  }
}
