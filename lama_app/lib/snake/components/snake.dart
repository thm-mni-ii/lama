import 'dart:ui';
import 'dart:developer' as developer;

import 'package:lama_app/snake/models/position.dart';

class Snake {
  Position headPos;
  final double tileSize;
  final int fieldX;
  final int fieldY;

  Snake(this.headPos, this.tileSize, this.fieldX, this.fieldY);

  /// This method moves the snake by the given direction for 1 tile.
  /// [dir] 1 = north, 2 = west, 3 = east everything else = south
  void moveSnake(int dir) {
    switch(dir) {
      case 3 : {
        headPos = headPos.x <= 1 ? Position(fieldX, headPos.y) : Position(headPos.x - 1, headPos.y);
        break;
      }
      case 2 : {
        headPos = headPos.x >= fieldX ? Position(1, headPos.y) : Position(headPos.x + 1, headPos.y);
        break;
      }
      case 1 : {
        headPos = headPos.y <= 1 ? Position(headPos.x, fieldY) : Position(headPos.x, headPos.y - 1);
        break;
      }
      default : {
        headPos = headPos.y >= fieldY ? Position(headPos.x, 1) : Position(headPos.x, headPos.y + 1);
        break;
      }
    }
  }

  void render(Canvas c) {
    // rectangle
    Rect bgRect = Rect.fromLTWH(
        (this.headPos.x - 1) * tileSize,
        (this.headPos.y - 1) * tileSize,
        tileSize,
        tileSize);

    // paint
    Paint bgPaint = Paint();
    bgPaint.color = Color(0xFF208421);

    c.drawArc(bgRect, 0, 10, true, bgPaint);
  }

  void update(double t) {}
}