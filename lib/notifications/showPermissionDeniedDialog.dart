import 'package:flutter/material.dart';

void showPermissionDeniedDialog(
    {required BuildContext context, required String content}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Permission Denied'),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
