import 'dart:math';

import 'package:dbcrypt/dbcrypt.dart';
import 'package:lama_app/app/model/highscore_model.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/app/screens/admin_menu_screen.dart';
import 'package:lama_app/db/database_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

/// Repository that provides access to the [User] thats currently logged in.
///
/// Author: K.Binder
class UserRepository {
  User authenticatedUser;

  UserRepository(this.authenticatedUser);

  ///Returns the username of the user thats currently logged in.
  String getUserName() {
    return authenticatedUser.name;
  }

  ///Returns the amount of lama coins of the user thats currently logged in.
  int getLamaCoins() {
    return authenticatedUser.coins;
  }

  ///Returns the grade of the user thats currently logged in.
  int getGrade() {
    return authenticatedUser.grade;
  }

  ///Returns the avatar of the user thats currently logged in.
  String getAvatar() {
    return authenticatedUser.avatar;
  }

  ///Adds lama coins to the user thats currently logged in.
  void addLamaCoins(int coinsToAdd) async {
    authenticatedUser.coins += coinsToAdd;
    authenticatedUser = await DatabaseProvider.db
        .updateUserCoins(authenticatedUser, authenticatedUser.coins);
  }

  ///Removes lama coins from the user thats currently logged in.
  void removeLamaCoins(int coinsToRemove) async {
    authenticatedUser.coins = max(0, authenticatedUser.coins - coinsToRemove);
    authenticatedUser = await DatabaseProvider.db
        .updateUserCoins(authenticatedUser, authenticatedUser.coins);
  }

  ///Adds a highscore for the user thats currently logged in.
  void addHighscore(Highscore score) async {
    await DatabaseProvider.db.insertHighscore(score);
    //TODO: post highscore to link if allowed
    if (getHighscorePermission()) {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      String _url = _prefs.getString(AdminUtils.highscoreUploadUrlPref);
      Uri uri = Uri.tryParse(_url);
      var token = new DBCrypt().hashpw(
          getUserName() +
              getGrade().toString() +
              score.score.toString() +
              score.gameID.toString(),
          new DBCrypt().gensalt());
      if (uri == null) return;
      http.Response response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8',
        },
        body: <String, String>{
          "username": getUserName(),
          "grade": getGrade().toString(),
          "highscore": score.score.toString(),
          "gameID": score.gameID.toString(),
          "token": token
        },
      );
      print(response);
    }
  }

  ///Returns the highscore for [gameId] for the user thats currently logged in.
  Future<int> getMyHighscore(int gameId) async {
    return await DatabaseProvider.db
        .getHighscoreOfUserInGame(authenticatedUser, gameId);
  }

  ///Returns the highscore for [gameId] among ALL users.
  Future<int> getHighscore(int gameId) async {
    return await DatabaseProvider.db.getHighscoreOfGame(gameId);
  }

  ///Returns wether or not a highscore may be posted online
  bool getHighscorePermission() {
    return authenticatedUser.highscorePermission;
  }
}
