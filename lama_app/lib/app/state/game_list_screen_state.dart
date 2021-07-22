///BaseState for the [GameListScreenBloc].
///
///Author: K.Binder
class GameListScreenState {}

///Subclass of [GameListScreenState].
///
///Emitted when a user selects a game, but doesnt have enough coins to play it.
///
///Author: K.Binder
class NotEnoughCoinsState extends GameListScreenState {}
