import 'package:bfootlearn/components/color_file.dart';
import 'package:bfootlearn/helper/helper_functions.dart';
import 'package:bfootlearn/riverpod/river_pod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../User/user_model.dart';
import '../../components/my_button.dart';
import '../../components/my_textfield.dart';
import '../widget/fadein_animation.dart';
import '../widget/login_theme_page.dart';
import 'forgot_pwd_page.dart';

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
    final userProvide = ref.read(userProvider);

    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
      if (userCredential.user != null && userCredential.user!.uid.isNotEmpty) {
        var isExists =
            await userProvide.checkIfUserExistsInDb(userCredential.user!.uid);
        print("user is exist $isExists");

        if (!isExists) {
          await userProvide.createUserInDb(
              UserModel(
                name: userCredential.user!.displayName ?? emailController.text,
                uid: userCredential.user!.uid,
                imageUrl: userCredential.user!.photoURL ?? '',
                role: 'user',
                score: 0,
                rank: 0,
                heart: 0,
                userName: emailController.text.split('@').first,
                email: emailController.text,
                badge: CardBadge(
                    kinship: false,
                    direction: false,
                    classroom: false,
                    time: false,
                    weather: false),
                joinedDate: DateTime.now().toString(),
                savedWords: [],
                savedPhrases: [],
              ),
              userCredential.user!.uid);
          print("user is created with uid ${userCredential.user!.uid}");
        }else{
          print("user is exist with uid ${userCredential.user!.uid}");

        }
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = e.code.replaceAll('-', ' ');
      errorMessage = errorMessage[0].toUpperCase() + errorMessage.substring(1);

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
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  FadeIn(
                    child: Text(
                      "Welcome Back",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: purpleLight,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  FadeIn(
                    child: MyTextField(
                        controller: emailController,
                        textColor: purpleLight,
                        labelText: 'Email',
                        obscureText: false),
                  ),
                  const SizedBox(height: 10),
                  FadeIn(
                    child: MyTextField(
                      controller: passwordController,
                      textColor: purpleLight,
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
                                return const ForgotPasswordPage();
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
