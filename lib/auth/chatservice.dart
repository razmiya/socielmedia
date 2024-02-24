import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../models/message.dart';
class ChatService extends ChangeNotifier {
  //get instance of auth and firestore
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //SEND MESSAGES
  Future<void> sendMessage(String receiverId, String message) async {
    //get current user information
    final String currentUserId = firebaseAuth.currentUser!.uid;
    final String currentUserEmail = firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();
    //create a new message
    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      message: message,
      timestamp: timestamp,
    );


    //construct chat room id from current user id and receiverid
    List<String> ids = [currentUserId, receiverId];
    ids
        .sort(); //sort the ids (this ensure the chat from id is always the same for any pair ofpeople
    String chatRoomId = ids.join("_");
    //enable the ids into a single string to use as a chatroomid


    //add new message to database
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

//GET MESSAGE
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    //construct chat room id from user ids(sorted to ensure it matches the id used when sending)
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false).snapshots();
  }
}