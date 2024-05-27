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
  void displaySnackBarMessageToUser(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.white,
        ),
      ),
      backgroundColor:
          Color.fromARGB(255, 230, 125, 118), // Adjust the color as needed
      duration: Duration(seconds: 3),
    ),
  );
}

setTitle(String title){
  
}

