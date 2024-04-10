import 'package:bfootlearn/riverpod/river_pod.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';

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
    double commitedTime = notificationProvide.commitedTime;
    int remindTimeHr = notificationProvide.remindTimeHr;
    int remindTimeMin = notificationProvide.remindTimeMin;
    debugPrint("$remindTimeHr : $remindTimeMin");
    LocalNotifications().showScheduleNotification(
      title: "Study time!",
      body: "Start your daily session for ${commitedTime.toInt()} minutes.",
      payload: 'lol',
      scheduledTimeHour: remindTimeHr,
      scheduledTimeMinute: remindTimeMin,
    );
  }

  @override
  Widget build(BuildContext context) {
    final notificationProvide = ref.watch(notificationProvider);
    bool isReminderOn = notificationProvide.isReminderOn;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFcccbff),
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
                    _buildReminderRow0(isReminderOn),
                    _buildReminderRow1(isReminderOn),
                    const SizedBox(height: 8),
                    _buildReminderRow2(isReminderOn),
                  ],
                ),
              )
            ]),
      ),
    );
  }

  Widget _buildReminderRow0(bool isReminderOn) {
    final notificationProvide = ref.watch(notificationProvider);
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
            activeColor: const Color(0xFFcccbff),
            onChanged: ((bool value) {
              setState(() {
                notificationProvide.toggleReminderMode();
                _scheduleNotification();
              });
            })),
      ],
    );
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
    int selectedHour = remindTimeHr;
    String selectedMinute =
        remindTimeMin > 9 ? "$remindTimeMin" : "0$remindTimeMin";
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
            color: const Color(0xFFcccbff),
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

  Widget _buildReminderRow2(bool isReminderOn) {
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
            selectCommitTime(isReminderOn),
          ],
        )
      ],
    );
  }

  Widget selectCommitTime(bool isReminderOn) {
    final notificationProvide = ref.watch(notificationProvider);
    double commitedTime = notificationProvide.commitedTime;
    return IgnorePointer(
      ignoring: !isReminderOn,
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: SpinBox(
                  min: 0,
                  max: 60,
                  step: 1,
                  readOnly: true,
                  direction: Axis.vertical,
                  incrementIcon: const Icon(Icons.arrow_drop_up_rounded),
                  decrementIcon: const Icon(Icons.arrow_drop_down_rounded),
                  value: commitedTime,
                  onChanged: (value) {
                    setState(() {
                      notificationProvide.setCommitedTime(value);
                      _scheduleNotification();
                    });
                  },
                ),
              );
            },
          );
        },
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFcccbff),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              '${commitedTime.toInt()} min',
              style: const TextStyle(color: Colors.white),
            )),
      ),
    );
  }
}
