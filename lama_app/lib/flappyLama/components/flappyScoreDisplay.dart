import 'dart:math';
import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:lama_app/flappyLama/flappyLamaGame.dart';

class FlappyScoreDisplay {
  final FlappyLamaGame game;

  double _sizePercent;
  RRect _fillRRect;
  final Paint _fillPaint = Paint()
    ..color = Color(0xff2b1d14);
  final Color _textColor = Color(0xffffffff);
  TextPainter _painter;
  TextStyle _textStyle;
  Offset _position;

  FlappyScoreDisplay(this.game, [this._sizePercent = 0.25]) {
    // relative length related to the screensize
    var relativeSize = sqrt(this.game.screenSize.width * this.game.screenSize.height);

    // Paint for the text
    _painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    // Style of the text
    _textStyle = TextStyle(
      color: _textColor,
      fontSize: relativeSize * this._sizePercent * 0.2,
    );
  

    // rectangle for the background
    _fillRRect = RRect.fromLTRBR(
        game.screenSize.width/2 - game.screenSize.width * _sizePercent,
        game.screenSize.height*0.83,
        game.screenSize.width/2 + game.screenSize.width * _sizePercent,
        game.screenSize.height*0.90,
        Radius.circular(20.0));

    // initialize offset
    _position = Offset.zero;
  }

  void update(double t) {
    // different score?
    if ((_painter.text ?? '') != game.score.toString()) {
      _painter.text = TextSpan(
        text: "Score :    " + game.score.toString(),
        style: _textStyle,
      );

      _painter.layout();

      // set new offset depending on the text width
      _position = Offset(
        (_fillRRect.left) + (_fillRRect.width / 2) - _painter.width / 2,
          (_fillRRect.top) + (_fillRRect.height / 2) - _painter.height / 2,
      );
    }
  }

  void render(Canvas c) {
   
    // draw background
    c.drawRRect(_fillRRect,_fillPaint);
    // draw text
    _painter.paint(c, _position);
  }
}