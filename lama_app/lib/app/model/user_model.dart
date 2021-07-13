import 'package:lama_app/util/input_validation.dart';

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

  factory User.fromJson(Map<String, dynamic> json) {
    bool isAdmin =
        json.containsKey('isAdmin') && json['isAdmin'] == 'ja' ? true : false;
    String avatar = isAdmin ? 'admin' : 'lama';
    int coins = json.containsKey('coins') ? json['coins'] : 0;

    return User(
      name: json['name'],
      password: json['password'],
      grade: json['grade'],
      coins: coins,
      isAdmin: isAdmin,
      avatar: avatar,
    );
  }

  static String isValidUser(Map<String, dynamic> json) {
    if (!(json.containsKey('name') && json['name'] is String))
      return 'Feld ("name":...) fehlt oder ist fehlerhaft! \n Hinweis: ("name":"NUTZERNAME",)';
    if (!(json.containsKey('password') && json['password'] is String))
      return 'Feld ("password":...) fehlt oder ist fehlerhaft! \n Hinweis: ("password":"PASSWORT",)';
    if (!(json.containsKey('grade') && json['grade'] is int))
      return 'Feld ("grade":...) fehlt oder ist fehlerhaft! \n Hinweis: ("grade":ZAHL,)';

    String error = InputValidation.inputPasswortValidation(json['password']);
    if (error != null) return error;

    error = InputValidation.inputUsernameValidation(json['name']);
    if (error != null) return error;
    return null;
  }
}
