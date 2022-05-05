import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/event/game_list_screen_event.dart';
import 'package:lama_app/app/repository/user_repository.dart';
import 'package:lama_app/app/screens/climber_game_screen.dart';
import 'package:lama_app/app/screens/flappy_game_screen.dart';
import 'package:lama_app/app/screens/snake_screen.dart';
import 'package:lama_app/app/state/game_list_screen_state.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';

/// [Bloc] for the [GameListScreen]
///
/// * see also
///     [GameListScreen]
///     [GameListScreenEvent]
///     [GameListScreenState]
///
/// Author: K.Binder
class GameListScreenBloc
    extends Bloc<GameListScreenEvent, GameListScreenState> {
  UserRepository userRepository;

  GameListScreenBloc(this.userRepository) : super(GameListScreenState());

  @override
  Stream<GameListScreenState> mapEventToState(
      GameListScreenEvent event) async* {
    if (event is TryStartGameEvent) {
      /*if (userRepository.getLamaCoins() >= event.gameCost) {
        userRepository.removeLamaCoins(event.gameCost);*/
      _navigateToGame(event.gameToStart, event.context, userRepository);
      /*} else {
        yield NotEnoughCoinsState();
      }*/
    }
  }
}

/// (private)
/// Navigates to the game with name [gameName].
///
/// Throws an [Exception] if there is no game with the name [gameName].
void _navigateToGame(String gameName, BuildContext context,
    UserRepository userRepository) async {
  Widget gameToLaunch;
  switch (gameName) {
    case "Snake":
      gameToLaunch = SnakeScreen(userRepository);
      break;
    case "Flappy-Lama":
      gameToLaunch = FlappyGameScreen(userRepository);
      break;
    case "Affen-Leiter":
      gameToLaunch = ClimberGameScreen(userRepository);
      break;
    default:
      throw Exception("Trying to launch game that does not exist");
  }
  final result = await Navigator.push(
      context, MaterialPageRoute(builder: (context) => gameToLaunch));
  //While this section is not completely in line with the bloc pattern, it was the easiest solution because the Games all use a different structure
  if (result == "NotEnoughCoins") {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: LamaColors.redAccent,
        content: Text(
          'Du hast nicht genug Lama Münzen!',
          textAlign: TextAlign.center,
          style: LamaTextTheme.getStyle(fontSize: 15),
        ),
        duration: Duration(seconds: 1)));
  }
}
