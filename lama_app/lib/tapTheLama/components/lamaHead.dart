import 'package:flame/components.dart';

class LamaHead extends SpriteComponent{
  bool isExisting=false;
  bool isAngry=false;
  bool isHittable=false;


  LamaHead(this.isExisting, this.isAngry):super(priority: 2);

}
