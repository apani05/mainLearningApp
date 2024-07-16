import 'package:bfootlearn/components/color_file.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget customAppBar({
  required BuildContext context,
  required String title,
  List<Widget>? actions,
}) {
  return AppBar(
    actions: actions,
    leading: IconButton(
      icon: const Icon(
        Icons.arrow_back_rounded,
        color: Colors.white,
        size: 30,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
    leadingWidth: 60,
    titleSpacing: 0,
    title: Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 25,
        fontWeight: FontWeight.w500,
      ),
    ),
    backgroundColor: purpleLight2,
  );
}
