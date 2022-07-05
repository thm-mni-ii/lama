
import 'package:flame/components.dart';
import 'package:flame/input.dart';

///this class represents the lama buttons in the tap the lama game which are the control elements of the game
class LamaButton extends SpriteComponent with Tappable{
  bool buttonPressed=false;
  LamaButton(): super(priority: 1);

  ///on tap method returns bool and shows if button is pressed or not
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