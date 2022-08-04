import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  Color? color;
  bool? newTask;
  final void Function() onPressed;

  CustomBottomNavigationBar({
    required this.color,
    required this.newTask,
    required this.onPressed,
  });
  @override
  Widget build(Object context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: color,
        ),
        onPressed: onPressed,
        child: Text(newTask! ? "Task hinzufügen" : "Task verändern"),
      ),
    );
  }
}
