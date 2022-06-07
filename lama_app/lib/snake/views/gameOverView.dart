import 'dart:ui';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lama_app/snake/components/goBackButton.dart';
import 'package:lama_app/snake/snakeGame.dart';

/// This class will render game overview with all its components
class GameOverView {
  final SnakeGame game;
  /// offset to the left and right relative to the screen width
  final relativeX = 0.15;
  /// offset to the top and bottom relative to the screen height
  final relativeY = 0.15;
  /// back button of the view
  GoBackButton goBackButton;
  /// [Paint] of the background
  Paint _bgPaint = Paint()
    ..color = Color(0xFFFFFFFF);
  /// [Paint] of the border
  Paint _borderPaint = Paint()
    ..color = Color(0xFF000000);
  /// [TextPainter] of the text
  TextPainter _painter = TextPainter(
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
  );
  /// thickness of the border
  double _borderThickness = 3;
  /// rectangle of the background
  Rect _bgRect;
  /// position of the text
  Offset _position;
  /// textstyle of the text
  TextStyle _textStyle;

  GameOverView(this.game) {
    this.goBackButton = GoBackButton(game);
    resize();
  }

  void resize() {
    this.goBackButton?.resize();

    // calculate the relative size
    var relativeSize = sqrt(this.game.screenSize.width * this.game.screenSize.height);

    // calculate the background rectangle
    _bgRect = Rect.fromLTWH(
      this.game.screenSize.width * relativeX,
      this.game.screenSize.height * relativeY,
      this.game.screenSize.width * (1.0 - relativeX * 2),
      this.game.screenSize.height * (1.0 - relativeY * 4),
    );

    // set the textstyle
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
