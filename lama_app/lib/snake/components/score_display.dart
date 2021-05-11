import 'dart:math';
import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:lama_app/snake/snake_game.dart';

class ScoreDisplay {
  final SnakeGame game;

  double _offsetYPercent;
  double _radiusPercent;
  int _borderThickness;
  Rect _borderRect;
  Rect _fillRect;
  Paint _borderPaint;
  Paint _fillPaint;
  TextPainter _painter;
  TextStyle _textStyle;
  Offset _position;

  /// This class displays the [score] of the [SnakeGame] class.
  ScoreDisplay(this.game, [this._offsetYPercent = 0.1, this._radiusPercent = 0.15, this._borderThickness = 2]) {
    // relative length related to the screensize
    var relativeSize = sqrt(this.game.screenSize.width * this.game.screenSize.height);

    // Paint for the text
    _painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    // Style of the text
    _textStyle = TextStyle(
      color: Color(0xbbffffff),
      fontSize: relativeSize * this._radiusPercent * 0.4,
    );

    // rectangle for the border
    _borderRect = Rect.fromLTWH(
        (game.screenSize.width / 2) - (relativeSize * this._radiusPercent) / 2,
        this._offsetYPercent * relativeSize,
        relativeSize * this._radiusPercent,
        relativeSize * this._radiusPercent);

    // rectangle for the background
    _fillRect = Rect.fromLTWH(
        (game.screenSize.width / 2) - ((relativeSize * this._radiusPercent) / 2) + _borderThickness,
        this._offsetYPercent * relativeSize + _borderThickness / 2,
        relativeSize * this._radiusPercent - _borderThickness * 2,
        relativeSize * this._radiusPercent - _borderThickness);

    // background paint
    _fillPaint = Paint();
    _fillPaint.color = Color(0x66E87070);

    // border paint
    _borderPaint = Paint();
    _borderPaint.color = Color(0x66000000);

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
    c.drawArc(_borderRect, 0, 10, true, _borderPaint);
    // draw background
    c.drawArc(_fillRect, 0, 10, true, _fillPaint);
    // draw text
    _painter.paint(c, _position);
  }
}