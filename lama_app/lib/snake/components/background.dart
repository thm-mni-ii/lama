import 'dart:ui';

import 'package:lama_app/snake/models/position.dart';
import 'package:lama_app/snake/snakeGame.dart';

/// This class will render the background of the full screen.
class Background {
  final SnakeGame game;
  /// [Rect] of the background of the hole screen
  Rect _backgroundRect;
  /// [Rect] of the control bar
  Rect _controlBarRect;
  /// [Paint] of the background of the hole screen
  Paint _backgroundPaint;
  /// [Rect] of the background of the game field
  Rect _fieldRect;
  /// [Paint] of the background of the game field border
  Paint _fieldBorderPaint;
  /// [List] of [Position] of all field tiles
  List<Position> _fieldTiles;

  /// Offset to the left
  double _offsetX;
  /// Offset to the top
  double _offsetY;
  /// this flag decides if the chess optic will display
  bool _chessOptic = false;
  /// The thickness of the field border
  double _borderThickness = 2;
  /// the relative height to the screen height of the control bar
  double _controlBarRelativeHeight;
  /// [Paint] of the control bar
  Paint _controlBarPaint = Paint()
    ..color = Color(0xFF34C935);

  /// Constructor of this class
  ///
  /// Needs an instance of [SnakeGame] to determine the corresponding size of the screen.
  Background(this.game, this._controlBarRelativeHeight) {
    resize();

    // background paint
    _backgroundPaint = Paint();
    _backgroundPaint.color = Color(0xFFF9FBB6);

    // field border paint
    _fieldBorderPaint = Paint();
    _fieldBorderPaint.color = Color(0xFF4C4C4C);
  }

  void resize() {
    // background rectangle
    _backgroundRect = Rect.fromLTWH(
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
    _fieldTiles = List.generate(
        this.game.maxFieldX * this.game.maxFieldY,
            (index) => Position(index % this.game.maxFieldX, index ~/ this.game.maxFieldX));

    // calculates the offset of the field depending on the [fieldOffsetY] of the SnakeGame
    _offsetX = game.screenSize.width > game.screenSize.height ? game.tileSize * this.game.fieldOffsetY : 0;
    _offsetY = game.screenSize.height > game.screenSize.width ? game.tileSize * this.game.fieldOffsetY : 0;

    // field border rect
    _fieldRect = Rect.fromLTWH(
        _offsetX,
        _offsetY,
        game.tileSize * this.game.maxFieldX,
        game.tileSize * this.game.maxFieldY);
  }

  void render(Canvas c) {
    // draw the background of the hole screen
    c.drawRect(_backgroundRect, _backgroundPaint);

    if (!this.game.maxField) {
      c.drawRect(_fieldRect.inflate(_borderThickness), _fieldBorderPaint);
    }

    c.drawRect(_fieldRect, _backgroundPaint);
    c.drawRect(_controlBarRect, _controlBarPaint);

    // draw the game field in chess optic
    if (_chessOptic) {
      // each tile of the game field
      for (var i = 0 ; i < _fieldTiles.length; i++) {
        // tile rectangle
        var rect = Rect.fromLTWH(
          _fieldTiles[i].x * this.game.tileSize + _offsetX,
          _fieldTiles[i].y * this.game.tileSize + _offsetY,
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