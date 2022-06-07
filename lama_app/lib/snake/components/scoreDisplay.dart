import 'dart:math';
import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:lama_app/snake/snakeGame.dart';

/// This class represents the score display and will render it
class ScoreDisplay {
  final SnakeGame game;
  /// Offset to the top relative to the the a relative size (sqrt(width * height));
  double _offsetYPercent;
  /// radius of the button
  double _radiusPercent;
  /// thickness of the border
  double _borderThickness;
  /// [Path] of the border
  Path _borderPath;
  /// [Rect] of the button
  Rect _fillRect;
  /// [Paint] of the border as default stroke
  final Paint _borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = Color(0x80000000);
  /// [Paint] of the background
  final Paint _fillPaint = Paint()
    ..color = Color(0x4DFD4A6F);
  /// [Color] of the text
  final Color _textColor = Color(0xbbffffff);
  /// [TextPainter] of the text
  TextPainter _painter;
  /// [TextStyle] of the text
  TextStyle _textStyle;
  /// position of the score display
  Offset _position;

  /// This class displays the [score] of the [SnakeGame] class.
  ScoreDisplay(this.game, [this._offsetYPercent = 0.025, this._radiusPercent = 0.15, this._borderThickness = 1.5]) {
    resize();
  }

  void resize() {
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
      fontSize: relativeSize * this._radiusPercent * 0.4,
    );

    // rectangle for the border
    var borderRect = Rect.fromLTWH(
        (game.screenSize.width / 2) - (relativeSize * this._radiusPercent) / 2,
        this._offsetYPercent * relativeSize,
        relativeSize * this._radiusPercent,
        relativeSize * this._radiusPercent);

    // border path
    _borderPath = Path()..arcTo(borderRect, 0.0, 1.999999 * pi, true);

    // rectangle for the background
    _fillRect = Rect.fromLTWH(
        (game.screenSize.width / 2) - ((relativeSize * this._radiusPercent) / 2) + _borderThickness,
        this._offsetYPercent * relativeSize + _borderThickness / 2,
        relativeSize * this._radiusPercent - _borderThickness * 2,
        relativeSize * this._radiusPercent - _borderThickness);

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
    c.drawArc(_fillRect, 0, 10, true, _fillPaint);
    // draw text
    _painter.paint(c, _position);
  }
}