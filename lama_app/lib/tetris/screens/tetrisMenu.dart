import 'package:flutter/material.dart';

import 'package:lama_app/app/repository/user_repository.dart';
import '../../../app/screens/game_list_screen.dart';

import '../../../app/screens/tetris_game_screen.dart';
import '../buttons/menu_button.dart';
import 'package:lama_app/util/LamaColors.dart';

class Menu extends StatefulWidget {
  var context;

  int? userHighScore;
  int? allTimeHighScore;
  UserRepository? userRepository;

  @override
  Menu(this.context, this.userHighScore, this.allTimeHighScore,
      this.userRepository);
  State<StatefulWidget> createState() =>
      _MenuState(userHighScore, allTimeHighScore, userRepository);
}

class _MenuState extends State<Menu> {
  UserRepository? userRepo;

  /// id of the game
  final gameId = 4;

  /// the personal highScore
  int? userHighScore;

  /// the all time highScore in this game
  int? allTimeHighScore;

  void initState() {
    super.initState();
  }

  _MenuState(this.userHighScore, this.allTimeHighScore, this.userRepo);

  void onPlayClicked() {
    if (userRepo!.getLamaCoins()! < GameListScreen.games[gameId - 1].cost) {
      Navigator.pop(context, "NotEnoughCoins");
      return;
    }
    userRepo!.removeLamaCoins(GameListScreen.games[gameId - 1].cost);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              GameScreen(userRepo, userHighScore, allTimeHighScore)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(35.0)),
        color: Color(0xFFd3d3d3).withOpacity(0.4),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 50.0),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                Text(
                  "\nSetze die Blöcke zusammen und achte darauf möglichst keine Lücken zu lassen.\n",
                  style:
                      TextStyle(fontSize: 20.0, color: LamaColors.blueAccent),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Dein Rekord: $userHighScore\n",
                  style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: LamaColors.blueAccent),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "HighScore: $allTimeHighScore\n",
                  style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: LamaColors.blueAccent),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
