import '../../db/database_provider.dart';

class Game {
  int id;
  String name;

  Game({this.name});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.columnGamesName: name,
    };
    return map;
  }

  Game.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseProvider.columnGamesId];
    name = map[DatabaseProvider.columnGamesName];
  }
}