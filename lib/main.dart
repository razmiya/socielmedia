import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:socielmedia/auth/auth.dart';
import 'package:socielmedia/auth/loginorregister.dart';
import 'package:socielmedia/pages/loginpage.dart';
import 'package:socielmedia/pages/profilepage.dart';
import 'package:socielmedia/thems/darkthem.dart';
import 'package:socielmedia/thems/lighttheme.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp  extends StatelessWidget {
  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     debugShowCheckedModeBanner: false,
      // theme: lightTheme,
      // darkTheme: darkTheme,
      home: const AuthGate(),
    );
  }
}
