import '../../db/database_provider.dart';

final String tableAchievements = "achievement";

class AchievementsFields{
  static final String columnAchievementsId = "id";
  static final String columnAchievementsName = "name";
}

class Achievement {
  int id;
  String name;

  Achievement({this.name});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      AchievementsFields.columnAchievementsName: name,
    };
    return map;
  }

  Achievement.fromMap(Map<String, dynamic> map) {
    id = map[AchievementsFields.columnAchievementsId];
    name = map[AchievementsFields.columnAchievementsName];
  }
}