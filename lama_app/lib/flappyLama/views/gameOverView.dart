import 'package:flame/components/component.dart';
import 'package:flutter/painting.dart';
import 'package:lama_app/flappyLama/flappyLamaGame.dart';
import 'package:flame/components/component.dart';
import 'dart:ui';

class GameOverView extends Component {
  final FlappyLamaGame game;
  Paint bgPaint;
  Rect bgRect;
  TextPainter _painter;
  TextStyle _textStyle;
  Offset _position;
  final relativeX = 0.05;
  final relativeY = 0.05;

  GameOverView(this.game) {
    bgRect = Rect.fromLTWH(
        this.game.screenSize.width * relativeX,
        this.game.screenSize.height * relativeY,
        this.game.screenSize.width * (1 - relativeX * 2),
        this.game.screenSize.height * (1 - relativeY * 3));

    bgPaint = Paint()..color = Color(0xFF4A7AEA);

    //painter of the text
    _painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    //text style
    _textStyle = TextStyle(
      color: Color(0xff000000),
      fontSize: this.game.screenSize.height * 0.05,
    );
    _position = Offset.zero;
  }

  void update(double t) {
    if ((_painter.text ?? '') != game.score.toString()) {
      _painter.text = TextSpan(
        text: "Score:",
        style: _textStyle,
        children: <TextSpan>[
          TextSpan(
            text: game.score.toString(),
            style: TextStyle(
              fontSize: this.game.screenSize.height * 0.05,
              fontFamily: 'Serif',
              color: Color(0xFF000000),
            ),
            children: <TextSpan>[
              TextSpan(
                text: "\nGame Over",
                style: TextStyle(
                  fontSize: this.game.screenSize.height * 0.1,
                  fontFamily: 'Serif',
                  color: Color(0xFFFFFFFF),
                ),
              ),
            ],
          ),
        ],
      );

      _painter.layout();
      _position = Offset(
        (bgRect.left) + (bgRect.width / 2) - _painter.width / 2,
        (bgRect.top) + (bgRect.height / 3) - _painter.height / 2,
      );
    }
  }

  void render(Canvas c) {
    c.drawRect(bgRect, bgPaint);
    _painter.paint(c, _position);
  }
}
