
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socielmedia/pages/home.dart';

import '../components/button.dart';

class ProfilePage extends StatefulWidget {
  String email;
  ProfilePage({required this.email});
  @override
  _ProfilePageState createState() => _ProfilePageState();

}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  File? _image;
  String imageUrl = '';

  TextEditingController _nameController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _jobController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _qualificationController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _hobbiesController = TextEditingController();

  // Future<void> _uploadImage() async {
  //   final pickedFile = await _picker.pickImage(source: ImageSource.camera);
  //
  //   setState(() {
  //     if (pickedFile != null) {
  //       _image = File(pickedFile.path);
  //     } else {
  //       print('No image selected.');
  //     }
  //   });
  //   if (_image != null) {
  //     Reference ref = _storage.ref().child('profile_images/${DateTime.now().toString()}');
  //     UploadTask uploadTask = ref.putFile(_image!);
  //     TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
  //     imageUrl = await taskSnapshot.ref.getDownloadURL();
  //     print(imageUrl);
  //   }
  // }

  Future<void> _uploadImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        print(_image);
      } else {
        print('No image selected.');
      }
    });

    if (_image != null) {
      Reference ref = _storage.ref().child('profile_images/${DateTime.now().toString()}');
      UploadTask uploadTask = ref.putFile(_image!);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

       String Url = await taskSnapshot.ref.getDownloadURL();
       setState(() {
         imageUrl=Url;
       });
       print(imageUrl);
      // Save the image URL into Firestore
      // await _firestore.collection('profiles').add({
      //   'image_url': imageUrl,
      //   // Optionally, you can associate the image with a user by storing user ID or email
      //   'user_email': widget.email,
      //   // You can also include a timestamp or any other relevant data
      //   'timestamp': DateTime.now(),
      // });

      print('Image uploaded and URL saved to Firestore: $imageUrl');
    }
  }

  Future<void> _saveProfile() async {
    print(imageUrl);
    print("/////");
    await _firestore.collection('profiles').add({
      'name': _nameController.text,
      'dob': _dobController.text,
      'job': _jobController.text,
     'email': widget.email,
      'address': _addressController.text,
      'qualification': _qualificationController.text,
      'gender': _genderController.text,
      'hobbies': _hobbiesController.text,
      'profile_picture': imageUrl,
    });

    // Clear text controllers after saving profile
    _nameController.clear();
    _dobController.clear();
    _emailController.clear();
    _dobController.clear();
    _addressController.clear();
    _qualificationController.clear();
    _genderController.clear();
    _hobbiesController.clear();

    // Optionally, navigate to another page after saving profile
   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[500],
      appBar: AppBar(
        title: Text('Profile',style: TextStyle(),),
        backgroundColor: Colors.grey[700],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: _uploadImage,
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null ? Icon(Icons.add_a_photo, size: 40) : null,
                ),
              ),
            ),
            SizedBox(height: 20),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),

              child: TextField(
                controller:_nameController ,
                decoration: InputDecoration(
                  hintText: 'Name',
                  suffixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),

              child: TextField(
                //controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  suffixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0,),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),

              child: TextField(
                controller: _genderController,
                decoration: InputDecoration(
                  hintText: 'gender',
                  suffixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),

              child: TextField(
                controller: _dobController,
                decoration: InputDecoration(
                  hintText: 'dob',
                  suffixIcon: Icon(Icons.calendar_month),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),

              child: TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  hintText: 'Address',
                  suffixIcon: Icon(Icons.home),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),

              child: TextField(
                controller: _qualificationController,
                decoration: InputDecoration(
                  hintText: 'qualification',
                  suffixIcon: Icon(Icons.school),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0,),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 15),

        child: TextField(
          controller: _jobController,
          decoration: InputDecoration(
            hintText: 'job',
            suffixIcon: Icon(Icons.work),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
      ),


            SizedBox(height: 20.0,),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),

              child: TextField(
                controller: _hobbiesController,
                decoration: InputDecoration(
                  hintText: 'Hobbies',
                  suffixIcon: Icon(Icons.image),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            SizedBox(width: 30,),
            Button(onTap:_saveProfile,
                text: "SAVE"),
          ],
        ),
      ),
    );
  }
}
