import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../components/my_textfield.dart';
import '../../helper/helper_functions.dart';
import '../../riverpod/river_pod.dart';

class PasswordChangePage extends ConsumerStatefulWidget {
  const PasswordChangePage({super.key});

  @override
  _PasswordChangePageState createState() => _PasswordChangePageState();
}

class _PasswordChangePageState extends ConsumerState<PasswordChangePage> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  bool _isChangingPassword = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final theme = ref.watch(themeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WillPopScope(
        onWillPop: () async {
          FocusScope.of(context).unfocus();
          await Future.delayed(Duration(milliseconds: 300));
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () async {
                FocusScope.of(context).unfocus();
                await Future.delayed(Duration(milliseconds: 300));
                Navigator.pop(context);
              },
            ),
            title: Text(
              'Change Password',
            ),
            backgroundColor: theme.lightPurple,
          ),
          body: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(mediaQuery.size.width * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyTextField(
                      labelText: 'Old Password',
                      textColor: theme.lightPurple,
                      obscureText: true,
                      controller: oldPasswordController,
                      suffix: true,
                    ),
                    SizedBox(height: mediaQuery.size.height * 0.02),
                    MyTextField(
                      labelText: 'New Password',
                      textColor: theme.lightPurple,
                      obscureText: true,
                      controller: newPasswordController,
                      suffix: true,
                    ),
                    SizedBox(height: mediaQuery.size.height * 0.02),
                    ElevatedButton(
                      onPressed: _isChangingPassword
                          ? null
                          : () => _changePassword(context),
                      child: Text(
                        'Change Password',
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.lightPurple,
                      ),
                    ),
                  ],
                ),
              ),
              if (_isChangingPassword)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _changePassword(BuildContext context) async {
    try {
      setState(() {
        _isChangingPassword = true;
      });

      String oldPassword = oldPasswordController.text;
      String newPassword = newPasswordController.text;

      if (oldPassword.isNotEmpty && newPassword.isNotEmpty) {
        AuthCredential credential = EmailAuthProvider.credential(
          email: FirebaseAuth.instance.currentUser!.email!,
          password: oldPassword,
        );
        await FirebaseAuth.instance.currentUser!
            .reauthenticateWithCredential(credential);

        await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
        displayMessageToUser("Password changed successfully", context);
      } else {
        displayMessageToUser(
            "Please enter both old and new passwords", context);
      }
    } catch (e) {
      print("Error changing password: $e");
      displayMessageToUser("Error changing password", context);
    } finally {
      setState(() {
        _isChangingPassword = false;
      });
    }
  }
}
