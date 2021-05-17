import 'dart:ui';

import 'package:lama_app/snake/models/position.dart';
import 'package:lama_app/snake/snakeGame.dart';

class Background {
  final SnakeGame game;

  Rect backgroundRect;
  Rect _controlBarRect;
  Paint backgroundPaint;
  Rect fieldRect;
  Paint fieldBorderPaint;
  List<Position> fieldTiles;

  double _offsetX;
  double _offsetY;
  bool _chessOptic = false;
  double _borderThickness = 2;
  double _controlBarRelativeHeight;
  Paint _controlBarPaint = Paint()
    ..color = Color(0xFF34C935);

  /// Constructor of this class
  ///
  /// Needs an instance of [SnakeGame] to determine the corresponding size of the screen.
  Background(this.game, this._controlBarRelativeHeight) {
    // background rectangle
    backgroundRect = Rect.fromLTWH(
      0,
      0,
      game.screenSize.width,
      game.screenSize.height,
    );

    // control bar rectangle
    _controlBarRect = Rect.fromLTWH(
      0,
      game.screenSize.height - (_controlBarRelativeHeight * game.screenSize.height),
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
    fieldRect = Rect.fromLTWH(
        _offsetX,
        _offsetY,
        game.tileSize * this.game.maxFieldX,
        game.tileSize * this.game.maxFieldY);
  }

  void render(Canvas c) {
    c.drawRect(backgroundRect, backgroundPaint);

    if (!this.game.maxField) {
      c.drawRect(fieldRect.inflate(_borderThickness), fieldBorderPaint);
    }
    c.drawRect(fieldRect, backgroundPaint);
    c.drawRect(_controlBarRect, _controlBarPaint);

    if (_chessOptic) {
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