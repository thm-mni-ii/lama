import 'dart:ui';

import 'package:lama_app/snake/models/position.dart';
import 'package:lama_app/snake/snake_game.dart';

class Background {
  final SnakeGame game;
  double _offsetX;
  double _offsetY;
  Rect bgRect;
  Rect fieldBorder;
  List<Position> fieldTiles;
  Paint bgPaint;
  Paint fieldBorderPaint;

  /// Constructor of this class
  ///
  /// Needs an instance of [SnakeGame] to determine the corresponding size of the screen.
  Background(this.game) {
    // background rectangle
    bgRect = Rect.fromLTWH(
      0,
      0,
      game.screenSize.width,
      game.screenSize.height,
    );

    fieldTiles = new List.generate(this.game.maxFieldX * this.game.maxFieldY,
            (index) => Position(index % this.game.maxFieldX, index ~/ this.game.maxFieldY));

    // background color
    bgPaint = Paint();
    bgPaint.color = Color(0xFFF9FBB6);

    // center the quadratic field depending on the max width or height of the screen
    _offsetX = game.screenSize.width > game.screenSize.height ? game.tileSize * this.game.fieldOffsetY : 0;
    _offsetY = game.screenSize.height > game.screenSize.width ? game.tileSize * this.game.fieldOffsetY : 0;

    // field border color
    fieldBorderPaint = Paint();
    fieldBorderPaint.color = Color(0xFF4C4C4C);
    // field border rect
    fieldBorder = Rect.fromLTWH(0, _offsetY - 2, game.screenSize.width, game.screenSize.width + 4);
  }

  void render(Canvas c) {
    c.drawRect(bgRect, bgPaint);
    c.drawRect(fieldBorder, fieldBorderPaint);

    // each tile of the game field
    for (var i = 0 ; i < fieldTiles.length; i++) {
      // tile rectangle
      var rect = Rect.fromLTWH(
        fieldTiles[i].x * this.game.tileSize + _offsetX,
        fieldTiles[i].y * this.game.tileSize + _offsetY,
        game.tileSize,
        game.tileSize,
      );

      // tile color
      var paint = Paint();
      // altering the color depending on the index. odd flied x is necessary for chess pattern
      paint.color = i % 2 <= 0 ? Color(0xFFF9FBB6) : Color(0xFFCDCE97);

      c.drawRect(rect, paint);
    }
  }

  void update(double t) {}
}