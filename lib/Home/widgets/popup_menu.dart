import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bfootlearn/login/views/change_password.dart';
import 'package:bfootlearn/notifications/notification_page.dart';
import 'package:bfootlearn/Home/views/ack_page.dart';

class CustomPopupMenu extends StatelessWidget {
  final Function(String) onSelected;

  const CustomPopupMenu({Key? key, required this.onSelected}) : super(key: key);

  void handlePopupMenuSelection(BuildContext context, String value) {
    switch (value) {
      case 'signOut':
        FirebaseAuth.instance.signOut();
        break;
      case 'changePassword':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PasswordChangePage()),
        );
        break;
      case 'localNotifications':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SettingsPage()),
        );
        break;
      case 'acknowledgements':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Acknowledegement()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) => handlePopupMenuSelection(context, value),
      color: Colors.white,
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem<String>(
            value: 'acknowledgements',
            child: ListTile(
              leading: Icon(Icons.school, color: Color(0xff6562df)),
              title: Text(
                'Acknowledgements',
                style: TextStyle(color: Color(0xff6562df)),
              ),
            ),
          ),
          const PopupMenuItem<String>(
            value: 'localNotifications',
            child: ListTile(
              leading: Icon(Icons.notifications, color: Color(0xff6562df)),
              title: Text(
                'Notifications',
                style: TextStyle(color: Color(0xff6562df)),
              ),
            ),
          ),
          const PopupMenuItem<String>(
            value: 'changePassword',
            child: ListTile(
              leading: Icon(Icons.password_rounded, color: Color(0xff6562df)),
              title: Text(
                'Change Password',
                style: TextStyle(color: Color(0xff6562df)),
              ),
            ),
          ),
          const PopupMenuItem<String>(
            value: 'signOut',
            child: ListTile(
              leading: Icon(Icons.exit_to_app, color: Color(0xff6562df)),
              title: Text(
                'Sign Out',
                style: TextStyle(color: Color(0xff6562df)),
              ),
            ),
          ),
        ];
      },
    );
  }
}
