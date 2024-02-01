import 'package:flutter/material.dart';
import '../../components/my_button.dart';
import '../../components/my_textfield.dart';
import '../widget/fadein_animation.dart';
import '../widget/login_theme_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bfootlearn/riverpod/river_pod.dart';
import '../../helper/helper_functions.dart';

class RegisterPage extends ConsumerStatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPwdController = TextEditingController();
  bool showPassword = false;

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
        String errorMessage = e.code.replaceAll('-', ' ');
        errorMessage =
            errorMessage[0].toUpperCase() + errorMessage.substring(1);
        displayMessageToUser(errorMessage, context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        reverse: true,
        child: Column(
          children: [
            LoginPageTop(),
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  FadeIn(
                    child: Text(
                      "Hello There!",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: theme.lightPurple,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  FadeIn(
                    child: MyTextField(
                        controller: userNameController,
                        textColor: theme.lightPurple,
                        labelText: 'User Name',
                        obscureText: false),
                  ),
                  const SizedBox(height: 8),
                  FadeIn(
                    child: MyTextField(
                        controller: emailController,
                        textColor: theme.lightPurple,
                        labelText: 'Email',
                        obscureText: false),
                  ),
                  const SizedBox(height: 8),
                  FadeIn(
                    child: MyTextField(
                        controller: passwordController,
                        textColor: theme.lightPurple,
                        labelText: 'Password',
                        obscureText: true),
                  ),
                  const SizedBox(height: 8),
                  FadeIn(
                    child: MyTextField(
                      controller: confirmPwdController,
                      textColor: theme.lightPurple,
                      labelText: 'Confirm Password',
                      obscureText: true,
                      suffix: true,
                    ),
                  ),
                  const SizedBox(height: 25),
                  FadeIn(
                    child: MyButton(
                      text: "Register",
                      onTap: registerUser,
                    ),
                  ),
                  const SizedBox(height: 18),
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
            ),
          ],
        ),
      ),
    );
  }
}
