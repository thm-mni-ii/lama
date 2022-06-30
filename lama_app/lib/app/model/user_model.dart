import 'package:lama_app/util/input_validation.dart';

//set table name
final String tableUser = "user";

///Set the column names
///
/// Author: F.Brecher
class UserFields {
  static final String columnId = "id";
  static final String columnName = "name";
  static final String columnPassword = "password";
  static final String columnGrade = "grade";
  static final String columnCoins = "coins";
  static final String columnIsAdmin = "isAdmin";
  static final String columnAvatar = "avatar";
  static final String columnHighscorePermission = "highscorePermission";
  static final String columnIsGuest = "isGuest";
}

///This class help to work with the data's from the user table
///
/// Author: F.Brecher
class User {
  int? id;
  String? name;
  String? password;
  int? grade;
  int? coins;
  bool? isAdmin;
  String? avatar;
  bool? highscorePermission;
  bool? isGuest;

  User(
      {this.name,
      this.password,
      this.grade,
      this.coins,
      this.isAdmin,
      this.avatar,
      this.highscorePermission,
      this.isGuest});

  ///Map the variables
  ///
  ///{@return} Map<String, dynamic>
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      UserFields.columnName: name,
      UserFields.columnPassword: password,
      UserFields.columnGrade: grade,
      UserFields.columnCoins: coins,
      UserFields.columnIsAdmin: (isAdmin == null || !isAdmin!) ? 0 : 1,
      UserFields.columnAvatar: avatar,
      UserFields.columnHighscorePermission:
          (highscorePermission == null || !highscorePermission!) ? 0 : 1,
      UserFields.columnIsGuest: (isGuest == null || !isGuest!) ? 0 : 1,
    };
    return map;
  }

  ///get the data from the map
  ///
  ///{@param} Map<String, dynamic> map
  User.fromMap(Map<dynamic, dynamic> map) {
    id = map[UserFields.columnId];
    name = map[UserFields.columnName];
    grade = map[UserFields.columnGrade];
    coins = map[UserFields.columnCoins];
    isAdmin = map[UserFields.columnIsAdmin] == 1;
    avatar = map[UserFields.columnAvatar];
    highscorePermission = map[UserFields.columnHighscorePermission] == 1;
    isGuest = map[UserFields.columnIsGuest] == 1;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    bool isAdmin =
        json.containsKey('isAdmin') && json['isAdmin'] == 'ja' ? true : false;
    String avatar = isAdmin ? 'admin' : 'lama';
    int? coins = json.containsKey('coins') ? json['coins'] : 0;
    bool highscorePermission =
        json.containsKey('isAdmin') && json['highscorePermission'] == 'ja'
            ? true
            : false;
    bool isGuest =
        json.containsKey('isGuest') && json['isGuest'] == 'ja' ? true : false;

    return User(
      name: json['name'],
      password: json['password'],
      grade: json['grade'],
      coins: coins,
      isAdmin: isAdmin,
      avatar: avatar,
      highscorePermission: highscorePermission,
      isGuest: isGuest,
    );
  }

  static String? isValidUser(Map<String, dynamic> json) {
    if (!(json.containsKey('name') && json['name'] is String))
      return 'Feld ("name":...) fehlt oder ist fehlerhaft! \n Hinweis: ("name":"NUTZERNAME",)';
    if (!(json.containsKey('password') && json['password'] is String))
      return 'Feld ("password":...) fehlt oder ist fehlerhaft! \n Hinweis: ("password":"PASSWORT",)';
    if (!(json.containsKey('grade') && json['grade'] is int))
      return 'Feld ("grade":...) fehlt oder ist fehlerhaft! \n Hinweis: ("grade":ZAHL,)';
    if (json.containsKey('coins') && !(json['coins'] is int))
      return 'Feld ("coins":...) ist fehlerhaft! \n Hinweis: ("coins":ZAHL,)';

    if (json.containsKey('isAdmin') && !(json['isAdmin'] is String))
      return 'Feld ("isAdmin":...) ist fehlerhaft! \n Hinweis: ("isAdmin":"ja/nein",)';
    if (json.containsKey('isAdmin') &&
        (json['isAdmin'] != 'ja' && (json['isAdmin'] != 'nein')))
      return 'Optionales Feld ("isAdmin":...) muss die Werte "ja" oder "nein" enthalten';

    if (json.containsKey('highscorePermission') &&
        !(json['highscorePermission'] is String))
      return 'Feld ("highscorePermission":...) ist fehlerhaft! \n Hinweis: ("highscorePermission":"ja/nein",)';
    if (json.containsKey('highscorePermission') &&
        (json['highscorePermission'] != 'ja' &&
            (json['highscorePermission'] != 'nein')))
      return 'Optionales Feld ("highscorePermission":...) muss die Werte "ja" oder "nein" enthalten';

    if (json.containsKey('isGuest') && !(json['isGuest'] is String))
      return 'Feld ("isGuest":...) ist fehlerhaft! \n Hinweis: ("isGuest":"ja/nein",)';
    if (json.containsKey('isGuest') &&
        (json['isGuest'] != 'ja' && (json['isGuest'] != 'nein')))
      return 'Optionales Feld ("isGuest":...) muss die Werte "ja" oder "nein" enthalten';

    String? error = InputValidation.inputPasswortValidation(json['password']);
    if (error != null) return error;

    error = InputValidation.inputUsernameValidation(json['name']);
    if (error != null) return error;
    return null;
  }
}

class UserList {
  List<User>? userList;
  UserList(this.userList);

  UserList.fromJson(Map<String, dynamic> json) {
    if (json['userList'] != null) {
      userList = <User>[];
      json['userList'].forEach((v) {
        userList!.add(new User.fromMap(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userList != null) {
      data['userList'] = this.userList!.map((e) => e.toMap()).toList();
    }
    return data;
  }
}
