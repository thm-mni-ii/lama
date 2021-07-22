
//set table name
final String tableAchievements = "achievement";

//set column names
class AchievementsFields{
  static final String columnAchievementsId = "id";
  static final String columnAchievementsName = "name";
}

class Achievement {
  int id;
  String name;

  Achievement({this.name});
  //Map the variables and return the map
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      AchievementsFields.columnAchievementsName: name,
    };
    return map;
  }
  //get the data from an map
  Achievement.fromMap(Map<String, dynamic> map) {
    id = map[AchievementsFields.columnAchievementsId];
    name = map[AchievementsFields.columnAchievementsName];
  }
}