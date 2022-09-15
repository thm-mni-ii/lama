import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/event/game_list_screen_event.dart';
import 'package:lama_app/app/repository/user_repository.dart';
import 'package:lama_app/app/screens/climber_game_screen.dart';
import 'package:lama_app/app/screens/flappy_game_screen.dart';
import 'package:lama_app/app/screens/tap_the_lama_game_screen.dart';
import 'package:lama_app/app/screens/tetris_game_screen.dart';
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
  UserRepository? userRepository;

  GameListScreenBloc(this.userRepository) : super(GameListScreenState()) {
    on<TryStartGameEvent>((event, emit) async {
      /*if (userRepository.getLamaCoins() >= event.gameCost) {
        userRepository.removeLamaCoins(event.gameCost);*/
      _navigateToGame(event.gameToStart, event.context, userRepository);
      /*} else {
        yield NotEnoughCoinsState();
      }*/
    });
  }
}

/// (private)
/// Navigates to the game with name [gameName].
///
/// Throws an [Exception] if there is no game with the name [gameName].
void _navigateToGame(String gameName, BuildContext context,
    UserRepository? userRepository) async {
  Widget gameToLaunch;
  switch (gameName) {
    case "Snake":
      gameToLaunch = SnakeScreen(userRepository);
      break;
    case "Flappy-Lama":
      //quick solution to get Highscores
      int? userHighScore = await userRepository!.getMyHighscore(2);
      int? allTimeHighScore = await userRepository.getHighscore(2);
      gameToLaunch =
          FlappyLamaScreen(userRepository, userHighScore, allTimeHighScore);
      break;
    case "Affen-Leiter":
      gameToLaunch = ClimberGameScreen(userRepository);
      break;
    case "Tetris":
      //quick solution to get Highscores
      int? userHighScore = await userRepository!.getMyHighscore(4);
      int? allTimeHighScore = await userRepository.getHighscore(4);
      gameToLaunch =
          TetrisScreen(userRepository, userHighScore, allTimeHighScore);
      break;
    case "Tap The Lama":
      int? userHighScore = await userRepository!.getMyHighscore(5);
      int? allTimeHighScore = await userRepository.getHighscore(5);
      gameToLaunch =
          TapTheLamaScreen(userRepository, userHighScore, allTimeHighScore);
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
