import 'package:flame/components/component.dart';
import 'package:flutter/painting.dart';
import 'package:lama_app/flappyLama/flappyLamaGame.dart';
import 'package:flame/components/component.dart';
import 'dart:ui';

class GameOverView extends Component {
  final FlappyLamaGame game;
  Paint bgPaint;
  Rect bgRect;
  TextPainter _painter = TextPainter(
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
  );
  TextStyle _textStyle;
  Offset _position;

  GameOverView(this.game) {
    bgRect = Rect.fromLTWH(
      this.game.tileSize * 1,
      this.game.tileSize * 1,
      this.game.screenSize.width - this.game.tileSize * 2,
      this.game.tileSize * 10,
    );
    bgPaint = Paint()..color = Color(0xFF4A7AEA);
    _textStyle = TextStyle(
      color: Color(0xff000000),
      fontSize: 25,
    );
    _position = Offset.zero;
  }

  void update(t) {
    if ((_painter.text ?? '') != game.score.toString()) {
      _painter.text = TextSpan(
        text: "Score\n",
        style: _textStyle,
        children: <TextSpan>[
          TextSpan(
            text: game.score.toString(),
            style: TextStyle(
              fontSize: this.game.screenSize.height * 0.1,
              fontFamily: 'Serif',
              color: Color(0xFFFFFFFF),
            ),
          ),
        ],
      );

      _painter.layout();
      _position = Offset(
        (bgRect.left) + (bgRect.width / 2) - _painter.width / 2,
        (bgRect.top) + (bgRect.height / 2) - _painter.height / 2,
      );
    }
  }

  void render(Canvas c) {
    c.drawRect(bgRect, bgPaint);
    _painter.paint(c, _position);
  }
}
