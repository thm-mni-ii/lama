//set table name
final String tableUserHasAchievements = "user_has_achievement";

///Set the column names
///
/// Author: F.Brecher
class UserHasAchievementsFields{
  static final String columnUserId = "userID";
  static final String columnAchievementId = "achievementID";
}

///This class help to work with the data's from the userHasAchievement table
///
/// Author: F.Brecher
class UserHasAchievement {
  int userID;
  int achievementID;

  UserHasAchievement({this.userID, this.achievementID});

  ///Map the variables
  ///
  ///{@return} Map<String, dynamic>
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      UserHasAchievementsFields.columnUserId: userID,
      UserHasAchievementsFields.columnAchievementId: achievementID
    };
    return map;
  }

  ///get the data from the map
  ///
  ///{@param} Map<String, dynamic> map
  UserHasAchievement.fromMap(Map<String, dynamic> map) {
    userID = map[UserHasAchievementsFields.columnUserId];
    achievementID = map[UserHasAchievementsFields.columnAchievementId];
  }
}