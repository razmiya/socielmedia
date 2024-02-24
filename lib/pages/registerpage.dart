import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socielmedia/pages/profilepage.dart';

import '../auth/authservice.dart';
import '../components/button.dart';
import '../components/textfield.dart';
class Register_Page extends StatefulWidget {
  final void Function()? onTap;
  const Register_Page({super.key,
    required this.onTap});

  @override
  State<Register_Page> createState() => _Register_PageState();
}

class _Register_PageState extends State<Register_Page> {
  final emailController=TextEditingController();
  final passwordController=TextEditingController();
  final confirmpassworsController=TextEditingController();
  //sign up user
  void signUp() async{
    // //show loading circle
    // showDialog(context: context,
    //     builder: (context) => const Center(
    //       child: CircularProgressIndicator(),
    //     ),);
    //Make sure password match
    if(passwordController.text != confirmpassworsController.text){
      //pop loading circle
      Navigator.pop(context);
      //show error to user
      displayMessage("password does not match");
      return;
    }
    // try creating user
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text);
    // final authService = Provider.of<AuthService>(context,listen: false);
    // try{
    //   await authService.signUpWithEmailAndPassword(
    //     emailController.text,
    //     passwordController.text,
    //   );

      // Navigate to add profile page or any other page after successful sign up
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage(email: emailController.text,),
        ),
      );
    }


    on FirebaseAuthException catch(e)
{
  //pop loading circle
  Navigator.pop(context);
  //show error to user
  displayMessage(e.code);
}
  }
  //display a dialog message
  void displayMessage(String message){
    showDialog(
      context: context,
      builder:(context)=> AlertDialog(
        title: Text(message),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50,),
                //logo
                Icon(Icons.lock,size: 80,
                  color: Colors.black,),
                //create account message
                const SizedBox(height: 50,),
                Text("let's create an account for you",
                  style: TextStyle(fontSize: 18),),
                //email textfield
                const SizedBox(height: 50,),
                MyTextField(controller: emailController,
                    hinttext:'Email',
                    obscureText: false),
                const SizedBox(height: 50,),
                //password textfield
                MyTextField(controller: passwordController,
                    hinttext:'Password',
                    obscureText: true),
                const SizedBox(height: 50,),
                //confirm password
                MyTextField(controller: confirmpassworsController,
                    hinttext:'Confirm Password',
                    obscureText: true),
                const SizedBox(height: 50,),
                //sign up button
                Button(onTap:signUp,
                    text: "sign up"),
                //not a member? register now
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("all ready a member ?"),
                      const SizedBox(width: 4,),
                      GestureDetector(
                        onTap:widget.onTap ,
                        child: Text("login now",
                          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue), ),
                      ),

                    ]
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
