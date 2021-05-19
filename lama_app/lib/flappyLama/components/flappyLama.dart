import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:lama_app/flappyLama/flappyLamaGame.dart';

class FlappyLama{
  final FlappyLamaGame game;
  Rect lamaRect;
  Size screenSize;
  Paint lamaPaint;
  int _fallSpeed = 100;

  FlappyLama(this.game){
    lamaRect = Rect.fromLTWH(game.screenSize.width/20, game.screenSize.height/2, game.screenSize.width/10, game.screenSize.height/10);

    lamaPaint = Paint();
    lamaPaint.color = Color(0xfff00500);

  }

  void render(Canvas c){
    c.drawRect(lamaRect, lamaPaint);
  }
  void update(double t){
    lamaRect = lamaRect.translate(0, _fallSpeed*t);

  }  
}