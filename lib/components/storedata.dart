// Import necessary packages
import 'package:cloud_firestore/cloud_firestore.dart';

// Add user data to Firestore
Future<void> addUserToFirestore(String username, String imageUrl) async {
  await FirebaseFirestore.instance.collection('users').add({
    'username': username,
    'image_url': imageUrl,
  });
}

// Retrieve user data from Firestore
Stream<QuerySnapshot> getUserData() {
  return FirebaseFirestore.instance.collection('users').snapshots();
}