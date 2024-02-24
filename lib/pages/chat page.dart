import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth/chatservice.dart';
import '../components/chatbubble.dart';
import '../components/textfield.dart';

class ChatPage extends StatefulWidget {
  final String recieverUserEmail;
  final String recieverusername;
  const ChatPage({super.key,
    required this.recieverUserEmail,
    required this.recieverusername,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController=TextEditingController();
  final ChatService chatService=ChatService();
  final FirebaseAuth firebaseAuth=FirebaseAuth.instance;
  void sendMessage() async{
    //only send message if there is something to send
    if(_messageController.text.isNotEmpty)
      await chatService.sendMessage(
          widget.recieverusername, _messageController.text);
    //clear the text controller vafter sending the message
    _messageController.clear();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[500],
      appBar: AppBar(title: Text(widget.recieverUserEmail),
      backgroundColor: Colors.grey[700],),
      body: Column(
        children: [
          //messages
          Expanded(
            child: _buildMessageList(),
          ),
          //user inputs
          _buildMessageInput(),
          const SizedBox(height: 25,),
        ],
      ),
    );
  }
  //build message list
  Widget _buildMessageList(){
    return StreamBuilder(
      stream: chatService.getMessages(
          widget.recieverusername,firebaseAuth.currentUser!.uid),
      builder: (context,snapshot){
        if(snapshot.hasError){
          return Text('Error${snapshot.error}');
        }
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Text('Loading.... ');
        }
        return ListView(
          children: snapshot.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      },
    );
  }
  Widget _buildMessageItem(DocumentSnapshot document){
    Map<String,dynamic> data = document.data() as Map<String,dynamic>;
    //sign the messages to the right if the sender is thecurrent user, other wise to the left
    var alignment =(data['sender Id'] == firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        :Alignment.centerLeft ;
    return Container(
      alignment: alignment,
      child:Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment:
          (data['senderId'] == firebaseAuth.currentUser!.uid)
              ? CrossAxisAlignment.end
              :CrossAxisAlignment.start ,
          mainAxisAlignment:
          (data['senderId'] == firebaseAuth.currentUser!.uid)
              ? MainAxisAlignment.end
              :MainAxisAlignment.start,
          children: [
            Text(data['senderEmail']),
            const SizedBox(height: 5,),
            ChatBubble(message: data['message']),

          ],
        ),
      ) ,
    );
  }
//build message item
//build message inputs
  Widget _buildMessageInput(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          //textfield
          Expanded(
            child: MyTextField(
              controller:_messageController ,
              hinttext: 'Enter message',
              obscureText: false,
            ),
          ),
          //send button
          IconButton(
            onPressed: sendMessage,
            icon: Icon(
              Icons.arrow_upward,size: 40,),
          )
        ],
      ),
    );
  }
}
