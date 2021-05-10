import 'package:lama_app/app/model/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider{
  static const String tableUser = "user";
  static const String columnId = "id";
  static const String columnName = "name";
  static const String columnPassword = "password";
  static const String columnGrade = "grade";
  static const String columnCoins = "coins";
  static const String columnIsAdmin = "isAdmin";

  static const String tableAchievements = "achievement";
  static const String columnAchievementsId = "id";
  static const String ColumnAchievementsName = "achievementID";

  static const String tableUserHasAchievements = "user_has_achievement";
  static const String ColumnUserId = "userID";
  static const String columnAchievementId = "achievementID";

  static const String tableGames = "game";
  static const String columnGamesId = "id";
  static const String columnGamesName = "name";

  static const String tableHighscore = "highscore";
  static const String columnGameId = "gameID";
  static const String columnScore = "score";

  static const String tableSubjects = "subject";
  static const String columnSubjectsId = "id";
  static const String columnSubjectsName = "name";

  static const String tableUserSolvedTaskAmount = "user_solved_task_amount";
  static const String columnSubjectId = "subjectID";
  static const String columnAmount = "amount";

  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();

  Database _database;

  Future<Database> get database async {
    print("database getter called!");

    if(_database != null){
      return _database;
    }

    _database = await createDatabase();

    return _database;
  }

  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();

    return await openDatabase(
        join(dbPath, "userDB.db"),
     version: 1,
      onCreate: (Database database, int version) async{
          print("Creating User Table");

          await database.execute(
            "Create TABLE $tableUser("
                "$columnId INTEGER PRIMARY KEY AUTOINCREMENT,"
                "$columnSubjectsName TEXT,"
                "$columnPassword TEXT,"
                "$columnGrade INTEGER,"
                "$columnCoins INTEGER,"
                "$columnIsAdmin INTEGER,"
            ")"
            "Create TABLE $tableAchievements("
              "$columnAchievementsId INTEGER PRIMARY KEY AUTOINCREMENT,"
              "$ColumnAchievementsName TEXT,"
            ")"
            "Create TABLE $tableUserHasAchievements("
              "$ColumnUserId INTEGER,"
                "$columnAchievementId INTEGER,"
            ")"
            "Create TABLE $tableGames("
              "$columnGamesId INTEGER PRIMARY KEY AUTOINCREMENT,"
              "$columnGamesName TEXT,"
            ")"
            "Create TABLE $tableHighscore("
              "$columnId INTEGER PRIMARY KEY AUTOINCREMENT,"
              "$columnGameId INTEGER,"
              "$columnScore INTEGER,"
              "$ColumnUserId INTEGER,"
            ")"
            "Create TABLE $tableSubjects("
              "$columnSubjectId INTEGER PRIMARY KEY AUTOINCREMENT,"
              "$columnSubjectsName TEXT,"
            ")"
            "Create TABLE $tableUserSolvedTaskAmount("
              "$ColumnUserId INTEGER,"
              "$columnSubjectId INTEGER,"
              "$columnAmount INTEGER"
            ")",
          );
      }
    );
  }
  Future<List<User>> getUser() async {
    final db = await database;

    var users = await db.query(
        tableUser,
        columns:[columnId, columnName, columnPassword, columnGrade, columnCoins, columnIsAdmin]
    );
    List<User> userList = List<User>();

    users.forEach((currentUser) {
      User user = User.fromMap(currentUser);

      userList.add(user);
    });

    return userList;
  }

  Future<User> insert (User user) async {
    final db = await database;
    user.id = await db.insert(tableUser, user.toMap());
    return user;
  }
}