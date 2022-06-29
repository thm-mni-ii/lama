//set table name
final String tableUserSolvedTaskAmount = "user_solved_task_amount";

///Set the column names
///
/// Author: F.Brecher
class UserSolvedTaskAmountFields {
  static final String columnUserId = "userID";
  static final String columnSubjectId = "id";
  static final String columnAmount = "amount";
}

///This class help to work with the data's from the UserSolvedTaskAmount table
///
/// Author: F.Brecher
class UserSolvedTaskAmount {
  int? userId;
  int? subjectId;
  int? amount;

  UserSolvedTaskAmount({this.userId, this.subjectId, this.amount});

  ///Map the variables
  ///
  ///{@return} Map<String, dynamic>
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      UserSolvedTaskAmountFields.columnUserId: userId,
      UserSolvedTaskAmountFields.columnSubjectId: subjectId,
      UserSolvedTaskAmountFields.columnAmount: amount,
    };
    return map;
  }

  ///get the data from the map
  ///
  ///{@param} Map<String, dynamic> map
  UserSolvedTaskAmount.fromMap(Map<String, dynamic> map) {
    userId = map[UserSolvedTaskAmountFields.columnUserId];
    subjectId = map[UserSolvedTaskAmountFields.columnSubjectId];
    amount = map[UserSolvedTaskAmountFields.columnAmount];
  }
}

class UserSolvedTaskAmountList {
  List<UserSolvedTaskAmount>? userSolvedTaskAmountList;
  UserSolvedTaskAmountList(this.userSolvedTaskAmountList);

  UserSolvedTaskAmountList.fromJson(Map<String, dynamic> json) {
    if (json['userSolvedTaskAmountList'] != null) {
      userSolvedTaskAmountList = <UserSolvedTaskAmount>[];
      json['userSolvedTaskAmountList'].forEach((v) {
        userSolvedTaskAmountList!.add(new UserSolvedTaskAmount.fromMap(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userSolvedTaskAmountList != null) {
      data['userSolvedTaskAmountList'] =
          this.userSolvedTaskAmountList!.map((e) => e.toMap()).toList();
    }
    return data;
  }
}
