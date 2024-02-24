import 'package:flutter/material.dart';
import '../pages/loginpage.dart';
import '../pages/registerpage.dart';
class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  //initially throw the login page
  bool showLoginPage=true;
  //toggle between login oe register page
  void togglePages(){
    setState(() {
      showLoginPage=!showLoginPage;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showLoginPage){
      return LoginPage(onTap: togglePages);
    }else
    {
      return Register_Page(onTap: togglePages);
    }
    return const Placeholder();
  }
}
