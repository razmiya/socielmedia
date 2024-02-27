import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socielmedia/components/commentbutton.dart';
import 'package:socielmedia/components/delete.dart';
import 'package:socielmedia/components/likebutton.dart';
import 'package:socielmedia/helper/helpermethods.dart';
import 'package:socielmedia/pages/comments.dart';

class ScreenPost extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final List<String> likes;

  const ScreenPost({
    Key? key,
    required this.message,
    required this.user,
    required this.postId,
    required this.likes, required imageURL,
  }) : super(key: key);

  @override
  State<ScreenPost> createState() => _ScreenPostState();
}

class _ScreenPostState extends State<ScreenPost> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;
  bool isFollowing = false;

  final commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
    checkIfFollowing();
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
    DocumentReference postRef =
    FirebaseFirestore.instance.collection("User Posts").doc(widget.postId);
    if (isLiked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email]),
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email]),
      });
    }
  }

  void addComment(String commentText) {
    FirebaseFirestore.instance.collection("User Posts").doc(widget.postId).collection("Comments").add({
      "CommentText": commentText,
      "CommentBody": currentUser.email,
      "CommentTime": Timestamp.now(),
    });
  }

  void showCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add comment"),
        content: TextField(
          controller: commentTextController,
          decoration: InputDecoration(hintText: "write a comment"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              addComment(commentTextController.text);
              Navigator.pop(context);
              commentTextController.clear();
            },
            child: Text("Post"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              commentTextController.clear();
            },
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void deletePost() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Post"),
        content: const Text("Are you sure you want to delete the post"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              final commentDocs = await FirebaseFirestore.instance.collection("User Posts").doc(widget.postId).collection("Comments").get();
              for (var doc in commentDocs.docs) {
                await FirebaseFirestore.instance.collection("User Posts").doc(widget.postId).collection("Comments").doc(doc.id).delete();
              }
              FirebaseFirestore.instance.collection("User Posts").doc(widget.postId).delete().then((value) => print("post deleted")).catchError((error) => print("failed delete post: $error"));
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  void checkIfFollowing() {
    FirebaseFirestore.instance
        .collection("follow")
        .doc(widget.user)
        .collection("Followers")
        .doc(currentUser.email)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        setState(() {
          isFollowing = true;
        });
      }
    });
  }

  void followUser() {
    FirebaseFirestore.instance.collection("follow").doc(widget.user).collection("Followers").doc(currentUser.email).set({
      'followerId': currentUser.email,
    }).then((value) {
      setState(() {
        isFollowing = true;
      });
    });
  }

  void unfollowUser() {
    FirebaseFirestore.instance.collection("follow").doc(widget.user).collection("Followers").doc(currentUser.email).delete().then((value) {
      setState(() {
        isFollowing = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[700],
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.message,style:  TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(widget.user,style: TextStyle(color: Colors.blue),),
                      GestureDetector(
                        onTap: () {
                          if (isFollowing) {
                            unfollowUser();
                          } else {
                            followUser();
                          }
                        },
                        child: Text(
                          isFollowing ? ' (Following)' : ' (Follow)',
                          style: TextStyle(
                            color: Colors.red,
                            decoration: TextDecoration.underline,
                            fontSize: 15,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (widget.user == currentUser.email) Delete(onTap: deletePost),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  LikeButton(
                    isLiked: isLiked,
                    onTap: toggleLike,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.likes.length.toString(),
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Column(
                children: [
                  CommentButton(onTap: showCommentDialog),
                  const SizedBox(height: 5),
                  Text(
                    'comment',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("User Posts").doc(widget.postId).collection("Comments").orderBy("CommentTime", descending: true).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((doc) {
                  final commentData = doc.data() as Map<String, dynamic>;
                  return Comment(
                    text: commentData["CommentText"],
                    user: commentData["CommentBody"],
                    time: formatDate(commentData["CommentTime"]),
                  );
                }).toList(),
              );
            },
          ),

        ],
      ),
    );
  }
}
