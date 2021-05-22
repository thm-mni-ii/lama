import 'dart:math';
import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:lama_app/flappyLama/flappyLamaGame.dart';

class FlappyScoreDisplay {
  final FlappyLamaGame game;

  double _offsetYPercent;
  double _sizePercent;
  double _borderThickness;
  Path _borderPath;
  Rect _fillRect;
  final Paint _borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = Color(0x80000000);
  final Paint _fillPaint = Paint()
    ..color = Color(0xff8888888);
  final Color _textColor = Color(0xff000000);
  TextPainter _painter;
  TextStyle _textStyle;
  Offset _position;

  FlappyScoreDisplay(this.game, [this._offsetYPercent = 0.025, this._sizePercent = 0.11, this._borderThickness = 1.5]) {
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
      fontSize: relativeSize * this._sizePercent * 0.4,
    );
  

    // rectangle for the background
    _fillRect = Rect.fromLTWH(
        (game.screenSize.width / 2) - ((relativeSize * this._sizePercent) / 2) + _borderThickness,
        game.screenSize.height*0.75 + this._offsetYPercent * relativeSize + _borderThickness / 2,
        relativeSize * this._sizePercent - _borderThickness * 2,
        relativeSize * this._sizePercent - _borderThickness);

    _borderPath = Path()..addRect(_fillRect);
    _borderPaint.strokeWidth = _borderThickness;

    // initialize offset
    _position = Offset.zero;
  }

  void update(double t) {
    // different score?
    if ((_painter.text ?? '') != game.score.toString()) {
      _painter.text = TextSpan(
        text: game.score.toString(),
        style: _textStyle,
      );

      _painter.layout();

      // set new offset depending on the text width
      _position = Offset(
        (_fillRect.left) + (_fillRect.width / 2) - _painter.width / 2,
          (_fillRect.top) + (_fillRect.height / 2) - _painter.height / 2,
      );
    }
  }

  void render(Canvas c) {
    // draw border
    c.drawPath(_borderPath, _borderPaint);
    // draw background
    c.drawRect(_fillRect,_fillPaint);
    // draw text
    _painter.paint(c, _position);
  }
}