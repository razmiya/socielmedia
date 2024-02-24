import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/authservice.dart';
import '../components/button.dart';
import '../components/textfield.dart';
class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key,
    required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  //text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

 // sign in user
  void signIn() async {
    //show loading circle
    showDialog(context: context,
        builder: (context)=> const Center(
          child: CircularProgressIndicator(),
        ),
    );
    //try signin


    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,

    );
      //pop loading circle
      if(context.mounted)Navigator.pop(context);
    }on FirebaseAuthException catch(e){
      print(e.code);
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
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50,),
                  //logo
                  Icon(Icons.lock, size: 80,
                    color: Colors.grey[900],),
                  //welcome back message
                  const SizedBox(height: 50,),
                  Text("welcome back you will have been missed",
                    style: TextStyle(fontSize: 18),),
                  //email textfield
                  const SizedBox(height: 50,),
                  MyTextField(controller: emailController,
                      hinttext: 'Email',
                      obscureText: false),
                  const SizedBox(height: 50,),
                  //password textfield
                  MyTextField(controller: passwordController,
                      hinttext: 'Password',
                      obscureText: true),
                  const SizedBox(height: 50,),
                  //sign in button
                  Button(onTap: signIn,
                      text: "sign in"),
                  const SizedBox(height: 10,),
                  //not a member? register now
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("not a member ?"),
                        const SizedBox(width: 4,),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: const Text("register now",
                            style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue),),
                        ),

                      ]
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

