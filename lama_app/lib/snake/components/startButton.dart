import 'dart:ui';
import '../snakeGame.dart';
import '../views/view.dart';
import 'package:flutter/painting.dart';

class StartButton {
  final SnakeGame game;

  RRect rect;
  Paint startPaint = Paint()
    ..color = Color(0xff6dff4a);
  TextPainter _painter = TextPainter(
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
  );
  TextStyle _textStyle;
  Offset _position;
  List<double> _buttonOffset = [0.7, 0.1, 0.1, 0.1];

  StartButton(this.game, double relativeX, double relativeY) {
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
      text: "Start",
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
    c.drawRRect(rect, startPaint);
    
    // draw text
    _painter.paint(c, _position);
  }

  void update(double t) {}

  void onTapDown() {
    game.activeView = View.playing;
  }
}
