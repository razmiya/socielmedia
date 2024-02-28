
// //
// // import 'package:flutter/material.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// //
// // import '../components/button.dart';
// // import '../components/textbox.dart';
// // import 'editprofilepage.dart';
// //
// // class EditProfilePage extends StatefulWidget {
// //
// //   @override
// //   _EditProfilePageState createState() => _EditProfilePageState();
// //
// // }
// //
// // class _EditProfilePageState extends State<EditProfilePage> {
// //   String userEmail = '';
// //   final FirebaseAuth _auth = FirebaseAuth.instance;
// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// //   User? _user;
// //   Map<String, dynamic>? _profileData;
// //
// //   get update => null;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _getUserProfile();
// //   }
// //
// //   Future<void> _getUserProfile() async {
// //     _user = _auth.currentUser;
// //     if (_user != null) {
// //       QuerySnapshot profileSnapshot = await _firestore
// //           .collection('profiles')
// //           .where('email', isEqualTo: _user!.email)
// //           .get();
// //       if (profileSnapshot.docs.isNotEmpty) {
// //         setState(() {
// //           _profileData =
// //           profileSnapshot.docs.first.data() as Map<String, dynamic>?;
// //         });
// //       }
// //     }
// //   }
// //   Future<void> editField(String field)async {
// //
// //   }
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.grey[500],
// //       appBar: AppBar(
// //         title: Text('Profile'),
// //         centerTitle: true,
// //         backgroundColor: Colors.grey[700],
// //
// //       ),
// //       body: StreamBuilder(
// //         stream:FirebaseFirestore.instance.collection('profiles').doc(curr) ,
// //         builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {  },
// //         child: _profileData == null
// //             ? Center(child: CircularProgressIndicator())
// //             : _buildProfile(),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildProfile() {
// // //     return Padding(
// // //       padding: const EdgeInsets.all(20.0),
// // //       child: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //     SizedBox(height: 20),
// // //     CircleAvatar(
// // //     radius: 50,
// // //     backgroundImage: NetworkImage(_profileData['profileImage']),
// // //     ),
// // //     SizedBox(height: 20),
// // //         children: [
// // //           Text(
// // //             'Name: ${_profileData!['name']}',
// // //             style: TextStyle(fontSize: 18),
// // //           ),
// // //           SizedBox(height: 10),
// // //           Text(
// // //             'Email: ${_user!.email}',
// // //             style: TextStyle(fontSize: 18),
// // //           ),
// // //           // Add other profile fields here
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }
// //     return SingleChildScrollView(
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.center,
// //         children: <Widget>[
// //           SizedBox(height: 20),
// //           SizedBox(width: 400,),
// //
// //           // backgroundImage: NetworkImage(_profileData['profileImage']),
// //
// //           // Display profile image inside a CircleAvatar if available, else display person icon
// //           _profileData?['profileImage'] != null
// //               ? CircleAvatar(
// //             radius: 60,
// //             backgroundImage: NetworkImage(_profileData?['profileImage']),
// //           )
// //               : CircleAvatar(
// //             radius: 60,
// //             child: Icon(Icons.person, size: 60.0),
// //           ),
// //
// //           SizedBox(height: 20),
// //           //user email
// //           Text(
// //             'Email: ${_user!.email}',
// //             style: TextStyle(fontSize: 16,color: Colors.blue),
// //           ),
// //
// //          //user name
// //           MyTextBox(text: '',
// //             sectionName: 'username', onPressed: () {  },
// //           ),
// //
// //           //dob
// //           MyTextBox(text: '',
// //             sectionName: 'DOB', onPressed: () {  },
// //           ),
// //           MyTextBox(text: '',
// //             sectionName: 'Gender', onPressed: () {  },
// //           ),
// //           MyTextBox(text: '',
// //             sectionName: 'Address', onPressed: () {  },
// //           ),
// //           MyTextBox(text: '',
// //             sectionName: 'Qualification', onPressed: () {  },
// //           ),
// //           MyTextBox(text: '',
// //             sectionName: 'Designation', onPressed: () {  },
// //           ),
// //           MyTextBox(text: '',
// //             sectionName: 'Hobbies', onPressed: () {  },
// //           ),
// //           SizedBox(height: 20,),
// //           Button(onTap:update,
// //               text: "update"),
// //           SizedBox(height: 20,),
// //           // Add other profile details as needed
// //         ],
// //       ),
// //     );
// //
// //   }
// //
//
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import '../components/button.dart';

