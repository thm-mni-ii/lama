//set table name
final String tableHighscore = "highscore";

///Set the column names
///
/// Author: F.Brecher
class HighscoresFields {
  static final String columnId = "id";
  static final String columnGameId = "gameid";
  static final String columnScore = "score";
  static final String columnUserId = "userID";
}

///This class help to work with the data's from the highscore table
///
/// Author: F.Brecher
class Highscore {
  int? id;
  int? gameID;
  int? score;
  int? userID;

  Highscore({this.gameID, this.score, this.userID});

  ///Map the variables
  ///
  ///{@return} Map<String, dynamic>
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      HighscoresFields.columnGameId: gameID,
      HighscoresFields.columnScore: score,
      HighscoresFields.columnUserId: userID
    };
    return map;
  }

  ///get the data from the map
  ///
  ///{@param} Map<String, dynamic> map
  Highscore.fromMap(Map<String, dynamic> map) {
    id = map[HighscoresFields.columnId];
    gameID = map[HighscoresFields.columnGameId];
    score = map[HighscoresFields.columnScore];
    userID = map[HighscoresFields.columnUserId];
  }
}

class HighscoreList {
  List<Highscore>? highscoreList;
  HighscoreList(this.highscoreList);

  HighscoreList.fromJson(Map<String, dynamic> json) {
    if (json['highscoreList'] != null) {
      highscoreList = <Highscore>[];
      json['highscoreList'].forEach((v) {
        highscoreList!.add(new Highscore.fromMap(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.highscoreList != null) {
      data['highscoreList'] =
          this.highscoreList!.map((e) => e.toMap()).toList();
    }
    return data;
  }
}
