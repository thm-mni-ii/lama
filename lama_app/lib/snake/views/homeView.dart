import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:lama_app/snake/components/descriptionText.dart';
import 'package:lama_app/snake/components/startButton.dart';
import 'package:lama_app/snake/snakeGame.dart';

/// This class will render home view with all its components
class HomeView {
  final SnakeGame game;
  /// offset to the left and right relative to the screen width
  final relativeX = 0.05;
  /// offset to the top and bottom relative to the screen height
  final relativeY = 0.05;
  /// rectangle of the background
  Rect _bgRect;
  /// [Paint] of the background
  Paint bgPaint = Paint()
    ..color = Color(0xFFFFFFFF);
  /// [Paint] of the border
  Paint borderPaint = Paint()
    ..color = Color(0xFF000000);
  /// rectangle of the image
  Rect _imageRect;
  /// image to display
  Sprite _imageSprite;
  /// startbutton to launch the game
  StartButton startButton;
  /// component to display the description
  DescriptionText description;
  /// thickness of the border
  double _borderThickness = 3;

  HomeView(this.game) {
    this.startButton = StartButton(game, relativeX, relativeY);

    _imageSprite = Sprite('png/snake.png');

    var ratio = this.game.screenSize.width / this.game.screenSize.height;

    description = DescriptionText(game, this.game.screenSize.width * (1.0 - relativeX * 4) * ratio);

    resize();
  }

  void resize() {
    this.startButton?.resize();

    var ratio = this.game.screenSize.width / this.game.screenSize.height;

    _imageRect = Rect.fromLTWH(
        this.game.screenSize.width * (relativeX * 2),
        this.game.screenSize.height * (relativeY * 2),
        this.game.screenSize.width * (1.0 - relativeX * 4),
        this.game.screenSize.width * (1.0 - relativeX * 4) * ratio
    );

    _bgRect = Rect.fromLTWH(
      this.game.screenSize.width * relativeX,
      this.game.screenSize.height * relativeY,
      this.game.screenSize.width * (1.0 - relativeX * 2),
      this.game.screenSize.height * (1.0 - relativeY * 4),
    );

    this.description?.resize();
  }

  void render(Canvas c) {
    c.drawRRect(RRect.fromRectAndRadius(_bgRect.inflate(_borderThickness), Radius.circular(35.0)), borderPaint);
    c.drawRRect(RRect.fromRectAndRadius(_bgRect, Radius.circular(35.0)), bgPaint);
    _imageSprite.renderRect(c, _imageRect);
    startButton.render(c);
    description.render(c);
  }

  void update(double t) {}
}
