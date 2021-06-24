import 'dart:ui';
import 'dart:math';

import 'package:flame/anchor.dart';
import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:lama_app/apeClimber/climberGame.dart';


class ClimberTree extends SpriteComponent {
  final ClimberGame _game;
  double _offsetx = 0;
  double _offsety = 1;
  Sprite sprite;

  ClimberTree(this._game, yoffset){
    sprite = Sprite('png/tree7th.png');
    this.height = this._game.size.height*1.5;
    this.width = this._game.tileSize*3.0;
    _offsetx = this.width/2;
    this.x = (this._game.size.width/2) - _offsetx;
    this.y = (this.height-_offsety)*yoffset;
    anchor = Anchor.topLeft;
  }
}