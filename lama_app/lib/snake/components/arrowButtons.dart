import 'package:lama_app/snake/snakeGame.dart';
import 'dart:ui';
import 'package:flutter/cupertino.dart';

import '../snakeGame.dart';

class ArrowButtons {
  final SnakeGame game;

  Rect rectButton;
  Paint paintButton;
  Paint paintShadow;
  Paint _paintArrow = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;
  Path _arrowPath;
  int _position;
  double _relativeOffsetY;
  double _relativeSize = 0.15;
  double _relativeOffsetX = 0.05;
  double _spaceBetween;
  Function _onTap;
  static const IconData arrow_back = IconData(0xe5a7, fontFamily: 'MaterialIcons', matchTextDirection: true);


  ArrowButtons(this.game, this._relativeSize, arrowDirection, this._position, this._relativeOffsetY, this._onTap) {

    //lining out the path for the arrows
    _arrowPath = Path();

    var spacePos = (this.game.screenSize.width -
        ((this.game.screenSize.width * _relativeOffsetX) * 2)) / 5;
    var startX = (this._position * spacePos) +
        ((spacePos - (this.game.screenSize.width * this._relativeSize)) / 2) +
        (this.game.screenSize.width * _relativeOffsetX);
    this._spaceBetween = (spacePos - this.game.screenSize.width * this._relativeSize);

    rectButton = Rect.fromLTWH(
        startX,
        this._relativeOffsetY * game.screenSize.height,
        this.game.screenSize.width * _relativeSize,
        this.game.screenSize.width * _relativeSize);

    _arrowPath = getArrowPath(arrowDirection, this._position);

    paintShadow = Paint();
    paintShadow.shader = RadialGradient(
      colors: [
        Color(0xff000000),
        Color(0x0),
      ],)
        .createShader(Rect.fromCircle(
        center: Offset(rectButton.left + rectButton.width / 2 + this._spaceBetween, rectButton.top + rectButton.height / 2 + this._spaceBetween), radius: (rectButton.width) / 2));
    paintButton = Paint();
    paintButton.color = Color(0xff0088ff);

    _paintArrow.color = Color(0xff000000);
  }

  Path getArrowPath(int dir, int position) {
    var spacePos = (this.game.screenSize.width -
        ((this.game.screenSize.width * _relativeOffsetX) * 2)) / 5;
    var startX = (position * spacePos) +
        ((spacePos - (this.game.screenSize.width * this._relativeSize)) / 2) +
        (this.game.screenSize.width * _relativeOffsetX);

    Path arrowPath = Path();
    var absoluteSize = _relativeSize * this.game.screenSize.width;

    if (dir.isEven) {
      // horizontal line
      arrowPath.moveTo(
          startX + (2 * absoluteSize / 3),
          this._relativeOffsetY * game.screenSize.height + (absoluteSize / 2)
      );
      arrowPath.lineTo(
          startX + (absoluteSize / 3),
          this._relativeOffsetY * game.screenSize.height + (absoluteSize / 2)
      );
    }
    else {
      // vertical line
      arrowPath.moveTo(
          startX + (absoluteSize / 2),
          this._relativeOffsetY * game.screenSize.height + (absoluteSize / 3)
      );
      arrowPath.lineTo(
          startX + (absoluteSize / 2),
          this._relativeOffsetY * game.screenSize.height + (2 * absoluteSize / 3)
      );
    }

    if (dir == 2 || dir == 3) {
      // left up
      arrowPath.moveTo(startX + (absoluteSize / 3),
          this._relativeOffsetY * game.screenSize.height + (absoluteSize / 2));
      arrowPath.lineTo(
          startX + (absoluteSize / 2),
          this._relativeOffsetY * game.screenSize.height +
              (2 * absoluteSize / 3));
    }

    if (dir == 2 || dir == 1) {
      // left down
      arrowPath.moveTo(
          startX + (absoluteSize / 3),
          this._relativeOffsetY * game.screenSize.height + (absoluteSize / 2)
      );
      arrowPath.lineTo(
          startX + (absoluteSize / 2),
          this._relativeOffsetY * game.screenSize.height + (absoluteSize / 3)
      );
    }

    if (dir == 4 || dir == 1) {
      // right down
      arrowPath.moveTo(
          startX + (2 * absoluteSize / 3),
          this._relativeOffsetY * game.screenSize.height + (absoluteSize / 2)
      );
      arrowPath.lineTo(
          startX + (absoluteSize / 2),
          this._relativeOffsetY * game.screenSize.height + (absoluteSize / 3)
      );
    }

    if (dir == 4 || dir == 3) {
      // right up
      arrowPath.moveTo(
          startX + (2 * absoluteSize / 3),
          this._relativeOffsetY * game.screenSize.height + (absoluteSize / 2)
      );
      arrowPath.lineTo(
          startX + (absoluteSize / 2),
          this._relativeOffsetY * game.screenSize.height + (2 * absoluteSize / 3)
      );
    }

    return arrowPath;
  }

  void render(Canvas c){
    //lining out the path for the arrows
    c.drawArc(rectButton.inflate(this._spaceBetween * 1.1), 0, 17, true, paintShadow);
    c.drawArc(rectButton, 0, 17, true, paintButton);
    c.drawPath(_arrowPath, _paintArrow);
  }

  void onTapDown(TapDownDetails d) {
    if (rectButton.contains(d.localPosition)) {
      if (_onTap != null) {
        _onTap();
      }
    }
  }
}