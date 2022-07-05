import 'package:flame/components.dart';

///this class represents a lama head that falls down the screen in the tap the lama game
class LamaHead extends SpriteComponent{
  bool isExisting=false;
  bool isAngry=false;
  bool isHittable=false;


  LamaHead(this.isExisting, this.isAngry):super(priority: 2);

}
