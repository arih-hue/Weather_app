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
      elevation: 0,
      onPressed: onPressed,
      color: Color(0xFF92BBED),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Text(text),);
  }
}