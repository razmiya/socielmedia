
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socielmedia/components/screenpost.dart';
import 'package:socielmedia/pages/mydrawer.dart';
import 'package:socielmedia/pages/profilepage.dart';
import 'package:socielmedia/pages/viewprofile.dart';

import '../components/textfield.dart';
import 'chat.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //user
  final currentUser = FirebaseAuth.instance.currentUser!;

  //text controller
  final textController = TextEditingController();

  //instance of the auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //sign user out
  void signOut() {
    //get auth service
    FirebaseAuth.instance.signOut();
  }

  //post message
  void postMessage() {
  //only post if something in the textfield
    if(textController.text.isNotEmpty){
      //store in firebase
      FirebaseFirestore.instance.collection("User Posts").add({
        'UserEmail':currentUser.email,
      'Message':textController.text,
      'TimeStamp':Timestamp.now(),
        'Likes':[],
      });

    }
    //clear the textfield
    setState(() {
      textController.clear();
    });
  }
  //navigate to profile page
  void goToProfilePage(){
    //pop menu drawer
    Navigator.pop(context);
    //go to profile page
    Navigator.push(
        context, MaterialPageRoute(
      builder: (context) =>  ViewProfilePage(),
    ),
    );
  }
  void goToChatPage(){
    //pop menu drawer
    Navigator.pop(context);
    //go to chat page
    Navigator.push(
      context, MaterialPageRoute(
      builder: (context) => Chat(),
    ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[500],
      //Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text("The Screen",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.grey[800],
        actions: [
          //sign out button
          IconButton(
              onPressed: signOut,
              icon: const Icon(Icons.logout,color: Colors.white,)),
        ],
      ),
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onSignOut: signOut,
        onChatTap: goToChatPage,
      ),
      body: Center(
        child: Column(
          children: [
            //the screen
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.
                collection("User Posts").
                orderBy(
                  "TimeStamp",
                  descending: false,
                ).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          //get the message
                          final post = snapshot.data!.docs[index];
                          return ScreenPost(
                            message: post["Message"],
                            user: post["UserEmail"],
                            postId: post.id,
                            likes: List<String>.from(post["Likes"] ?? []), imageURL: null,

                          );
                        }
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error:${snapshot.error}'),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
            //post message
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                children: [
                  //textfield
                  Expanded(
                    child: MyTextField(
                      controller: textController,
                      hinttext: "write something here......",
                      obscureText: false,


                    ),
                  ),
                  //post button
                  IconButton(onPressed: postMessage,
                      icon: const Icon(Icons.arrow_circle_up),)
                ],
              ),
            ),
            //logged in as
            Text("logged in as;" + currentUser.email!),
            const SizedBox(height: 10,)
          ],
        ),
      ),
    );
  }
}
