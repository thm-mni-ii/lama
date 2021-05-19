import 'dart:ui';
import 'package:flame/gestures.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';

import 'package:flutter/material.dart';
import 'package:lama_app/flappyLama/components/flappyBackground.dart';

class FlappyLamaGame extends Game with TapDetector{

  Size screenSize;
  FlappyBackground background;

  BuildContext _context;

  FlappyLamaGame(this._context){
    initialize();
  }

  void initialize() async{
    resize(await Flame.util.initialDimensions());
    background = FlappyBackground(this);
  }

  @override
  void render(Canvas canvas) {
    background.render(canvas);
  }

  @override
  void update(double t) {
    // TODO: implement update
  }
  
  @override
  void resize(Size size) {
    screenSize = size;
  }

  void onTapDown(TapDownDetails d){
    //if pauseButton pause
    //else jump
  }

}