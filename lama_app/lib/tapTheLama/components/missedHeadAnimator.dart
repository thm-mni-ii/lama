import 'package:flame/components.dart';

///this class represents an animated area on the lower display end in the tap the lama game to indicate if a lama head reaches the end of the display untapped
class MissedHeadAnimator extends RectangleComponent{
  double widthCustom;
  double heightCustom;
  double positionX;
  double posictionY;

  MissedHeadAnimator(this.widthCustom, this.heightCustom, this.positionX, this.posictionY):super(position: Vector2(positionX, posictionY), size: Vector2(widthCustom, heightCustom), priority: 3);
}