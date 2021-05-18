import 'package:lama_app/snake/snakeGame.dart';
import 'dart:ui';
import 'package:flutter/cupertino.dart';

import '../snakeGame.dart';

class ArrowButtons {
  final SnakeGame game;

  Rect _rectButton;
  Paint _paintButton;
  Paint _paintShadow;
  Paint _paintArrow = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;
  Path _arrowPath;
  int _position;
  double _relativeOffsetY;
  double _relativeSize = 0.15;
  double _relativeOffsetX = 0.00;
  double _spaceBetween;
  Function _onTap;
  bool _clickHandled = true;
  Color _buttonColor = Color(0xff3CDFFF);
  Color _buttonClickColor = Color(0xffbdcbd9);


  ArrowButtons(this.game, this._relativeSize, arrowDirection, this._position, this._relativeOffsetY, this._onTap) {
    // space of the button element
    var spacePos = (this.game.screenSize.width -
        ((this.game.screenSize.width * _relativeOffsetX) * 2)) / 5;
    // starting x coordinate
    var startX = (this._position * spacePos) +
        ((spacePos - (this.game.screenSize.width * this._relativeSize)) / 2) +
        (this.game.screenSize.width * _relativeOffsetX);
    // space between the buttons
    this._spaceBetween = (spacePos - this.game.screenSize.width * this._relativeSize);

    // button rectangle
    _rectButton = Rect.fromLTWH(
        startX,
        this._relativeOffsetY * game.screenSize.height + ((this.game.screenSize.width * this._relativeSize) / 2),
        this.game.screenSize.width * _relativeSize,
        this.game.screenSize.width * _relativeSize);

    // arrow path
    _arrowPath = getArrowPath(arrowDirection, startX);

    // shader paint
    _paintShadow = Paint();
    _paintShadow.shader = RadialGradient(
      colors: [
        Color(0xff000000),
        Color(0x0),
      ],)
        .createShader(
          Rect.fromCircle(
              center: Offset(
                  _rectButton.left + _rectButton.width / 2 + this._spaceBetween,
                  _rectButton.top + _rectButton.height / 2 + this._spaceBetween),
              radius: (_rectButton.width) / 2));

    // button paint
    _paintButton = Paint();
    _paintButton.color = Color(0xff0088ff);

    // arrow paint
    _paintArrow.color = Color(0xff000000);
  }

  Path getArrowPath(int dir, double startX) {
    Path arrowPath = Path();
    var absoluteSize = _relativeSize * this.game.screenSize.width;
    var startY = this._relativeOffsetY * game.screenSize.height + ((this.game.screenSize.width * this._relativeSize) / 2);

    // horizontal line
    if (dir.isEven) {
      arrowPath.moveTo(
          startX + (2 * absoluteSize / 3),
          startY + (absoluteSize / 2)
      );
      arrowPath.lineTo(
          startX + (absoluteSize / 3),
          startY + (absoluteSize / 2)
      );
    }
    else {
      // vertical line
      arrowPath.moveTo(
          startX + (absoluteSize / 2),
          startY + (absoluteSize / 3)
      );
      arrowPath.lineTo(
          startX + (absoluteSize / 2),
          startY + (2 * absoluteSize / 3)
      );
    }

    // left up
    if (dir == 2 || dir == 3) {
      arrowPath.moveTo(
          startX + (absoluteSize / 3),
          startY + (absoluteSize / 2));
      arrowPath.lineTo(
          startX + (absoluteSize / 2),
          startY + (2 * absoluteSize / 3));
    }

    // left down
    if (dir == 2 || dir == 1) {
      arrowPath.moveTo(
          startX + (absoluteSize / 3),
          startY + (absoluteSize / 2)
      );
      arrowPath.lineTo(
          startX + (absoluteSize / 2),
          startY + (absoluteSize / 3)
      );
    }

    // right down
    if (dir == 4 || dir == 1) {
      arrowPath.moveTo(
          startX + (2 * absoluteSize / 3),
          startY + (absoluteSize / 2)
      );
      arrowPath.lineTo(
          startX + (absoluteSize / 2),
          startY + (absoluteSize / 3)
      );
    }

    // right up
    if (dir == 4 || dir == 3) {
      arrowPath.moveTo(
          startX + (2 * absoluteSize / 3),
          startY + (absoluteSize / 2)
      );
      arrowPath.lineTo(
          startX + (absoluteSize / 2),
          startY + (2 * absoluteSize / 3)
      );
    }

    return arrowPath;
  }

  void render(Canvas c) {
    // color when clickes
    if (!_clickHandled) {
      _paintButton.color = _buttonClickColor;
      _clickHandled = true;
    }
    else {
      _paintButton.color = _buttonColor;
    }

    // draw shadow
    c.drawArc(_rectButton.inflate(this._spaceBetween * 1.1), 0, 17, true, _paintShadow);
    // draw button
    c.drawArc(_rectButton, 0, 17, true, _paintButton);
    // draw arrow
    c.drawPath(_arrowPath, _paintArrow);
  }

  void onTapDown(TapDownDetails d) {
    if (_rectButton.contains(d.localPosition)) {
      if (_onTap != null) {
        _onTap();
        // click handler for rendering
        _clickHandled = false;
      }
    }
  }
}