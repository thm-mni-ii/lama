import 'dart:math';
import 'package:flutter/material.dart';

import 'block_objects/iblock.dart';
import 'block_objects/block.dart';
import 'block_objects/jblock.dart';
import 'block_objects/lblock.dart';
import 'block_objects/sblock.dart';
import 'block_objects/sqblock.dart';
import 'block_objects/tblock.dart';
import 'block_objects/zblock.dart';
import 'tetrisGame.dart';

Block getRamdomBlock() {
  int randomNumber = Random().nextInt(7);
  switch (randomNumber) {
    case 0:
      return IBlock(BOARD_WIDTH);
    case 1:
      return JBlock(BOARD_WIDTH);
    case 2:
      return LBlock(BOARD_WIDTH);
    case 3:
      return SBlock(BOARD_WIDTH);
    case 4:
      return SquareBlock(BOARD_WIDTH);
    case 5:
      return TBlock(BOARD_WIDTH);
    case 6:
      return ZBlock(BOARD_WIDTH);
    default:
      return IBlock(BOARD_WIDTH);
  }
}

Widget getTetrisPoint(Color color) {
  return Container(
    width: POINT_SIZE,
    height: POINT_SIZE,
    decoration: BoxDecoration(
      color: color,
      border: Border.all(
        color: Colors.black,
        width: 1.5,
      ),
      borderRadius: BorderRadius.circular(2.0),
      gradient: LinearGradient(colors: [color, Colors.blueAccent]),
      boxShadow: [
        BoxShadow(color: Colors.grey, blurRadius: 2.0, offset: Offset(2.0, 2.0))
      ],
      shape: BoxShape.rectangle,
    ),
  );
}

Widget getGameOverButton(context) => ButtonTheme(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: ElevatedButton(
          onPressed: () {
            timer.cancel();
            Navigator.pop(context);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(fontSize: 20),
          ),
          child: const Text('Spiel verlassen'),
        ),
      ),
    );

Widget getGameOverText(int score, int? userHighscore, int allTimeHighScore) {
  if (score > allTimeHighScore) {
    return Center(
      child: Text(
        'WOW, du hast einen neuen Highscore\n Punkte: $score',
        style: const TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 76, 175, 157),
          shadows: [
            Shadow(
              color: Colors.black,
              blurRadius: 3.0,
              offset: Offset(2.0, 2.0),
            )
          ],
        ),
      ),
    );
  } else if (score > userHighscore!) {
    return Center(
      child: Text(
        'Klasse, du hast einen neuen persöhnlichen Highscore\n Punkte: $score',
        style: const TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 76, 175, 157),
          shadows: [
            Shadow(
              color: Colors.black,
              blurRadius: 3.0,
              offset: Offset(2.0, 2.0),
            )
          ],
        ),
      ),
    );
  } else {
    return Center(
      child: Text(
        'Game Over\n Punkte: $score',
        style: const TextStyle(
          fontSize: 35.0,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
          shadows: [
            Shadow(
              color: Colors.black,
              blurRadius: 3.0,
              offset: Offset(2.0, 2.0),
            )
          ],
        ),
      ),
    );
  }
}
