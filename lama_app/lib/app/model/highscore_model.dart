import '../../db/database_provider.dart';

class Highscore {
  int id;
  int gameID;
  int score;
  int userID;

  Highscore({this.gameID, this.score, this.userID});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.columnGameId: gameID,
      DatabaseProvider.columnScore: score,
      DatabaseProvider.columnUserId: userID
    };
    return map;
  }

  Highscore.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseProvider.columnId];
    gameID = map[DatabaseProvider.columnGameId];
    score = map[DatabaseProvider.columnScore];
    userID = map[DatabaseProvider.columnUserId];
  }
}