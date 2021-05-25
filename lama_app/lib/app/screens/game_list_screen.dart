import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lama_app/util/LamaColors.dart';

class TaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [LamaColors.greenAccent, LamaColors.greenPrimary],
          ),
        ),
        child: SafeArea(
          child: Container(
            color: Colors.white,
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return Center(child: Text("GameList"));
            }),
          ),
        ),
      ),
    );
  }
}
