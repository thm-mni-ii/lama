import '../../db/database_provider.dart';

final String tableUserHasAchievements = "user_has_achievement";

class UserHasAchievementsFields{
  static final String columnUserId = "userID";
  static final String columnAchievementId = "achievementID";
}


class UserHasAchievement {
  int userID;
  int achievementID;

  UserHasAchievement({this.userID, this.achievementID});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      UserHasAchievementsFields.columnUserId: userID,
      UserHasAchievementsFields.columnAchievementId: achievementID
    };
    return map;
  }

  UserHasAchievement.fromMap(Map<String, dynamic> map) {
    userID = map[UserHasAchievementsFields.columnUserId];
    achievementID = map[UserHasAchievementsFields.columnAchievementId];
  }
}