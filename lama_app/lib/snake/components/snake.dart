import 'dart:ui';

import 'package:lama_app/snake/models/position.dart';

class Snake {
  final Position headPos;
  final double tileSize;
  Rect bgRect;
  Paint bgPaint;

  Snake(this.headPos, this.tileSize) {
    // rectangle
    bgRect = Rect.fromLTWH(
        (this.headPos.x - 1) * tileSize,
        (this.headPos.y - 1) *  tileSize,
        this.headPos.x + tileSize,
        this.headPos.y + tileSize);

    // paint
    bgPaint = Paint();
    bgPaint.color = Color(0xFF208421);
  }

  void render(Canvas c) {
    c.drawArc(bgRect, 0, 360, true, bgPaint);
  }

  void update(double t) {}
}