import '../../db/database_provider.dart';

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
      DatabaseProvider.columnName: name,
      DatabaseProvider.columnPassword: password,
      DatabaseProvider.columnGrade: grade,
      DatabaseProvider.columnCoins: coins,
      DatabaseProvider.columnIsAdmin: isAdmin ? 1 : 0,
      DatabaseProvider.columnAvatar: avatar
    };
    return map;
  }

  User.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseProvider.columnId];
    name = map[DatabaseProvider.columnName];
    password = map[DatabaseProvider.columnPassword];
    grade = map[DatabaseProvider.columnGrade];
    coins = map[DatabaseProvider.columnCoins];
    isAdmin = map[DatabaseProvider.columnIsAdmin] == 1;
    avatar = map[DatabaseProvider.columnAvatar];
  }
}
