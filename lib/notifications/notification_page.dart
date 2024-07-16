import 'package:bfootlearn/components/color_file.dart';
import 'package:bfootlearn/components/custom_appbar.dart';
import 'package:bfootlearn/notifications/notification_provider.dart';
import 'package:bfootlearn/notifications/showPermissionDeniedDialog.dart';
import 'package:bfootlearn/riverpod/river_pod.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import 'local_notification.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  void initState() {
    super.initState();
    LocalNotifications.init(initScheduled: true);
  }

  void _scheduleNotification() {
    final notificationProvide = ref.watch(notificationProvider);
    int remindTimeHr = notificationProvide.remindTimeHr;
    int remindTimeMin = notificationProvide.remindTimeMin;
    debugPrint("$remindTimeHr : $remindTimeMin");
    LocalNotifications().showScheduleNotification(
      title: "Study time!",
      body: "Start your daily session.",
      payload: "You can do it!",
      scheduledTimeHour: remindTimeHr,
      scheduledTimeMinute: remindTimeMin,
    );
  }

  @override
  Widget build(BuildContext context) {
    final notificationProvide = ref.watch(notificationProvider);
    bool isReminderOn = notificationProvide.isReminderOn;

    return Scaffold(
      appBar: customAppBar(context: context, title: 'Notifications'),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/DiscussionForum_Image.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Opacity(
                  opacity: isReminderOn ? 1.0 : 0.5,
                  child: Column(
                    children: [
                      _buildReminderRow0(isReminderOn),
                      _buildReminderRow1(isReminderOn),
                      const SizedBox(height: 8),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> requestNotificationPermission(
      {required NotificationProvider notificationProvide}) async {
    // Request permission for notifications
    var status = await Permission.notification.request();
    if (status.isGranted) {
      setState(() {
        notificationProvide.toggleReminderMode();
        _scheduleNotification();
      });
    } else if (status.isDenied || status.isPermanentlyDenied) {
      // Permission is denied, handle this case accordingly
      showPermissionDeniedDialog(
          context: context,
          content:
              'Notification permission is required to enable study reminders. Please enable it in the app settings.');
    }
  }

  Widget _buildReminderRow0(bool isReminderOn) {
    final notificationProvide = ref.watch(notificationProvider);
    return Row(children: [
      const Text(
        "Study Reminder",
        style: TextStyle(
          color: Colors.black,
          fontSize: 25,
        ),
      ),
      const Spacer(),
      Switch(
          value: isReminderOn,
          activeColor: purpleLight,
          onChanged: (bool value) async {
            if (value) {
              // Request permission when enabling the reminder
              await requestNotificationPermission(
                  notificationProvide: notificationProvide);
            } else {
              setState(() {
                notificationProvide.toggleReminderMode();
              });
            }
          }),
    ]);
  }

  // Schedule Learning Row
  Widget _buildReminderRow1(bool isReminderOn) {
    return Row(
      children: [
        const Text(
          "Schedule your learning time",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        const Spacer(),
        selectReminderTime(isReminderOn),
      ],
    );
  }

  // Button for scheduling reminder time
  Widget selectReminderTime(bool isReminderOn) {
    final notificationProvide = ref.watch(notificationProvider);

    int remindTimeHr = notificationProvide.remindTimeHr;
    int remindTimeMin = notificationProvide.remindTimeMin;
    String formatTime(int hour, int minute) {
      // Create a DateTime object with the provided hour and minute
      DateTime dateTime = DateTime(0, 1, 1, hour, minute);

      // Format the DateTime object to the desired format
      DateFormat timeFormat = DateFormat.jm();

      return timeFormat.format(dateTime);
    }

    return IgnorePointer(
      ignoring: !isReminderOn,
      child: GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              builder: ((BuildContext context) {
                return timePickerDialog(remindTimeHr, remindTimeMin);
              }));
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
          decoration: BoxDecoration(
            color: purpleLight,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            formatTime(remindTimeHr, remindTimeMin),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget timePickerDialog(int hr, int min) {
    final notificationProvide = ref.watch(notificationProvider);

    return showPicker(
      isInlinePicker: true,
      elevation: 1,
      value: Time(hour: hr, minute: min),
      onChange: (Time time) {
        setState(() {
          notificationProvide.setRemindTime(
            time.hour,
            time.minute,
            time.second,
          );
          _scheduleNotification();
        });
      },
      onCancel: () {
        Navigator.of(context).pop();
      },
      hourLabel: 'hr',
      minuteLabel: 'min',
      showCancelButton: false,
      iosStylePicker: true,
      minHour: 0,
      maxHour: 23,
      is24HrFormat: false,
      okText: 'Done',
    );
  }
}
