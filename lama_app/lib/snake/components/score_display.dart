import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:lama_app/snake/snake_game.dart';

class ScoreDisplay {
  final SnakeGame game;

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
      fontSize: 50,
    );

    borderRect = Rect.fromLTWH(
        (game.screenSize.width / 2) - (this.game.tileSize * this.game.fieldOffsetY) / 2,
        0,
        this.game.tileSize * this.game.fieldOffsetY,
        this.game.tileSize * this.game.fieldOffsetY);

    var borderThickness = 1;
    fillRect = Rect.fromLTWH(
        (game.screenSize.width / 2) - ((this.game.tileSize * this.game.fieldOffsetY) / 2) + borderThickness,
        borderThickness.toDouble(),
        this.game.tileSize * this.game.fieldOffsetY - borderThickness * 2,
        this.game.tileSize * this.game.fieldOffsetY - borderThickness);

    fillPaint = Paint();
    fillPaint.color = Color(0xBBE87070);

    borderPaint = Paint();
    borderPaint.color = Color(0xBB000000);

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
        (fillRect.left) + (painter.width / 2),
        (fillRect.height - painter.height),
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