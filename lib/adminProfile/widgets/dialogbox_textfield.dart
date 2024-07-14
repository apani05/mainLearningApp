import 'package:flutter/material.dart';

class DialogBoxTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  const DialogBoxTextField({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        hintStyle: dialogBoxHintStyle,
        border: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(15))),
      ),
    );
  }
}

TextStyle dialogBoxHintStyle = const TextStyle(
  color: Colors.black,
  fontSize: 16,
  fontWeight: FontWeight.normal,
);
