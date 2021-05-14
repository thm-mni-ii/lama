import 'dart:ui';

import 'package:lama_app/snake/models/position.dart';
import 'package:lama_app/snake/snake_game.dart';

class Background {
  final SnakeGame game;

  Rect backgroundRect;
  Paint backgroundPaint;
  Rect fieldBorderRect;
  Paint fieldBorderPaint;
  List<Position> fieldTiles;

  double _offsetX;
  double _offsetY;
  bool _chessOptic = false;

  /// Constructor of this class
  ///
  /// Needs an instance of [SnakeGame] to determine the corresponding size of the screen.
  Background(this.game) {
    // background rectangle
    backgroundRect = Rect.fromLTWH(
      0,
      0,
      game.screenSize.width,
      game.screenSize.height,
    );

    // generate the field tiles
    fieldTiles = List.generate(
        this.game.maxFieldX * this.game.maxFieldY,
            (index) => Position(index % this.game.maxFieldX, index ~/ this.game.maxFieldX));

    // background paint
    backgroundPaint = Paint();
    backgroundPaint.color = Color(0xFFF9FBB6);

    // calculates the offset of the field depending on the [fieldOffsetY] of the SnakeGame
    _offsetX = game.screenSize.width > game.screenSize.height ? game.tileSize * this.game.fieldOffsetY : 0;
    _offsetY = game.screenSize.height > game.screenSize.width ? game.tileSize * this.game.fieldOffsetY : 0;

    // field border paint
    fieldBorderPaint = Paint();
    fieldBorderPaint.color = Color(0xFF4C4C4C);

    // field border rect
    fieldBorderRect = Rect.fromLTWH(
        _offsetX,
        _offsetY - 2,
        game.tileSize * this.game.maxFieldX,
        game.tileSize * this.game.maxFieldY + 4);
  }

  void render(Canvas c) {
    c.drawRect(backgroundRect, backgroundPaint);

    if (_chessOptic) {
      c.drawRect(fieldBorderRect, fieldBorderPaint);
      // each tile of the game field
      for (var i = 0 ; i < fieldTiles.length; i++) {
        // tile rectangle
        var rect = Rect.fromLTWH(
          fieldTiles[i].x * this.game.tileSize + _offsetX,
          fieldTiles[i].y * this.game.tileSize + _offsetY,
          game.tileSize,
          game.tileSize,
        );

        // tile paint
        // altering the color depending on the index. odd field width and height x is necessary for chess pattern
        var paint = Paint();
        paint.color = i % 2 <= 0 ? Color(0xFFF9FBB6) : Color(0xFFCDCE97);

        c.drawRect(rect, paint);
      }
    }
  }

  void update(double t) {}
}