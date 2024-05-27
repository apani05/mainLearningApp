import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final String labelText;
  final Color textColor;
  final bool obscureText;
  final TextEditingController controller;
  final bool? suffix;

  const MyTextField({
    super.key,
    required this.labelText,
    required this.textColor,
    required this.obscureText,
    required this.controller,
    this.suffix,
  });

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: widget.textColor),
        labelText: widget.labelText,
        suffixIcon: widget.suffix != null
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
                child: Icon(
                  showPassword ? Icons.visibility : Icons.visibility_off,
                  color: widget.textColor,
                ),
              )
            : null,
      ),
      obscureText: !showPassword && widget.obscureText,
    );
  }
}
