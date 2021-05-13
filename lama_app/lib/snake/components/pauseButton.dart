import 'package:lama_app/snake/snake_game.dart';
import 'dart:ui';
import 'package:flutter/cupertino.dart';


class PauseButton{
  final SnakeGame game;

  Path pausePath;
  Rect rectButton;
  Paint paintButton;
  Size screenSize;
  Paint paintPausePath = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 5.0;

  PauseButton(this.game){
    paintButton = Paint();
    paintButton.color = Color(0xff00ff00);

    paintPausePath.color = Color(0xff000000);

    pausePath = Path();
    pausePath.moveTo(0.5*game.screenSize.width - 0.005*game.screenSize.height , 0.77*game.screenSize.height);
    pausePath.lineTo(0.5*game.screenSize.width - 0.005*game.screenSize.height, 0.80*game.screenSize.height);
    pausePath.moveTo(0.5*game.screenSize.width + 0.005*game.screenSize.height, 0.77*game.screenSize.height);
    pausePath.lineTo(0.5*game.screenSize.width + 0.005*game.screenSize.height, 0.80*game.screenSize.height);


   
    rectButton = Rect.fromLTWH(0.5*game.screenSize.width - 0.04*game.screenSize.height,
              0.745*game.screenSize.height, 0.08*game.screenSize.height, 0.08*game.screenSize.height);
  }


  void render(Canvas c){
    c.drawRect(rectButton, paintButton);
    c.drawPath(pausePath, paintPausePath);
  }

  void onTapDown() {}

}