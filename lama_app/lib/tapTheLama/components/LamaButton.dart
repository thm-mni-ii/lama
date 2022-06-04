
import 'package:flame/components.dart';
import 'package:flame/input.dart';


class LamaButton extends SpriteComponent with Tappable{
  bool buttonPressed=false;
  LamaButton(): super(priority: 1);

  @override
  bool onTapDown(TapDownInfo event) {

    try{
      buttonPressed=true;
      return true;
    }catch(error){
      print(error);
    }
    return false;

  }
}