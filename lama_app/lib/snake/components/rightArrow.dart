
import 'package:lama_app/snake/snake_game.dart';
import 'dart:ui';

class RightArrowButton{
  final SnakeGame game;

  Rect rectButton;
  Paint paintButton;
  Size screenSize;
  

  RightArrowButton(this.game){
    rectButton = Rect.fromLTWH(
      150,100,50,50
    );

    //rectButton = Rect.fromLTWH(game.screenSize.width/2 + (2*game.tileSize), game.screenSize.height - (3.5*game.tileSize), game.tileSize, game.tileSize);
    paintButton = Paint();
    paintButton.color = Color(0xff6dff4a);

  }

  void render(Canvas c){
    c.drawRect(rectButton, paintButton);
  }
  void update(double t) {}

  void onTapDown(){
    print("tappedright");
  }
}