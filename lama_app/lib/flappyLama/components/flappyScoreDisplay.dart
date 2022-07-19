import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/painting.dart';
import 'package:lama_app/flappyLama/flappyLamaGame.dart';
import 'package:lama_app/newFlappyLamaGame/baseFlappy.dart';
import 'package:lama_app/util/LamaColors.dart';

/// This class extends [Component] and describes a the score display.
/// It will have a fixed position on the screen and will use the [score] field of the
/// [FlappyLamaGame] class which is needed to create this class.
class FlappyScoreDisplay extends Component {
  @override
  // TODO: implement priority
  int get priority => super.priority;
  @override
  set priority(int newPriority) {
    // TODO: implement priority
    super.priority = newPriority;
  }

  // SETTINGS
  // --------
  /// Paint for the rectangle fill
  final Paint _fillPaint = Paint()
    ..color = LamaColors.bluePrimary.withOpacity(0.6);

  /// Text color of the score
  final Color _textColor = Color(0xffffffff);

  /// Width relative to the screen
  final double _widthPercent = 0.25;

  /// size of the font relative to the screensize {relativeSize * _sizePercent * _relativeFontSize}
  final double _relativeFontSize = 0.2;

  /// padding : [top, bottom]
  final _padding = [0.83, 0.1];
  // --------
  // SETTINGS

  final FlappyLamaGame2 _game;

  /// [Rect] of the score field
  late RRect _fillRRect;

  /// [TextPainter] of the score text
  late TextPainter _painter;

  /// [TextStyle] of the text
  late TextStyle _textStyle;

  /// Position [Offset] of the text
  late Offset _position;

  FlappyScoreDisplay(this._game) {
    priority = 10;
    // relative length related to the screensize
    var relativeSize =
        sqrt(this._game.screenSize.width * this._game.screenSize.height);

    // Paint for the text
    _painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    // Style of the text
    _textStyle = TextStyle(
      color: _textColor,
      fontSize: relativeSize * _widthPercent * _relativeFontSize,
    );

    // rectangle for the background
    _fillRRect = RRect.fromLTRBR(
        _game.screenSize.width / 2 - _game.screenSize.width * _widthPercent,
        _game.screenSize.height * _padding[0],
        _game.screenSize.width / 2 + _game.screenSize.width * _widthPercent,
        _game.screenSize.height * (1 - _padding[1]),
        Radius.circular(20.0));

    // initialize offset
    _position = Offset.zero;
  }

  void update(double t) {
    // different score?
    if ((_painter.text ?? '') != _game.score.toString()) {
      // set new text
      _painter.text = TextSpan(
        text: "Punkte :    ${_game.score.toString()}",
        style: _textStyle,
      );

      _painter.layout();

      // set new offset depending on the text width
      _position = Offset(
          (_fillRRect.left) + (_fillRRect.width / 2) - _painter.width / 2,
          (_fillRRect.top) + (_fillRRect.height / 2) - _painter.height / 2);
    }
  }

  void render(Canvas c) {
    // draw background
    c.drawRRect(_fillRRect, _fillPaint);
    // draw text
    _painter.paint(c, _position);
  }
}
