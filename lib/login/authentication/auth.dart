import 'package:bfootlearn/adminProfile/pages/admin_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../riverpod/river_pod.dart';
import 'login_or_register.dart';
import 'verify_email.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userProvide = ref.read(userProvider);
            return FutureBuilder(
              future: userProvide.getRole(snapshot.data!.uid),
              builder: (context, roleSnapshot) {
                if (roleSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (roleSnapshot.hasError) {
                  return Center(child: Text('Error: ${roleSnapshot.error}'));
                } else {
                  String role = roleSnapshot.data ?? '';
                  debugPrint("role: $role");

                  if (role == 'admin') {
                    return const AdminPage();
                  } else {
                    return const EmailVerifyPage();
                  }
                }
              },
            );
          } else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
