import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';

import '../helper/helper_functions.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPwdController = TextEditingController();

  void registerUser() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    if (passwordController.text != confirmPwdController.text) {
      Navigator.pop(context);
      displayMessageToUser("Passwords don't match", context);
    } else {
      try {
        UserCredential? userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);
        Navigator.pop(context);
        displayMessageToUser("Successfully Registered", context);
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        if (e.code == 'weak-password') {
          displayMessageToUser('The password provided is too weak.', context);
        } else if (e.code == 'email-already-in-use') {
          displayMessageToUser(
              'The account already exists for that email.', context);
        } else {
          displayMessageToUser(e.code, context);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Blackfoot Application",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple),
              ),
              const SizedBox(height: 25),
              MyTextField(
                  hintText: "User Name",
                  obscureText: false,
                  controller: userNameController),
              const SizedBox(height: 10),
              MyTextField(
                  hintText: "Email",
                  obscureText: false,
                  controller: emailController),
              const SizedBox(height: 10),
              MyTextField(
                  hintText: "Password",
                  obscureText: true,
                  controller: passwordController),
              const SizedBox(height: 10),
              MyTextField(
                  hintText: "Confirm Password",
                  obscureText: true,
                  controller: confirmPwdController),
              const SizedBox(height: 20),
              MyButton(
                text: "Register",
                onTap: registerUser,
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  const Text("Already have an account? "),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      "Login Here",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )));
  }
}
