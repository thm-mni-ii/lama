import 'dart:math';

import 'package:lama_app/app/model/highscore_model.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/db/database_provider.dart';

class UserRepository {
  User authenticatedUser;

  UserRepository(this.authenticatedUser);

  String getUserName() {
    return authenticatedUser.name;
  }

  int getLamaCoins() {
    return authenticatedUser.coins;
  }

  int getGrade() {
    return authenticatedUser.grade;
  }

  String getAvatar() {
    return authenticatedUser.avatar;
  }

  void addLamaCoins(int coinsToAdd) async {
    authenticatedUser.coins += coinsToAdd;
    authenticatedUser = await DatabaseProvider.db
        .updateUserCoins(authenticatedUser, authenticatedUser.coins);
  }

  void removeLamaCoins(int coinsToRemove) async {
    authenticatedUser.coins = max(0, authenticatedUser.coins - coinsToRemove);
    authenticatedUser = await DatabaseProvider.db
        .updateUserCoins(authenticatedUser, authenticatedUser.coins);
  }

  void addHighscore(Highscore score) async {
    await DatabaseProvider.db
        .insertHighscore(score);
  }

  Future<int> getMyHighscore(int gameId) async {
    // get all scores
    var scores = await DatabaseProvider.db
        .getHighscores();

    if (scores.isNotEmpty) {
      return scores
          .where((score) => score.userID == this.authenticatedUser.id && score.gameID == gameId)
          .map((e) => e.score)
          .reduce(max);
    }

    return 0;
  }
}
