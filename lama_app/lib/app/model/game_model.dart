//set table name
final String tableGames = "game";

//set column names
class GamesFields{
  static final String columnGamesId = "id";
  static final String columnGamesName = "name";
}

class Game {
  int id;
  String name;

  Game({this.name});
  //Map the variables and return the map
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      GamesFields.columnGamesName: name,
    };
    return map;
  }
  //get the data from an map
  Game.fromMap(Map<String, dynamic> map) {
    id = map[GamesFields.columnGamesId];
    name = map[GamesFields.columnGamesName];
  }
}