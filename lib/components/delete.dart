import 'package:flutter/material.dart';
class Delete extends StatelessWidget {
  final void Function()? onTap;
  const Delete({super.key,
  required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onTap ,
      child: const Icon(Icons.cancel,
        color: Colors.black,),
    );
  }
}
