import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:lama_app/snake/snake_game.dart';

class ScoreDisplay {
  final SnakeGame game;

  double offsetY = 70;
  Rect borderRect;
  Rect fillRect;
  Paint borderPaint;
  Paint fillPaint;

  TextPainter painter;
  TextStyle textStyle;
  Offset position;

  ScoreDisplay(this.game) {
    painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textStyle = TextStyle(
      color: Color(0xbbffffff),
      fontSize: 30,
    );

    borderRect = Rect.fromLTWH(
        (game.screenSize.width / 2) - (this.game.tileSize * this.game.fieldOffsetY) / 2,
        offsetY,
        this.game.tileSize * this.game.fieldOffsetY,
        this.game.tileSize * this.game.fieldOffsetY);

    var borderThickness = 1;
    fillRect = Rect.fromLTWH(
        (game.screenSize.width / 2) - ((this.game.tileSize * this.game.fieldOffsetY) / 2) + borderThickness,
        offsetY + borderThickness.toDouble(),
        this.game.tileSize * this.game.fieldOffsetY - borderThickness * 2,
        this.game.tileSize * this.game.fieldOffsetY - borderThickness);

    fillPaint = Paint();
    fillPaint.color = Color(0x66E87070);

    borderPaint = Paint();
    borderPaint.color = Color(0x66000000);

    position = Offset.zero;
  }

  void update(double t) {
    if ((painter.text ?? '') != game.score.toString()) {
      painter.text = TextSpan(
        text: game.score.toString(),
        style: textStyle,
      );

      painter.layout();

      position = Offset(
        (fillRect.left) + (fillRect.width / 2) - painter.width / 2,
          (fillRect.top) + (fillRect.height / 2) - painter.height / 2,
      );
    }
  }

  void render(Canvas c) {
    c.drawArc(
        borderRect,
        0,
        10,
        true,
        borderPaint);

    c.drawArc(
        fillRect,
        0,
        10,
        true,
        fillPaint);

    painter.paint(c, position);
  }
}