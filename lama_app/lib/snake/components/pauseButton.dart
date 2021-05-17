import 'package:lama_app/snake/snakeGame.dart';
import 'dart:ui';
import 'package:flutter/cupertino.dart';


class PauseButton{
  final SnakeGame game;

  Path pausePath;
  Rect _rectButton;
  Paint paintButton;
  Size screenSize;
  Paint paintPausePath = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;
  Paint _paintShadow;
  int _position;
  double _relativeOffsetY;
  double _relativeSize = 0.15;
  double _relativeOffsetX = 0.05;
  Function(bool) _onTap;
  double _spaceBetween;
  bool _tapped = false;
  double _startX;

  PauseButton(this.game, this._relativeSize, this._position, this._relativeOffsetY, this._onTap){
    // space of the button element
    var spacePos = (this.game.screenSize.width -
        ((this.game.screenSize.width * _relativeOffsetX) * 2)) / 5;
    // starting x coordinate
    this._startX = (this._position * spacePos) +
        ((spacePos - (this.game.screenSize.width * this._relativeSize)) / 2) +
        (this.game.screenSize.width * _relativeOffsetX);
    // space between the buttons
    this._spaceBetween = (spacePos - this.game.screenSize.width * this._relativeSize);

    paintButton = Paint();
    paintButton.color = Color(0xffFBFEF5);
    paintPausePath.color = Color(0xff000000);

    pausePath = getPausePath();

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
        Color(0xff000000),
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
    c.drawRect(_rectButton.translate(5, 5), _paintShadow);
    c.drawRect(_rectButton, paintButton);
    c.drawPath(pausePath, paintPausePath);
  }

  void onTapDown(TapDownDetails d) {
    if (_rectButton.contains(d.localPosition)) {
      _tapped = !_tapped;

      if (_onTap != null) {
        _onTap(_tapped);
      }
      pausePath = _tapped ? getPlayPath() : getPausePath();
    }
  }
}