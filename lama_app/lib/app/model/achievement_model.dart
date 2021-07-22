
//set table name
final String tableAchievements = "achievement";

///Set the column names
///
/// Author: F.Brecher
class AchievementsFields{
  static final String columnAchievementsId = "id";
  static final String columnAchievementsName = "name";
}

///This class help to work with the data's from the achievement table
///
/// Author: F.Brecher
class Achievement {
  int id;
  String name;

  Achievement({this.name});

  ///Map the variables
  ///
  ///{@return} Map<String, dynamic>
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      AchievementsFields.columnAchievementsName: name,
    };
    return map;
  }

  ///get the data from the map
  ///
  ///{@param} Map<String, dynamic> map
  Achievement.fromMap(Map<String, dynamic> map) {
    id = map[AchievementsFields.columnAchievementsId];
    name = map[AchievementsFields.columnAchievementsName];
  }
}