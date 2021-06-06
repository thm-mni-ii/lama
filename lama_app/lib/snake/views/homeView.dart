import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:lama_app/snake/components/descriptionText.dart';
import 'package:lama_app/snake/components/startButton.dart';
import 'package:lama_app/snake/snakeGame.dart';

class HomeView {
  final SnakeGame game;

  final relativeX = 0.05;
  final relativeY = 0.05;

  Rect _bgRect;
  Paint bgPaint = Paint()
    ..color = Color(0xFFFFFFFF);
  Paint borderPaint = Paint()
    ..color = Color(0xFF000000);


  Rect _imageRect;
  Sprite _imageSprite;

  StartButton startButton;
  DescriptionText description;
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
