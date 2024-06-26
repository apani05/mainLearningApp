import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';

void showPermissionDeniedDialog({required BuildContext context}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Permission Denied'),
        content: const Text(
            'Notification permission is required to enable study reminders. Please enable it in the app settings.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
          TextButton(
            onPressed: () {
              AndroidIntent intent = const AndroidIntent(
                action: "android.settings.APPLICATION_DETAILS_SETTINGS",
                package: "bfootlearn",
                data: "package:bfootlearn",
              );
              intent.launch();
              Navigator.of(context).pop();
            },
            child: const Text('Open Settings'),
          ),
        ],
      );
    },
  );
}
