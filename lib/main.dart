import 'package:bfootlearn/login/authentication/auth.dart';
import 'package:bfootlearn/notifications/notification_usage.dart';
import 'package:bfootlearn/riverpod/river_pod.dart';
import 'package:bfootlearn/route/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';
import 'notifications/local_notification.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await LocalNotifications.init(initScheduled: true);
  var initialNotification =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  // double commitedTime = 0.1;
  // bool isReminderOn = true;
  AppUsageService appUsageService = AppUsageService();

  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ref.read(themeProvider).getTheme();
    //   final notificationProvide = ref.read(notificationProvider);
    //   appUsageService.usageTimeStream.listen((int appUsageTimeInSeconds) {
    //     if (appUsageTimeInSeconds >= notificationProvide.commitedTime * 60 &&
    //         notificationProvide.isReminderOn == true) {
    //       showCongoSnackBar();
    //     }
    //   });
    // });

    super.initState();
  }

  void _scheduleCongoSnackbar() {
    final notificationProvide = ref.read(notificationProvider);
    debugPrint(
        "${notificationProvide.commitedTime} & ${notificationProvide.isReminderOn}");
    appUsageService.usageTimeStream.listen((int appUsageTimeInSeconds) {
      if (appUsageTimeInSeconds >= notificationProvide.commitedTime * 60 &&
          notificationProvide.isReminderOn) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showCongoSnackBar();
        });
      }
    });
  }

  @override
  void dispose() {
    appUsageService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scheduleCongoSnackbar();
    var theme = ref.watch(themeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ipoyit',
      theme: theme.themeData,
      onGenerateRoute: RouteGenerator.generateRoute,
      home: const AuthPage(),
    );
  }

  void showCongoSnackBar() {
    final notificationProvide = ref.watch(notificationProvider);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: const Color(0xFFcccbff),
      content: Row(
        children: [
          const Text(
            'Congratulations!',
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            'You have finished your daily quota of ${notificationProvide.commitedTime.toInt()} minutes today.',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          )
        ],
      ),
      duration: const Duration(seconds: 5),
      width: 280.0, // Width of the SnackBar.
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0, // Inner padding for SnackBar content.
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ));
  }
}
