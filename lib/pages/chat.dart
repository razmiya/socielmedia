
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/authservice.dart';
import 'chat page.dart';
  class Chat extends StatefulWidget {
    const Chat({super.key});

    @override
    State<Chat> createState() => _ChatState();
  }

  class _ChatState extends State<Chat> {

  //instance of the auth
  final FirebaseAuth _auth=FirebaseAuth.instance;
  //sign user out
  //sign user out
  void signOut(){
    //get auth service
    final authService = Provider.of<AuthService>(context,listen: false);
    authService.signOut();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("USERS",),
        centerTitle: true,
        backgroundColor: Colors.grey[700],
        actions: [
          //sign out button
          IconButton(
              onPressed: signOut,
              icon: const Icon(Icons.logout)),
        ],
      ),
      body: buildUserList(),
    );
  }
  //build a list of users except the current users loged in
  Widget buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('profiles').snapshots(),
      builder: (context,snapshot){
        if(snapshot.hasError){
          return const Text('error');
        }
        if(snapshot.connectionState==ConnectionState.waiting) {
          return const Text('loading');
        }
        return ListView(
          children:snapshot.data!.docs.
          map<Widget>((doc) =>  buildUserListItems(doc)).toList(),
        );
      },
    );


  }
  //build individual user list items
  Widget buildUserListItems(DocumentSnapshot document){
    Map<String,dynamic> data=document.data()! as Map<String,dynamic>;
    //display all user except current user
    if(_auth.currentUser!.email!=data['email']) {
      return ListTile(
        title: Text(data['email'],style: TextStyle(color: Colors.blue),),
        onTap: () {
          //pass the clicked 'uid' into chat page

          Navigator.push(context as BuildContext,
            MaterialPageRoute(builder: (context) =>
                ChatPage(
                  recieverUserEmail: data['email'],
                  recieverusername: data['name'],
                ),
            ),
          );
        },
      );
    }
    else{
      //return empty container
      return Container();
    }
  }
  }


