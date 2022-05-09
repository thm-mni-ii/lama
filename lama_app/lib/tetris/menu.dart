import 'package:flutter/material.dart';

import 'package:lama_app/app/repository/user_repository.dart';
import '../app/screens/game_list_screen.dart';

import '../app/screens/tetris_game_screen.dart';
import 'menu_button.dart';

class Menu extends StatefulWidget {
  var context;

  UserRepository userRepo;
  int userHighScore;
  int allTimeHighScore;

  void ladeHighScores() async {
    userHighScore = await userRepo.getMyHighscore(4);
    allTimeHighScore = await userRepo.getHighscore(4);
  }

  // const Menu({Key? key}) : super(key: key);
  @override
  Menu(this.context, this.userRepo) {
    ladeHighScores();
  }
  State<StatefulWidget> createState() =>
      _MenuState(userRepo, userHighScore, allTimeHighScore);
}

class _MenuState extends State<Menu> {
  UserRepository userRepo;

  /// id of the game
  final gameId = 4;

  /// the personal highScore
  int userHighScore;

  /// the all time highScore in this game
  int allTimeHighScore;

  bool ladeHighScoreBool = false;

  Future<void> ladeHighScores() async {
    userHighScore = await userRepo.getMyHighscore(4);
    allTimeHighScore = await userRepo.getHighscore(4);
  }

  void initState() {
    // ladeHighScores();
    super.initState();
  }

  _MenuState(this.userRepo, this.userHighScore, this.allTimeHighScore);
  void onPlayClicked() {
    if (userRepo.getLamaCoins() < GameListScreen.games[4 - 1].cost) {
      //4-1 is game id
      Navigator.pop(context, "NotEnoughCoins");
      return;
    }
    userRepo.removeLamaCoins(GameListScreen.games[4 - 1].cost); //4-1 is game id
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GameScreen(userRepo)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Tetris',
            style: TextStyle(
                fontSize: 70.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                shadows: [
                  Shadow(
                    color: Color.fromARGB(255, 230, 250, 8),
                    blurRadius: 8.0,
                    offset: Offset(2.0, 2.0),
                  )
                ]),
          ),
          MenuButton(onPlayClicked),
          /*   Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ScoreDisplayTetris(userHighScore, "dein Highscroe"),
              ScoreDisplayTetris(allTimeHighScore, "erstePlatz"),
            ],
          )*/
        ],
      ),
    );
  }
}
