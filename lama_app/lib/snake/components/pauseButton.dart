import 'package:lama_app/snake/snakeGame.dart';
import 'dart:ui';
import 'package:flutter/cupertino.dart';

/// This class represents a Pause and Play button.
class PauseButton{
  final SnakeGame game;

  final Paint _paintButton = Paint()
    ..color = Color(0xffFBFEF5);
  final Paint _paintPausePath = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0
    ..color = Color(0xff000000);
  final double _shadowWidth = 5;

  int _position;
  double _relativeOffsetY;
  double _relativeSize = 0.15;
  double _relativeOffsetX = 0.05;
  Function(bool) _onTap;

  Path _signPath;
  Rect _rectButton;
  Paint _paintShadow;

  double _startX;
  bool _tapped = false;

  /// The constructor needs following parameters:
  /// - the parent [SnakeGame]
  /// - the relative Size of the button related to the screensize
  /// - the position of the button (1 to 5)
  /// - the relative Offset to the Y axis relative to the screensize
  /// - a [Function(bool)] which runs when the button gets tapped
  PauseButton(this.game, this._relativeSize, this._position, this._relativeOffsetY, this._onTap) {
    if (this._position > 5 || this._position <= 0) {
      throw new FormatException("Position out of bounds");
    }
    // space of the button element
    var spacePos = (this.game.screenSize.width -
        ((this.game.screenSize.width * _relativeOffsetX) * 2)) / 5;
    // starting x coordinate
    this._startX = (this._position * spacePos) +
        ((spacePos - (this.game.screenSize.width * this._relativeSize)) / 2) +
        (this.game.screenSize.width * _relativeOffsetX);

    _signPath = getPausePath();

    // button rectangle
    _rectButton = Rect.fromLTWH(
        _startX,
        this._relativeOffsetY * game.screenSize.height + ((this.game.screenSize.width * this._relativeSize) / 2),
        this.game.screenSize.width * _relativeSize,
        this.game.screenSize.width * _relativeSize);

    // shader paint
    _paintShadow = Paint();
    _paintShadow.shader = LinearGradient(
      begin: Alignment.bottomRight,
      end: Alignment.topLeft,
      colors: <Color>[
        Color(0x72000000),
        Color(0x0)
      ],)
        .createShader(
        Rect.fromLTWH(
            _rectButton.left,
            _rectButton.top,
            _rectButton.width,
            _rectButton.height)
    );
  }

  /// This methods returns the [Path] of a sign which looks like the pause icon.
  Path getPausePath() {
    var returnPath = Path();
    var absoluteSize = _relativeSize * this.game.screenSize.width;
    var startY = this._relativeOffsetY * game.screenSize.height + ((this.game.screenSize.width * this._relativeSize) / 2);

    returnPath.moveTo(
        _startX + 0.85 * (absoluteSize / 2),
        startY + (absoluteSize / 3));
    returnPath.lineTo(
        _startX + 0.85 * (absoluteSize / 2),
        startY + (2 * absoluteSize / 3));

    returnPath.moveTo(
        _startX + 1.15 * (absoluteSize / 2),
        startY + (absoluteSize / 3));
    returnPath.lineTo(
        _startX + 1.15 * (absoluteSize / 2),
        startY + (2 * absoluteSize / 3));

    return returnPath;
  }

  /// This methods returns the [Path] of a sign which looks like the play icon.
  Path getPlayPath() {
    var returnPath = Path();
    var absoluteSize = _relativeSize * this.game.screenSize.width;
    var startY = this._relativeOffsetY * game.screenSize.height + ((this.game.screenSize.width * this._relativeSize) / 2);

    returnPath.moveTo(
        _startX + 0.80 * (absoluteSize / 2),
        startY + (2 * absoluteSize / 3));
    returnPath.lineTo(
        _startX + 1.2 * (absoluteSize / 2),
        startY + (absoluteSize / 2));

    returnPath.moveTo(
        _startX + 0.80 * (absoluteSize / 2),
        startY + (absoluteSize / 3));
    returnPath.lineTo(
        _startX + 1.2 * (absoluteSize / 2),
        startY + (absoluteSize / 2));

    returnPath.moveTo(
        _startX + 0.80 * (absoluteSize / 2),
        startY + (2 * absoluteSize / 3));
    returnPath.lineTo(
        _startX + 0.80 * (absoluteSize / 2),
        startY + (absoluteSize / 3));

    return returnPath;
  }

  void render(Canvas c){
    // draw shadow
    c.drawRect(_rectButton.translate(_shadowWidth, _shadowWidth), _paintShadow);
    // draw button
    c.drawRect(_rectButton, _paintButton);
    // draw sign
    c.drawPath(_signPath, _paintPausePath);
  }

  void onTapDown(TapDownDetails d) {
    if (_rectButton.contains(d.localPosition)) {
      // tap switch
      _tapped = !_tapped;

      if (_onTap != null) {
        _onTap(_tapped);
      }

      // alters the path between play and pause
      _signPath = _tapped ? getPlayPath() : getPausePath();
    }
  }
}