import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bfootlearn/riverpod/river_pod.dart';
import '../../components/my_button.dart';
import '../../components/my_textfield.dart';
import '../../helper/helper_functions.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      String email = emailController.text.trim();
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('email', isEqualTo: email)
              .get();
      if (querySnapshot.docs.isEmpty) {
        Navigator.pop(context);
        displayMessageToUser("No user found with this email.", context);
        return;
      }
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Navigator.pop(context);
      displayMessageToUser("Password Reset link sent!", context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      displaySnackBarMessageToUser(e.message.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              if (mounted) {
                Navigator.pop(context);
              }
            },
          ),
          title: Text('Forgot Password'),
          backgroundColor: theme.lightPurple,
        ),
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Text(
                  "Enter your email to receive a password reset link",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(height: 10),
              MyTextField(
                  labelText: "Email",
                  obscureText: false,
                  controller: emailController,
                  textColor: theme.lightPurple),
              SizedBox(height: 10),
              MyButton(
                text: "Reset Password",
                onTap: () {
                  passwordReset();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
