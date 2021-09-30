import 'package:flutter/material.dart';

import 'LamaTextTheme.dart';

class EquationItemWidget extends StatelessWidget {
  final BoxConstraints constraints;
  final Color color;
  final String text;
  final double fontSize;

  EquationItemWidget(this.constraints, this.color, this.text,
      {this.fontSize = 15});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: (constraints.maxWidth / 100) * 12,
        height: (constraints.maxHeight / 100) * 7,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)), color: color),
        child: Center(
            child: Text(
          text,
          textAlign: TextAlign.center,
          style: LamaTextTheme.getStyle(fontSize: fontSize),
        )));
  }
}
