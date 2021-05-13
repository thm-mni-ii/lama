
import 'package:lama_app/snake/snake_game.dart';
import 'dart:ui';
import 'package:flutter/cupertino.dart';


import '../snake_game.dart';




class ArrowButtons{
  final SnakeGame game;

  Rect rectButton;
  Paint paintButton;
  Paint paintArrow = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3.5;
  Size screenSize;
  int arrowDirection;
  Path arrowPath;
  static const IconData arrow_back = IconData(0xe5a7, fontFamily: 'MaterialIcons', matchTextDirection: true);
  
  

  ArrowButtons(this.game, this.arrowDirection){
    
    paintButton = Paint();
    paintButton.color = Color(0xff0088ff);
    
    paintArrow.color = Color(0xff000000);

    //lining out the path for the arrows
    arrowPath = Path();
    arrowPath.moveTo(0.01*game.screenSize.width + 0.07*game.screenSize.height , 0.785*game.screenSize.height);
    arrowPath.lineTo(0.01*game.screenSize.width + 0.02*game.screenSize.height, 0.785*game.screenSize.height);
    arrowPath.lineTo(0.01*game.screenSize.width + 0.04*game.screenSize.height, 0.795*game.screenSize.height);
    arrowPath.moveTo(0.01*game.screenSize.width + 0.02*game.screenSize.height, 0.785*game.screenSize.height);
    arrowPath.lineTo(0.01*game.screenSize.width + 0.04*game.screenSize.height, 0.775*game.screenSize.height);
    

    arrowPath.moveTo(0.22*game.screenSize.width + 0.02*game.screenSize.height , 0.785*game.screenSize.height);
    arrowPath.lineTo(0.22*game.screenSize.width + 0.07*game.screenSize.height, 0.785*game.screenSize.height);
    arrowPath.lineTo(0.22*game.screenSize.width + 0.05*game.screenSize.height, 0.795*game.screenSize.height);
    arrowPath.moveTo(0.22*game.screenSize.width + 0.07*game.screenSize.height, 0.785*game.screenSize.height);
    arrowPath.lineTo(0.22*game.screenSize.width + 0.05*game.screenSize.height, 0.775*game.screenSize.height);

    arrowPath.moveTo(0.6*game.screenSize.width + 0.045*game.screenSize.height , 0.76*game.screenSize.height);
    arrowPath.lineTo(0.6*game.screenSize.width + 0.045*game.screenSize.height, 0.81*game.screenSize.height);
    arrowPath.lineTo(0.6*game.screenSize.width + 0.035*game.screenSize.height, 0.79*game.screenSize.height);
    arrowPath.moveTo(0.6*game.screenSize.width + 0.045*game.screenSize.height, 0.81*game.screenSize.height);
    arrowPath.lineTo(0.6*game.screenSize.width + 0.055*game.screenSize.height, 0.79*game.screenSize.height);

    arrowPath.moveTo(0.81*game.screenSize.width + 0.045*game.screenSize.height , 0.81*game.screenSize.height);
    arrowPath.lineTo(0.81*game.screenSize.width + 0.045*game.screenSize.height, 0.76*game.screenSize.height);
    arrowPath.lineTo(0.81*game.screenSize.width + 0.035*game.screenSize.height, 0.78*game.screenSize.height);
    arrowPath.moveTo(0.81*game.screenSize.width + 0.045*game.screenSize.height, 0.76*game.screenSize.height);
    arrowPath.lineTo(0.81*game.screenSize.width + 0.055*game.screenSize.height, 0.78*game.screenSize.height);




    switch(arrowDirection){
      case 0: rectButton = Rect.fromLTWH(0.6*game.screenSize.width,
              0.74*game.screenSize.height, 0.09*game.screenSize.height, 0.09*game.screenSize.height);
              
        break;
      case 1: rectButton = Rect.fromLTWH(0.81*game.screenSize.width,
              0.74*game.screenSize.height, 0.09*game.screenSize.height, 0.09*game.screenSize.height);
              
        break;
      case 2: rectButton = Rect.fromLTWH(0.01*game.screenSize.width,
             0.74*game.screenSize.height, 0.09*game.screenSize.height, 0.09*game.screenSize.height);
            
        break;
      case 3: rectButton = Rect.fromLTWH(0.22*game.screenSize.width,
             0.74*game.screenSize.height, 0.09*game.screenSize.height, 0.09*game.screenSize.height);
             
        break;
    }
    
  }

  void render(Canvas c){
    //lining out the path for the arrows 
    c.drawArc(rectButton, 0, 17, true, paintButton);
   
    c.drawPath(arrowPath, paintArrow);
  }
  


    



  void onTapDown() {
    /*switch(arrowDirection){
      case 0: 
              
        break;
      case 1: 
              
        break;
      case 2: 
              
        break;
      case 3: 
              
        break; 
    }*/
  }


}