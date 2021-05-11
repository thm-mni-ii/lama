import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:lama_app/snake/snake_game.dart';

class ScoreDisplay {
  final SnakeGame game;

  int _offsetYTiles;
  int _radiusTiles;
  int _borderThickness;
  Rect _borderRect;
  Rect _fillRect;
  Paint _borderPaint;
  Paint _fillPaint;
  TextPainter _painter;
  TextStyle _textStyle;
  Offset _position;

  /// This class displays the [score] of the [SnakeGame] class.
  ScoreDisplay(this.game, [this._offsetYTiles = 4, this._radiusTiles = 4, this._borderThickness = 2]) {
    // Paint for the text
    _painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    // Style of the text
    _textStyle = TextStyle(
      color: Color(0xbbffffff),
      fontSize: 30,
    );

    // rectangle for the border
    _borderRect = Rect.fromLTWH(
        (game.screenSize.width / 2) - (this.game.tileSize * this._radiusTiles) / 2,
        this._offsetYTiles * this.game.tileSize,
        this.game.tileSize * this._radiusTiles,
        this.game.tileSize * this._radiusTiles);

    // rectangle for the background
    _fillRect = Rect.fromLTWH(
        (game.screenSize.width / 2) - ((this.game.tileSize * this._radiusTiles) / 2) + _borderThickness,
        this._offsetYTiles * this.game.tileSize + _borderThickness / 2,
        this.game.tileSize * this._radiusTiles - _borderThickness * 2,
        this.game.tileSize * this._radiusTiles - _borderThickness);

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