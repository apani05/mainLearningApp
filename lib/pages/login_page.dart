import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../User/user_model.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../helper/helper_functions.dart';
import '../riverpod/river_pod.dart';
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

  void login() async {
    final userProvide = ref.read(userProvider);
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
     final UserCredential =  await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
     if(UserCredential.user != null && UserCredential.user!.uid.isNotEmpty){
      var isExsist = await userProvide.checkIfUserExistsInDb(UserCredential.user!.uid);
      print("user is exsist $isExsist");
      if(!isExsist){
        await userProvide.createUserInDb(
            UserModel(name: UserCredential.user!.displayName ?? emailController.text,
                uid: UserCredential.user!.uid,
                imageUrl: UserCredential.user!.photoURL ?? '',
                score: 0,
                rank: 0,
                heart: 0,
                userName: emailController.text.split('@').first,
                email: emailController.text,
                savedWords: [],
            badge: CardBadge(kinship: false, direction: false, classroom: false, time: false, weather: false),
              joinedDate: DateTime.now().toString(),
            ),UserCredential.user!.uid
        );
        print("user is created with uid ${UserCredential.user!.uid}");
      }
     }
     if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'user-not-found') {
        displayMessageToUser('No user found on that email!', context);
      } else if (e.code == 'invalid-login-credentials') {
        displayMessageToUser('The password is wrong!', context);
      } else {
        displayMessageToUser(e.code, context);
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
              const Text(
                "Blackfoot Application",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFcccbff)),
              ),
              const SizedBox(height: 25),
              MyTextField(
                  obscureText: false,
                  controller: emailController, labelText: '', textColor:Colors.white ,),
              const SizedBox(height: 10),
              MyTextField(
                  labelText: "Password",
                  obscureText: true,
                  controller: passwordController, textColor: Colors.white,),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ForgotPasswordPage();
                      }));
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              MyButton(
                text: "Login",
                onTap: login,
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
