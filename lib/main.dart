import 'package:bfootlearn/auth/auth.dart';
import 'package:bfootlearn/riverpod/river_pod.dart';
import 'package:bfootlearn/route/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'Home/views/home_view.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(
    child: MyApp(),
  ),);
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends ConsumerState<MyApp> {

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      ref.read(themeProvider).getTheme();
    });
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    var theme = ref.watch(themeProvider);
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
    //  theme: theme.themeData,
      onGenerateRoute: RouteGenerator.generateRoute,
      home:  AuthPage(),
    );
  }
}




