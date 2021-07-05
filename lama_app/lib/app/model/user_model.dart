import '../../db/database_provider.dart';

final String tableUser = "user";

class UserFields{
  static final String columnId = "id";
  static final String columnName = "name";
  static final String columnPassword = "password";
  static final String columnGrade = "grade";
  static final String columnCoins = "coins";
  static final String columnIsAdmin = "isAdmin";
  static final String columnAvatar = "avatar";
}

class User {
  int id;
  String name;
  String password;
  int grade;
  int coins;
  bool isAdmin;
  String avatar;

  User(
      {this.name,
      this.password,
      this.grade,
      this.coins,
      this.isAdmin,
      this.avatar});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      UserFields.columnName: name,
      UserFields.columnPassword: password,
      UserFields.columnGrade: grade,
      UserFields.columnCoins: coins,
      UserFields.columnIsAdmin: isAdmin ? 1 : 0,
      UserFields.columnAvatar: avatar
    };
    return map;
  }

  User.fromMap(Map<String, dynamic> map) {
    id = map[UserFields.columnId];
    name = map[UserFields.columnName];
    grade = map[UserFields.columnGrade];
    coins = map[UserFields.columnCoins];
    isAdmin = map[UserFields.columnIsAdmin] == 1;
    avatar = map[UserFields.columnAvatar];
  }
}
