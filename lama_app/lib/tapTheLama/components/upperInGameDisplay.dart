import 'package:flame/components.dart';

///this class represents the background for the upper in game display that shows score, streak counter and life bar in the tap the lama game
class UpperInGameDisplay extends RectangleComponent{
  double widthCustom;
  double heightCustom;
  double positionX;
  double posictionY;


  UpperInGameDisplay(
      this.widthCustom, this.heightCustom, this.positionX, this.posictionY):super(position: Vector2(positionX, posictionY), size: Vector2(widthCustom, heightCustom), priority: 3);
}