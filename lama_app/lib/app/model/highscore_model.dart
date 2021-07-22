
//set table name
final String tableHighscore = "highscore";

//set column names
class HighscoresFields{
  static final String columnId = "id";
  static final String columnGameId = "gameid";
  static final String columnScore = "score";
  static final String columnUserId = "userID";
}

class Highscore {
  int id;
  int gameID;
  int score;
  int userID;

  Highscore({this.gameID, this.score, this.userID});
  //Map the variables and return the map
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      HighscoresFields.columnGameId: gameID,
      HighscoresFields.columnScore: score,
      HighscoresFields.columnUserId: userID
    };
    return map;
  }
  //get the data from an map
  Highscore.fromMap(Map<String, dynamic> map) {
    id = map[HighscoresFields.columnId];
    gameID = map[HighscoresFields.columnGameId];
    score = map[HighscoresFields.columnScore];
    userID = map[HighscoresFields.columnUserId];
  }
}