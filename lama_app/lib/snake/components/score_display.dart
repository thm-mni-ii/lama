import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:lama_app/snake/snake_game.dart';

class ScoreDisplay {
  final SnakeGame game;

  TextPainter painter;
  TextStyle textStyle;
  Offset position;

  ScoreDisplay(this.game) {
    painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textStyle = TextStyle(
      color: Color(0xBBffffff),
      fontSize: 50,
      shadows: <Shadow>[
        Shadow(
          blurRadius: 7,
          color: Color(0xBB000000),
          offset: Offset(3, 3),
        ),
      ],
    );

    position = Offset.zero;
  }

  void update(double t) {
    if ((painter.text ?? '') != game.score.toString()) {
      painter.text = TextSpan(
        text: game.score.toString(),
        style: textStyle,
      );

      painter.layout();

      position = Offset(
        (game.screenSize.width / 2) - (painter.width / 2),
        0,
      );
    }
  }

  void render(Canvas c) {
    painter.paint(c, position);
  }
}