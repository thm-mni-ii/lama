//set table name
final String tableGames = "game";

///Set the column names
///
/// Author: F.Brecher
class GamesFields{
  static final String columnGamesId = "id";
  static final String columnGamesName = "name";
}
///This class help to work with the data's from the game table
///
/// Author: F.Brecher
class Game {
  int id;
  String name;


  Game({this.name});

  ///Map the variables
  ///
  ///{@return} Map<String, dynamic>
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      GamesFields.columnGamesName: name,
    };
    return map;
  }

  ///get the data from the map
  ///
  ///{@param} Map<String, dynamic> map
  Game.fromMap(Map<String, dynamic> map) {
    id = map[GamesFields.columnGamesId];
    name = map[GamesFields.columnGamesName];
  }
}