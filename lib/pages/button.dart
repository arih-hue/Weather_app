import 'package:flutter/material.dart';

class button extends StatelessWidget {
  final String text;
  VoidCallback onPressed;
  button({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 40,
      minWidth: 100,
      elevation: 0,
      onPressed: onPressed,
      color: Color(0xFF92BBED),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Text(text,style: TextStyle(fontSize: 20),),);
  }
}