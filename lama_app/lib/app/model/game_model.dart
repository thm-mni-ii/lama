import '../../db/database_provider.dart';

final String tableGames = "game";

class GamesFields{
  static final String columnGamesId = "id";
  static final String columnGamesName = "name";
}

class Game {
  int id;
  String name;

  Game({this.name});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      GamesFields.columnGamesName: name,
    };
    return map;
  }

  Game.fromMap(Map<String, dynamic> map) {
    id = map[GamesFields.columnGamesId];
    name = map[GamesFields.columnGamesName];
  }
}