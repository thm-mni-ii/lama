import 'package:flutter/material.dart';

class GameListScreenEvent {}

class TryStartGameEvent extends GameListScreenEvent {
  int gameCost;
  String gameToStart;
  BuildContext context;
  TryStartGameEvent(this.gameCost, this.gameToStart, this.context);
}
