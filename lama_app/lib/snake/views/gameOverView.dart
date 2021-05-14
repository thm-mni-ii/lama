import 'dart:ui';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lama_app/snake/components/goBackButton.dart';
import 'package:lama_app/snake/snake_game.dart';


class GameOverView {
  final SnakeGame game;

  Rect bgRect;
  Paint bgPaint;
  Paint borderPaint;
  TextPainter _painter;
  TextStyle _textStyle;

  GoBackButton goBackButton;
  double _borderThickness = 3;
  Offset _position;
  var relativeX = 0.15;
  var relativeY = 0.15;
  GameOverView(this.game) {
    var relativeSize = sqrt(this.game.screenSize.width * this.game.screenSize.height);

    

    this.goBackButton = GoBackButton(game, relativeX, relativeY);

    bgRect = Rect.fromLTWH(
      this.game.screenSize.width * relativeX,
      this.game.screenSize.height * relativeY,
      this.game.screenSize.width * (1.0 - relativeX * 2),
      this.game.screenSize.height * (1.0 - relativeY * 4),
    );

    bgPaint = Paint();
    bgPaint.color = Color(0xFFFFFFFF);
    borderPaint = Paint();
    borderPaint.color = Color(0xFF000000);

     _painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    _textStyle = TextStyle(
      color: Color(0xff000000),
      fontSize: relativeSize * 0.15,
    );
    _position = Offset.zero;
  }

  void render(Canvas c) {
    c.drawRRect(RRect.fromRectAndRadius(bgRect.inflate(_borderThickness), Radius.circular(35.0)), borderPaint);
    c.drawRRect(RRect.fromRectAndRadius(bgRect, Radius.circular(35.0)), bgPaint);
    _painter.paint(c, _position);
    goBackButton.render(c);
    
  }

  void update(double t) {
    if ((_painter.text ?? '') != game.score.toString()) {
      _painter.text = TextSpan(
        text: "Punkte\n${game.score.toString()}",
        style: _textStyle,
      );
      _painter.layout();
      _position = Offset(
          game.screenSize.width/2 -_painter.width/2,
          game.screenSize.height/2 -_painter.height/2 - (game.screenSize.height * (1.0 - relativeY * 4))/2,
      );
    }
  }
}
