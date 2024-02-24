// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import 'editprofilepage.dart';
//
// class ViewProfilePage extends StatefulWidget {
//   @override
//   _ViewProfilePageState createState() => _ViewProfilePageState();
// }
//
// class _ViewProfilePageState extends State<ViewProfilePage> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   User? _user;
//   Map<String, dynamic>? _profileData;
//
//   @override
//   void initState() {
//     super.initState();
//     _getUserProfile();
//   }
//
//   Future<void> _getUserProfile() async {
//     _user = _auth.currentUser;
//     if (_user != null) {
//       QuerySnapshot profileSnapshot = await _firestore
//           .collection('profiles')
//           .where('email', isEqualTo: _user!.email)
//           .get();
//       if (profileSnapshot.docs.isNotEmpty) {
//         setState(() {
//           _profileData =
//           profileSnapshot.docs.first.data() as Map<String, dynamic>?;
//         });
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         title: Text('Profile'),
//         centerTitle: true,
//         backgroundColor: Colors.grey[700],
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.edit),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => EditProfilePage(),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: _profileData == null
//           ? Center(child: CircularProgressIndicator())
//           : _buildProfile(),
//     );
//   }
//
//   Widget _buildProfile() {
// //     return Padding(
// //       padding: const EdgeInsets.all(20.0),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //     SizedBox(height: 20),
// //     CircleAvatar(
// //     radius: 50,
// //     backgroundImage: NetworkImage(_profileData['profileImage']),
// //     ),
// //     SizedBox(height: 20),
// //         children: [
// //           Text(
// //             'Name: ${_profileData!['name']}',
// //             style: TextStyle(fontSize: 18),
// //           ),
// //           SizedBox(height: 10),
// //           Text(
// //             'Email: ${_user!.email}',
// //             style: TextStyle(fontSize: 18),
// //           ),
// //           // Add other profile fields here
// //         ],
// //       ),
// //     );
// //   }
// // }
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: <Widget>[
//         SizedBox(height: 20),
//         SizedBox(width: 400,),
//
//     // backgroundImage: NetworkImage(_profileData['profileImage']),
//
//         // Display profile image inside a CircleAvatar if available, else display person icon
//         _profileData?['profileImage'] != null
//             ? CircleAvatar(
//           radius: 60,
//           backgroundImage: NetworkImage(_profileData?['profileImage']),
//         )
//             : CircleAvatar(
//           radius: 60,
//           child: Icon(Icons.person, size: 60.0),
//         ),
//
//         SizedBox(height: 20),
//         Text(
//           _profileData?['name'],
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),
//         ),
//         SizedBox(height: 10),
//         Text(
//           _profileData?['job'],
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),
//         ),
//         SizedBox(height: 10),
//         Text(
//           'Email: ${_user!.email}',
//           style: TextStyle(fontSize: 16,color: Colors.blue),
//         ),
//         SizedBox(height: 20),
//
//         // Add other profile details as needed
//       ],
//     );
//
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'editprofilepage.dart';

class ViewProfilePage extends StatefulWidget {

  @override
  _ViewProfilePageState createState() => _ViewProfilePageState();

}

class _ViewProfilePageState extends State<ViewProfilePage> {
  String userEmail = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  Map<String, dynamic>? _profileData;
  final currentUser = FirebaseAuth.instance.currentUser;
  int followersCount = 0;

  @override
  void initState() {
    super.initState();
    _getUserProfile();
    getFollowersCount();
  }

  Future<void> _getUserProfile() async {
    _user = _auth.currentUser;
    if (_user != null) {
      QuerySnapshot profileSnapshot = await _firestore
          .collection('profiles')
          .where('email', isEqualTo: _user!.email)
          .get();
      if (profileSnapshot.docs.isNotEmpty) {
        setState(() {
          _profileData =
          profileSnapshot.docs.first.data() as Map<String, dynamic>?;
        });
      }
    }
  }

  void getFollowersCount() {
    FirebaseFirestore.instance
        .collection("follow")
        .doc(currentUser!.email)
        .collection("Followers")
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        followersCount = querySnapshot.size;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.grey[700],
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfilePage(
                      name: _profileData?['name'],
                      dob: _profileData?['dob'],
                      address: _profileData?['address'],
                    gender: _profileData?['gender'],
                    qualification: _profileData?['qualification'],
                    job: _profileData?['job'],
                    hobbies: _profileData?['hobbies'],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: _profileData == null
          ? Center(child: CircularProgressIndicator())
          : _buildProfile(),
    );
  }

  Widget _buildProfile() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 20),
          SizedBox(width: 400,),
      
          // backgroundImage: NetworkImage(_profileData['profileImage']),
      
          // Display profile image inside a CircleAvatar if available, else display person icon
          _profileData?['profileImage'] != null
              ? CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage(_profileData?['profileImage']),
          )
              : CircleAvatar(
            radius: 60,
            child: Icon(Icons.person, size: 60.0),
          ),
      
          SizedBox(height: 20),
            Text(
              _profileData?['name'],
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,color: Colors.white),
            ),
      
          SizedBox(height: 10),
             Text(
              _profileData?['job'],
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,color: Colors.white),
            ),
          SizedBox(height: 10),
          Text(
            'Email: ${_user!.email}',
            style: TextStyle(fontSize: 16,color: Colors.blue),
          ),
          SizedBox(height: 20),
          Text(
            'followers = ${followersCount.toString()}',
            style: TextStyle(fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold),
          ),
                  SizedBox(height: 20,),
                  Text(
              'DOB: ${_profileData!['dob']}',
              style: TextStyle(fontSize: 16,color: Colors.white),
            ),
          SizedBox(height: 20),
          Text(
            'Gender: ${_profileData!['gender']}',
            style: TextStyle(fontSize: 16,color: Colors.white),
          ),
          SizedBox(height: 20),
          Text(
            'Address: ${_profileData!['address']}',
            style: TextStyle(fontSize: 16,color: Colors.white),
          ),
          SizedBox(height: 20),
          Text(
            'Qualification: ${_profileData!['qualification']}',
            style: TextStyle(fontSize: 16,color: Colors.white),
          ),
          SizedBox(height: 20),
          Text(
            'Designation: ${_profileData!['job']}',
            style: TextStyle(fontSize: 16,color: Colors.white),
          ),
          SizedBox(height: 20),
          Text(
            'Hobbies: ${_profileData!['hobbies']}',
            style: TextStyle(fontSize: 16,color: Colors.white),
          ),
      
      
          // Add other profile details as needed
        ],
      ),
    );

  }
}