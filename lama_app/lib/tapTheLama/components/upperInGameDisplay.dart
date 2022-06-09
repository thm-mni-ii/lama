import 'package:flame/components.dart';
import 'package:flame/palette.dart';

class UpperInGameDisplay extends RectangleComponent{
  double widthCustom;
  double heightCustom;
  double positionX;
  double posictionY;


  UpperInGameDisplay(
      this.widthCustom, this.heightCustom, this.positionX, this.posictionY):super(position: Vector2(positionX, posictionY), size: Vector2(widthCustom, heightCustom), priority: 3);
}