import 'dart:math';

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

  void addLamaCoins(int coinsToAdd) {
    authenticatedUser.coins += coinsToAdd;
    DatabaseProvider.db.updateUser(authenticatedUser);
  }

  void removeLamaCoins(int coinsToRemove) {
    authenticatedUser.coins =
        max(authenticatedUser.coins, authenticatedUser.coins - coinsToRemove);
    DatabaseProvider.db.updateUser(authenticatedUser);
  }
}
