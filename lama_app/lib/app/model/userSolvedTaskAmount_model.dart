import '../../db/database_provider.dart';

class UserSolvedTaskAmount {
  int userId;
  int subjectId;
  int amount;

  UserSolvedTaskAmount({this.userId, this.subjectId, this.amount});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.columnUserId: userId,
      DatabaseProvider.columnSubjectId: subjectId,
      DatabaseProvider.columnAmount: amount,
    };
    return map;
  }

  UserSolvedTaskAmount.fromMap(Map<String, dynamic> map) {
    userId = map[DatabaseProvider.columnUserId];
    subjectId = map[DatabaseProvider.columnSubjectId];
    amount = map[DatabaseProvider.columnAmount];
  }
}