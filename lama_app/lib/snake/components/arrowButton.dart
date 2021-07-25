import 'package:lama_app/snake/snakeGame.dart';
import 'dart:ui';
import 'package:flutter/cupertino.dart';

import '../snakeGame.dart';

/// This class will render an arrow button and handle if its tapped.
class ArrowButton {
  final SnakeGame game;
  /// [Rect] of the button location
  Rect _rectButton;
  /// [Paint] of the button fill
  Paint _paintButton;
  /// [Paint] of the button shadow
  Paint _paintShadow;
  /// [Paint] of the button arrow
  Paint _paintArrow = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;
  /// [Path] of the arrow depending on [_arrowDirection]
  Path _arrowPath;
  /// Position of the button between 0 and 4 (left to right)
  int _position;
  /// Relative Offset of the Button to the top of the screen
  double _relativeOffsetY;
  /// Relative Size of the button to the width of the screen
  double _relativeSize = 0.15;
  /// Relative Offset of the Button to the left of the screen
  double _relativeOffsetX = 0.00;
  /// Function which gets called when the button tapped
  Function _onTap;
  /// flag which which checks the button tap
  bool _clickHandled = true;
  /// [Color] of the button
  Color _buttonColor = Color(0xff3CDFFF);
  /// [Color] of the button on tapping
  Color _buttonClickColor = Color(0xffbdcbd9);
  /// direction of the Arrow (1-4)
  int _arrowDirection = 0;
  /// width of the buttons shadow
  final double _shadowWidth = 5;

  ArrowButton(this.game, this._relativeSize, this._arrowDirection, this._position, this._relativeOffsetY, this._onTap) {
    // button paint
    _paintButton = Paint();
    _paintButton.color = Color(0xff0088ff);

    // arrow paint
    _paintArrow.color = Color(0xff000000);

    resize();
  }

  void resize() {
    // space of the button element
    var spacePos = (this.game.screenSize.width -
        ((this.game.screenSize.width * _relativeOffsetX) * 2)) / 5;
    // starting x coordinate
    var startX = (this._position * spacePos) +
        ((spacePos - (this.game.screenSize.width * this._relativeSize)) / 2) +
        (this.game.screenSize.width * _relativeOffsetX);

    // button rectangle
    _rectButton = Rect.fromLTWH(
        startX,
        this._relativeOffsetY * game.screenSize.height + ((this.game.screenSize.width * this._relativeSize) / 2),
        this.game.screenSize.width * _relativeSize,
        this.game.screenSize.width * _relativeSize);

    // arrow path
    _arrowPath = getArrowPath(_arrowDirection, startX);

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
    c.drawArc(_rectButton.translate(_shadowWidth, _shadowWidth), 0, 17, true, _paintShadow);
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