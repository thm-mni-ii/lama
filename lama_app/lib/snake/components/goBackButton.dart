import 'dart:ui';
import '../snakeGame.dart';
import 'package:flutter/painting.dart';

/// This class contains a visualsation of a back button
class GoBackButton {
  final SnakeGame game;
  /// [RRect] of the button (rounded rectangle)
  RRect rect;
  /// [Paint] of the rounded button
  Paint _startPaint = Paint()
    ..color = Color(0xff6dff4a);
  /// [TextPainter] of the text with default centering and left to right
  TextPainter _painter = TextPainter(
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
  );
  /// [TextStyle] of the text
  TextStyle _textStyle;
  /// position of the text
  Offset _position;
  /// Offset of the button [top, left, right, bottom]
  final _buttonOffset = [0.7, 0.1, 0.1, 0.1];

  GoBackButton(this.game) {
    resize();
  }

  void resize() {
    rect = RRect.fromLTRBR(
      this.game.screenSize.width * _buttonOffset[1],
      this.game.screenSize.height * _buttonOffset[0],
      this.game.screenSize.width * (1.0 - _buttonOffset[2]),
      this.game.screenSize.height * (_buttonOffset[0] + _buttonOffset[3]),
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
  }

  void render(Canvas c) {
    c.drawRRect(rect, _startPaint);
    
    // draw text
    _painter.paint(c, _position);
  }

  void update(double t) {}

  void onTapDown() {}
}
