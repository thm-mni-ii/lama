import '../../db/database_provider.dart';

class UserHasAchievement {
  int userID;
  int achievementID;

  UserHasAchievement({this.userID, this.achievementID});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.columnUserId: userID,
      DatabaseProvider.columnAchievementId: achievementID
    };
    return map;
  }

  UserHasAchievement.fromMap(Map<String, dynamic> map) {
    userID = map[DatabaseProvider.columnUserId];
    achievementID = map[DatabaseProvider.columnAchievementId];
  }
}