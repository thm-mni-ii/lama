import 'package:flame/components.dart';


///represents the visual life bar that changes when life points get lost in the tap the lama game
class LifeBar extends RectangleComponent{
  double widthCustom;
  double heightCustom;
  double positionX;
  double posictionY;

  LifeBar(this.widthCustom, this.heightCustom, this.positionX, this.posictionY):super(position: Vector2(positionX, posictionY), size: Vector2(widthCustom, heightCustom), priority: 4);
}
