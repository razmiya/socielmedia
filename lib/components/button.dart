import 'package:flutter/material.dart';
class Button extends StatelessWidget {
  final void Function() ? onTap;
  final String text;
  Button({super.key,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child:Container(
        decoration:BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(9)
        ) ,
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18
            ),
          ),
        ),
      ),
    );
  }
}
