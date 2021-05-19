import '../../db/database_provider.dart';

class Achievement {
  int id;
  String name;

  Achievement({this.name});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.columnAchievementsName: name,
    };
    return map;
  }

  Achievement.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseProvider.columnAchievementsId];
    name = map[DatabaseProvider.columnAchievementsName];
  }
}