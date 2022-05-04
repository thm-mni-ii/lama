import 'package:flutter/material.dart';

class ScoreDisplayTetris extends StatelessWidget {
  final int score;
  final String textueberScore;
  const ScoreDisplayTetris(
      this.score, this.textueberScore); //, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 100,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: Colors.blue),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          "$textueberScore\n$score",
          textAlign: TextAlign.center,
          style: (const TextStyle(
            color: Colors.white,
          )),
        ));
  }
}
