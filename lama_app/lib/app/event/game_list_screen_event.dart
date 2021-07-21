import 'package:flutter/material.dart';

/// BaseEvent for the [GameListBloc]
///
/// Author: K.Binder
class GameListScreenEvent {}

/// Subclass of [GameListScreenEvent]
///
/// This event contains the [gameCost], the [gameToStart] and the [context]
/// of the that the [GameListBloc] will attempt to start.
///
/// Author: K.Binder
class TryStartGameEvent extends GameListScreenEvent {
  int gameCost;
  String gameToStart;
  BuildContext context;
  TryStartGameEvent(this.gameCost, this.gameToStart, this.context);
}
