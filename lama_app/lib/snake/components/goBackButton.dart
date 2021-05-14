import 'dart:ui';
import '../snakeGame.dart';
import '../views/view.dart';
import 'package:flutter/painting.dart';

class GoBackButton {
  final SnakeGame game;

  RRect rect;
  Paint startPaint;
  TextPainter _painter;
  TextStyle _textStyle;
  Offset _position;

  GoBackButton(this.game, double relativeX, double relativeY) {
    var buttonOffset = [0.7, 0.1, 0.1, 0.1];

    rect = RRect.fromLTRBR(
      this.game.screenSize.width * buttonOffset[1],
      this.game.screenSize.height * buttonOffset[0],
      this.game.screenSize.width * (1.0 - buttonOffset[2]),
      this.game.screenSize.height * (buttonOffset[0] + buttonOffset[3]),
      Radius.circular(20.0),
    );

    // Style of the text
    _textStyle = TextStyle(
      color: Color(0xbbffffff),
      fontSize: this.game.screenSize.height * 0.05,
      shadows: <Shadow>[
        Shadow(
          blurRadius: 10,
          color: Color(0xff000000),
          offset: Offset(2, 2),
        ),
      ],
    );

    // Paint for the text
    _painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    _painter.text = TextSpan(
      text: "Spiel verlassen",
      style: _textStyle,
    );

    _painter.layout();

    // set new offset depending on the text width
    _position = Offset(
      (rect.left) + (rect.width / 2) - _painter.width / 2,
      (rect.top) + (rect.height / 2) - _painter.height / 2,
    );

    startPaint = Paint();
    startPaint.color = Color(0xff6dff4a);
  }

  void render(Canvas c) {
    c.drawRRect(rect, startPaint);
    
    // draw text
    _painter.paint(c, _position);
  }

  void update(double t) {}

  void onTapDown() {}
}