class EditProfilePage extends StatefulWidget {
  String imageUrl;
  String name;
  String dob;
  String gender;
  String address;
  String qualification;
  String job;
  String hobbies;
  EditProfilePage({required this.imageUrl,required this.name,required this.dob,required this.address,
    required this.gender,required this.qualification,
    required this.job,required this.hobbies});
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//  String _imageUrl='';
   late String _name;
   late String _dob;
  late String _gender;
  late String _address;
  late String _qualification;
  late String _job;
  late String _hobbies;
  User? _user;
  Map<String, dynamic>? _profileData;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _qualificationController = TextEditingController();
  TextEditingController _jobController = TextEditingController();
  TextEditingController _hobbiesController = TextEditingController();

  File? _image;
  final picker = ImagePicker();

  @override
  void initState() {
    _getUserProfile();
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _dobController = TextEditingController(text: widget.dob);
    _genderController =TextEditingController(text: widget.gender);

    _addressController = TextEditingController(text: widget.address);
    _qualificationController = TextEditingController(text: widget.qualification);
    _jobController =TextEditingController(text: widget.job);
    _hobbiesController =TextEditingController(text: widget.hobbies);

  }

  Future<void> _getUserProfile() async {
    _user = _auth.currentUser;
    if (_user != null) {
      DocumentSnapshot profileSnapshot = await _firestore
          .collection('profiles')
          .doc(_user!.email)
          .get();

      if (profileSnapshot.exists) {
        setState(() {
          _profileData = profileSnapshot.data() as Map<String, dynamic>?;
          _nameController.text = _profileData!['name'];
          _dobController.text = _profileData!['dob'];
          _addressController.text = _profileData!['address'];
          _genderController.text = _profileData!['gender'];
          _qualificationController.text = _profileData!['qualification'];
          _jobController.text = _profileData!['job'];
          _hobbiesController.text = _profileData!['hobbies'];
          //_imageUrl=_profileData!['profile_picture'];
        });
      }
    }
  }

  // Future<void> _saveChanges() async {
  //   await _firestore.collection('profiles').doc(_user!.).update({
  //     'name': _nameController.text,
  //     'dob': _dobController.text,
  //     'address': _addressController.text,
  //     'gender': _genderController.text,
  //     'qualification': _qualificationController.text,
  //     'job': _jobController.text,
  //     'hobbies': _hobbiesController.text,
  //   });
  Future<void> _saveChanges() async {
    try {
      if (_user?.email != null) {
        final profilesCollection = _firestore.collection('profiles');

        var snapshot = await profilesCollection.where('email', isEqualTo: _user!.email).get();

        if (snapshot.docs.isNotEmpty) {
          await profilesCollection.doc(snapshot.docs.first.id).update({
            'email':_user!.email,
            'name': _nameController.text,
            'dob': _dobController.text,
            'address': _addressController.text,
            'gender': _genderController.text,
            'qualification': _qualificationController.text,
            'job': _jobController.text,
            'hobbies': _hobbiesController.text,
           // 'profile_picture':_imageUrl,
          });
          print('Changes saved successfully.');
        } else {
          print('Document with email ${_user!.email} not found.');
        }
      } else {
        print(_user!.email);
      }
    } catch (e) {
      print('Error saving changes: $e');
    }
  }
      Future<void> _getImage() async {
        final pickedFile = await picker.pickImage(source: ImageSource.camera);

        if (pickedFile != null) {
          setState(() {
            _image = File(pickedFile.path);
          });
        }
      }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.grey[400],
          appBar: AppBar(
            title: Text('Edit Profile'),
            backgroundColor: Colors.grey[700],
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // _image != null
                //     ? CircleAvatar(
                //   radius: 60,
                //   backgroundImage: FileImage(_image!),
                // )
                //     : _profileData?['profile_picture'] != null
                //     ? CircleAvatar(
                //   radius: 60,
                //   backgroundImage:
                //   NetworkImage(_profileData?['profile_picture']),
                // )
                //     : CircleAvatar(
                //   radius: 60,
                //   child: Icon(Icons.person, size: 60.0),
                // ),
                // SizedBox(height: 20),
                // ElevatedButton(
                //   onPressed: _getImage,
                //   child: Text('Change Profile Picture'),
                // ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextFormField(
                  controller: _dobController,
                  decoration: InputDecoration(labelText: 'Date of Birth'),
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(labelText: 'Address'),
                ),
                TextFormField(
                  controller: _genderController,
                  decoration: InputDecoration(labelText: 'Gender'),
                ),
                TextFormField(
                  controller: _qualificationController,
                  decoration: InputDecoration(labelText: 'Qualification'),
                ),
                TextFormField(
                  controller: _jobController,
                  decoration: InputDecoration(labelText: 'Job'),
                ),
                TextFormField(
                  controller: _hobbiesController,
                  decoration: InputDecoration(labelText: 'Hobbies'),
                ),
                SizedBox(height: 20),
                Button(onTap: _saveChanges,
                    text: "Update"),
              ],
            ),
          ),
        );
      }
    }

