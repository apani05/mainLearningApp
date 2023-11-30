import 'package:flutter/material.dart';

class CardOption extends StatefulWidget {
  String option = '';
  CardOption({
    super.key,this.option = ''
  });

  @override
  State<CardOption> createState() => _CardOptionState();
}

class _CardOptionState extends State<CardOption> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 650,
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,

        ),
        child: Center(child: Text(widget.option)),
      ),

    );
  }
}
