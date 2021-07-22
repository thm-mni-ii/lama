//set table name
final String tableUserHasAchievements = "user_has_achievement";
//set column names
class UserHasAchievementsFields{
  static final String columnUserId = "userID";
  static final String columnAchievementId = "achievementID";
}


class UserHasAchievement {
  int userID;
  int achievementID;

  UserHasAchievement({this.userID, this.achievementID});
  //Map the variables and return the map
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      UserHasAchievementsFields.columnUserId: userID,
      UserHasAchievementsFields.columnAchievementId: achievementID
    };
    return map;
  }
  //get the data from an map
  UserHasAchievement.fromMap(Map<String, dynamic> map) {
    userID = map[UserHasAchievementsFields.columnUserId];
    achievementID = map[UserHasAchievementsFields.columnAchievementId];
  }
}