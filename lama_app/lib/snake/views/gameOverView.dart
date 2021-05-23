import 'dart:ui';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lama_app/snake/components/goBackButton.dart';
import 'package:lama_app/snake/snakeGame.dart';

class GameOverView {
  final SnakeGame game;

  final relativeX = 0.15;
  final relativeY = 0.15;

  GoBackButton goBackButton;

  Paint _bgPaint = Paint()
    ..color = Color(0xFFFFFFFF);
  Paint _borderPaint = Paint()
    ..color = Color(0xFF000000);
  TextPainter _painter = TextPainter(
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
  );
  double _borderThickness = 3;
  Rect _bgRect;
  Offset _position;
  TextStyle _textStyle;

  GameOverView(this.game) {
    this.goBackButton = GoBackButton(game);
    resize();
  }

  void resize() {
    this.goBackButton?.resize();

    var relativeSize = sqrt(this.game.screenSize.width * this.game.screenSize.height);

    _bgRect = Rect.fromLTWH(
      this.game.screenSize.width * relativeX,
      this.game.screenSize.height * relativeY,
      this.game.screenSize.width * (1.0 - relativeX * 2),
      this.game.screenSize.height * (1.0 - relativeY * 4),
    );

    _textStyle = TextStyle(
      color: Color(0xff000000),
      fontSize: relativeSize * 0.10,
    );

    _position = Offset.zero;
  }

  void render(Canvas c) {
    c.drawRRect(RRect.fromRectAndRadius(_bgRect.inflate(_borderThickness), Radius.circular(35.0)), _borderPaint);
    c.drawRRect(RRect.fromRectAndRadius(_bgRect, Radius.circular(35.0)), _bgPaint);

    _painter.paint(c, _position);
    goBackButton.render(c);
  }

  void update(double t) {
    if ((_painter.text ?? '') != game.score.toString()) {
      _painter.text = TextSpan(
        text: "Punkte\n",
        style: _textStyle,
        children: <TextSpan>[
          TextSpan(
            text: game.score.toString(),
            style: TextStyle(
              fontSize: this.game.screenSize.height * 0.15,
              fontFamily: 'Serif',
              color: Color(0xFF208421),
              shadows: <Shadow>[
                Shadow(
                  blurRadius: 10,
                  color: Color(0xff000000),
                  offset: Offset(2, 2),
                ),
              ],
            ),
          ),
        ],
      );

      _painter.layout();
      _position = Offset(
          game.screenSize.width/2 - _painter.width / 2,
          (this.game.screenSize.height * (1.0 - relativeY * 4) / 2) + this.game.screenSize.height * relativeY -_painter.height / 2,
      );
    }
  }
}
