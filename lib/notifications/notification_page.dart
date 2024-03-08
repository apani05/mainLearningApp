import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';

import 'local_notification.dart';
import 'notification_usage.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TimeOfDay selectedRemindingTime = TimeOfDay.now();
  double commitedTime = 5;
  bool isReminderOn = false;
  bool congratulatoryPopupShown = false;
  AppUsageService appUsageService = AppUsageService();

  @override
  void initState() {
    super.initState();
    LocalNotifications.init(initScheduled: true);
    appUsageService.usageTimeStream.listen((int appUsageTimeInSeconds) {
      if (appUsageTimeInSeconds >= commitedTime * 60 &&
          isReminderOn == true &&
          !congratulatoryPopupShown) {
        congratulatoryPopupShown = true;
        _showCongratulatoryPopup();
      }
    });
  }

  @override
  void dispose() {
    appUsageService.dispose();
    super.dispose();
  }

  void _showCongratulatoryPopup() {
    showModalBottomSheet(
      backgroundColor: Color(0xFFcccbff),
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 140,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Congratulations!',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Center(
                child: Text(
                  'You have finished your daily quota of ${commitedTime.toInt()} minutes today.',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pop();
    });
  }

  void _scheduleNotification() {
    LocalNotifications().showScheduleNotification(
      title: "Study time!",
      body: "Start your daily session for ${commitedTime.toInt()} minutes.",
      payload: 'lol',
      scheduledTimeHour: selectedRemindingTime.hour,
      scheduledTimeMinute: selectedRemindingTime.minute,
    );

    // LocalNotifications().showScheduleNotification(
    //   title: "Congratulation!",
    //   body: "You have finished your daily quota for today. Keep Learning!!",
    //   payload: 'lol',
    //   scheduledTimeHour: selectedRemindingTime.hour,
    //   scheduledTimeMinute: selectedRemindingTime.minute + commitedTime.toInt(),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFFcccbff),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Opacity(
                opacity: isReminderOn ? 1.0 : 0.5,
                child: Column(
                  children: [
                    _buildReminderRow0(),
                    _buildReminderRow1(),
                    const SizedBox(height: 8),
                    _buildReminderRow2(),
                  ],
                ),
              )
            ]),
      ),
    );
  }

  Widget _buildReminderRow0() {
    return Row(
      children: [
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
            activeColor: Color(0xFFcccbff),
            onChanged: ((bool value) {
              setState(() {
                isReminderOn = value;
                _scheduleNotification();
              });
            })),
      ],
    );
  }

  Widget _buildReminderRow1() {
    int selectedHour = selectedRemindingTime.hour;
    String selectedMinute = selectedRemindingTime.minute > 9
        ? "${selectedRemindingTime.minute}"
        : "0${selectedRemindingTime.minute}";
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
        IgnorePointer(
          ignoring: !isReminderOn,
          child: GestureDetector(
            onTap: () async {
              final TimeOfDay? timeOfDay = await showTimePicker(
                context: context,
                initialTime: selectedRemindingTime,
                initialEntryMode: TimePickerEntryMode.dialOnly,
              );
              if (timeOfDay != null) {
                setState(() {
                  selectedRemindingTime = timeOfDay;
                  _scheduleNotification();
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
              decoration: BoxDecoration(
                color: Color(0xFFcccbff),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                selectedHour >= 0 && selectedHour <= 12
                    ? "$selectedHour:$selectedMinute AM"
                    : "${selectedHour - 12}:$selectedMinute PM",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildReminderRow2() {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              "Select your commitment time",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            const Spacer(),
            IgnorePointer(
              ignoring: !isReminderOn,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: SpinBox(
                          min: 5,
                          max: 60,
                          step: 5,
                          readOnly: true,
                          direction: Axis.vertical,
                          incrementIcon:
                              const Icon(Icons.arrow_drop_up_rounded),
                          decrementIcon:
                              const Icon(Icons.arrow_drop_down_rounded),
                          value: commitedTime,
                          onChanged: (value) {
                            setState(() {
                              commitedTime = value;
                              _scheduleNotification();
                            });
                          },
                        ),
                      );
                    },
                  );
                },
                child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
                    decoration: BoxDecoration(
                      color: Color(0xFFcccbff),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      '${commitedTime.toInt()} min',
                      style: const TextStyle(color: Colors.white),
                    )),
              ),
            )
          ],
        )
      ],
    );
  }
}
