import 'package:flutter/material.dart';

void displayMessageToUser(String message, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          message,
          style: TextStyle(
            // Add your preferred text styles here
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    },
  );

  // Automatically dismiss the AlertDialog after 3 seconds
  Future.delayed(Duration(seconds: 3), () {
    Navigator.of(context).pop();
  });
}
