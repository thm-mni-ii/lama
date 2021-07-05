import '../../db/database_provider.dart';

final String tableUserSolvedTaskAmount = "user_solved_task_amount";

class UserSolvedTaskAmountFields{
  static final String columnUserId = "userID";
  static final String columnSubjectId = "id";
  static final String columnAmount = "amount";
}

class UserSolvedTaskAmount {
  int userId;
  int subjectId;
  int amount;

  UserSolvedTaskAmount({this.userId, this.subjectId, this.amount});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      UserSolvedTaskAmountFields.columnUserId: userId,
      UserSolvedTaskAmountFields.columnSubjectId: subjectId,
      UserSolvedTaskAmountFields.columnAmount: amount,
    };
    return map;
  }

  UserSolvedTaskAmount.fromMap(Map<String, dynamic> map) {
    userId = map[UserSolvedTaskAmountFields.columnUserId];
    subjectId = map[UserSolvedTaskAmountFields.columnSubjectId];
    amount = map[UserSolvedTaskAmountFields.columnAmount];
  }
}