
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
    switch(arrowDirection){
      case 0: rectButton = Rect.fromLTWH(game.screenSize.width/2- 0.5 *game.tileSize,
              game.screenSize.height - 12*game.tileSize, 2*game.tileSize, 2*game.tileSize);
              
        break;
      case 1: rectButton = Rect.fromLTWH(game.screenSize.width/2-0.5*game.tileSize,
              game.screenSize.height - 17*game.tileSize, 2*game.tileSize, 2*game.tileSize);
              
        break;
      case 2: rectButton = Rect.fromLTWH(game.screenSize.width/2 -5*game.tileSize,
             game.screenSize.height-14.5*game.tileSize,game.tileSize*2, 2*game.tileSize);
            
        break;
      case 3: rectButton = Rect.fromLTWH(game.screenSize.width/2 + 4*game.tileSize,
             game.screenSize.height-14.5*game.tileSize, 2*game.tileSize, 2*game.tileSize);
             
        break;
    }
    
  }

  void render(Canvas c){
    c.drawRect(rectButton, paintButton);
  }
  


    



  void onTapDown() {
    switch(arrowDirection){
      case 0: 
              
        break;
      case 1: 
              
        break;
      case 2: 
              
        break;
      case 3: 
              
        break; 
    }
  }


}