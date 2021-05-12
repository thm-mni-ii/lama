import 'package:lama_app/app/model/achievement_model.dart';
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
  static const String columnAvatar = "avatar";

  static const String tableAchievements = "achievement";
  static const String columnAchievementsId = "id";
  static const String columnAchievementsName = "name";

  static const String tableUserHasAchievements = "user_has_achievement";
  static const String columnUserId = "userID";
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
          print("Creating Table");

          await database.execute(
            "Create TABLE $tableUser("
                "$columnId INTEGER PRIMARY KEY AUTOINCREMENT,"
                "$columnSubjectsName TEXT,"
                "$columnPassword TEXT,"
                "$columnGrade INTEGER,"
                "$columnCoins INTEGER,"
                "$columnIsAdmin INTEGER"
                "$columnAvatar TEXT"
                ");"
          );
          await database.execute(
                "Create TABLE $tableAchievements("
                "$columnAchievementsId INTEGER PRIMARY KEY AUTOINCREMENT,"
                "$columnAchievementsName TEXT"
                ");"
          );
          await database.execute(
                "Create TABLE $tableUserHasAchievements("
                "$columnUserId INTEGER,"
                "$columnAchievementId INTEGER"
                ");"
          );
          await database.execute(
                "Create TABLE $tableGames("
                "$columnGamesId INTEGER PRIMARY KEY AUTOINCREMENT,"
                "$columnGamesName TEXT"
                ");"
          );
          await database.execute(
                "Create TABLE $tableHighscore("
                "$columnId INTEGER PRIMARY KEY AUTOINCREMENT,"
                "$columnGameId INTEGER,"
                "$columnScore INTEGER,"
                "$columnUserId INTEGER"
                ");"
          );
          await database.execute(
                "Create TABLE $tableSubjects("
                "$columnSubjectId INTEGER PRIMARY KEY AUTOINCREMENT,"
                "$columnSubjectsName TEXT"
                ");"
          );
          await database.execute(
                "Create TABLE $tableUserSolvedTaskAmount("
                "$columnUserId INTEGER,"
                "$columnSubjectId INTEGER,"
                "$columnAmount INTEGER"
                ");"
          );
        }
    );
  }
  Future<List<User>> getUser() async {
    final db = await database;

    var users = await db.query(
        tableUser,
        columns:[columnId, columnName, columnPassword, columnGrade, columnCoins, columnIsAdmin, columnAvatar]
    );

    List<User> userList = <User>[];

    users.forEach((currentUser) {
      User user = User.fromMap(currentUser);

      userList.add(user);
    });

    return userList;
  }

  Future<List<Achievement>> getAchievements() async {
    final db = await database;

    var achievements = await db.query(
        tableAchievements,
        columns:[columnAchievementsId, columnAchievementsName]
    );

    List<Achievement> achievementList = <Achievement>[];

    achievements.forEach((currentAchievement) {
      Achievement achievement = Achievement.fromMap(currentAchievement);

      achievementList.add(achievement);
    });

    return achievementList;
  }

  Future<User> insertUser (User user) async {
    final db = await database;
    user.id = await db.insert(tableUser, user.toMap());
    return user;
  }

  Future<Achievement> insertAchievements (Achievement achievement) async {
    final db = await database;
    achievement.id = await db.insert(tableAchievements, achievement.toMap());
    return achievement;
  }

  Future<int> deleteUser(int id) async {
    final db = await database;

    return await db.delete(
        tableUser,
        where: "id = ?",
        whereArgs: [id]
    );
  }

  Future<int> deleteAchievement(int id) async {
    final db = await database;

    return await db.delete(
        tableAchievements,
        where: "id = ?",
        whereArgs: [id]
    );
  }

  Future<int> updateUser(User user) async {
    final db = await database;

    return await db.update(
        tableUser,
        user.toMap(),
        where: " id = ?",
        whereArgs: [user.id]);
  }

  Future<int> updateAchievement(Achievement achievement) async {
    final db = await database;

    return await db.update(
        tableAchievements,
        achievement.toMap(),
        where: " id = ?",
        whereArgs: [achievement.id]);
  }
}


