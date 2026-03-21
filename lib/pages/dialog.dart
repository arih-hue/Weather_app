import 'package:flutter/material.dart';
import 'button.dart';

class dialog extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;
  final VoidCallback onCancel;
  dialog({
    super.key,
    required this.controller,
    required this.onSearch,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
