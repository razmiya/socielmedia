import 'package:flutter/material.dart';
class MyTextField extends StatelessWidget {
  TextEditingController controller;
  String hinttext;
  final bool obscureText;

  MyTextField({
    super.key,
    required this.controller,
    required this.hinttext,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText:obscureText ,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color:Theme.of(context).colorScheme.secondary),
        ),
        focusedBorder: const OutlineInputBorder(
            borderSide:BorderSide(color: Colors.white),

        ),
        fillColor:Theme.of(context).colorScheme.primary,
        filled: true,
        hintText: hinttext,
        hintStyle: const TextStyle(color: Colors.white),
      ),
    );
  }
}
