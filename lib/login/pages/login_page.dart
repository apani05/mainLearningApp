import 'package:bfootlearn/helper/helper_functions.dart';
import 'package:flutter/material.dart';
import '../../components/my_button.dart';
import '../../components/my_textfield.dart';
import 'forgot_pwd_page.dart';
import '../widget/fadein_animation.dart';
import '../widget/login_theme_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bfootlearn/riverpod/river_pod.dart';

class LoginPage extends ConsumerStatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool showPassword = false;
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String errorMessage = e.code.replaceAll('-', ' ');
      errorMessage = errorMessage[0].toUpperCase() + errorMessage.substring(1);
      Navigator.pop(context);
      displaySnackBarMessageToUser(errorMessage, context);
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
                      "Welcome Back",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: theme.lightPurple,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  FadeIn(
                    child: MyTextField(
                        controller: emailController,
                        textColor: theme.lightPurple,
                        labelText: 'Email',
                        obscureText: false),
                  ),
                  const SizedBox(height: 10),
                  FadeIn(
                    child: MyTextField(
                      controller: passwordController,
                      textColor: theme.lightPurple,
                      labelText: 'Password',
                      obscureText: true,
                      suffix: true,
                    ),
                  ),
                  const SizedBox(height: 10),
                  FadeIn(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return ForgotPasswordPage();
                              }),
                            );
                          },
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  FadeIn(
                    child: MyButton(
                      text: "Login",
                      onTap: login,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      const Text("Don't have an account? "),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          "Register Here",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
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
