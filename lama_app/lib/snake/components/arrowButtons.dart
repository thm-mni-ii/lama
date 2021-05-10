
import 'package:lama_app/snake/snake_game.dart';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flame/components/component.dart';

import '../snake_game.dart';




class ArrowButtons extends PositionComponent {
  final SnakeGame game;

  Rect rectButton;
  Paint paintButton;
  Size screenSize;
  int arrowDirection;
  

  ArrowButtons(this.game, this.arrowDirection){
    
    paintButton = Paint();
    paintButton.color = Color(0xff0003ff);
    
  }

  void render(Canvas c){
    switch(arrowDirection){
      case 0: rectButton = Rect.fromLTWH(game.screenSize.width/2- 0.5 *game.tileSize,
              game.screenSize.height - (9.5*game.tileSize), 2*game.tileSize, 2*game.tileSize);
              c.drawRect(rectButton, paintButton);
        break;
      case 1: rectButton = Rect.fromLTWH(game.screenSize.width/2-0.5*game.tileSize,
              game.screenSize.height - (14.5*game.tileSize), 2*game.tileSize, 2*game.tileSize);
              c.drawRect(rectButton, paintButton);
              
        break;
      case 2: rectButton = Rect.fromLTWH(game.screenSize.width/2 -4*game.tileSize,
             (game.screenSize.height-game.tileSize*12),game.tileSize*2, 2*game.tileSize);
             c.drawRect(rectButton, paintButton);
              
        break;
      case 3: rectButton = Rect.fromLTWH(game.screenSize.width/2 + (3*game.tileSize),
             (game.screenSize.height-game.tileSize*12), 2*game.tileSize, 2*game.tileSize);
             c.drawRect(rectButton, paintButton);
              
        break;
    }
    
  }
  


    



  void onTapDown() {
    switch(arrowDirection){
      case 0: print("turn down");
              
        break;
      case 1: print("turn up");
              
        break;
      case 2: print("turn left");
              
        break;
      case 3: print("turn right");
              
        break; 
    }
  }


}