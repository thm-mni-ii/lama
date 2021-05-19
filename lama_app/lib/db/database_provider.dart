import 'package:lama_app/app/model/achievement_model.dart';
import 'package:lama_app/app/model/game_model.dart';
import 'package:lama_app/app/model/highscore_model.dart';
import 'package:lama_app/app/model/password_model.dart';
import 'package:lama_app/app/model/userHasAchievement_model.dart';
import 'package:lama_app/app/model/subject_model.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
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
  static const String columnSubjectId = "id";
  static const String columnAmount = "amount";

  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();

  Database _database;

  Future<Database> get database async {
    print("database getter called!");

    if (_database != null) {
      return _database;
    }

    _database = await createDatabase();

    return _database;
  }

  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();

    return await openDatabase(join(dbPath, "userDB.db"), version: 1,
        onCreate: (Database database, int version) async {
      print("Creating Table");

      await database.execute("Create TABLE $tableUser("
          "$columnId INTEGER PRIMARY KEY AUTOINCREMENT,"
          "$columnSubjectsName TEXT,"
          "$columnPassword TEXT,"
          "$columnGrade INTEGER,"
          "$columnCoins INTEGER,"
          "$columnIsAdmin INTEGER,"
          "$columnAvatar TEXT"
          ");");
      await database.execute("Create TABLE $tableAchievements("
          "$columnAchievementsId INTEGER PRIMARY KEY AUTOINCREMENT,"
          "$columnAchievementsName TEXT"
          ");");
      await database.execute("Create TABLE $tableUserHasAchievements("
          "$columnUserId INTEGER,"
          "$columnAchievementId INTEGER"
          ");");
      await database.execute("Create TABLE $tableGames("
          "$columnGamesId INTEGER PRIMARY KEY AUTOINCREMENT,"
          "$columnGamesName TEXT"
          ");");
      await database.execute("Create TABLE $tableHighscore("
          "$columnId INTEGER PRIMARY KEY AUTOINCREMENT,"
          "$columnGameId INTEGER,"
          "$columnScore INTEGER,"
          "$columnUserId INTEGER"
          ");");
      await database.execute("Create TABLE $tableSubjects("
          "$columnSubjectsId INTEGER PRIMARY KEY AUTOINCREMENT,"
          "$columnSubjectsName TEXT"
          ");");
      await database.execute("Create TABLE $tableUserSolvedTaskAmount("
          "$columnUserId INTEGER,"
          "$columnSubjectId INTEGER,"
          "$columnAmount INTEGER"
          ");");
    });
  }

  Future<List<User>> getUser() async {
    final db = await database;

    var users = await db.query(tableUser, columns: [
      columnId,
      columnName,
      columnGrade,
      columnCoins,
      columnIsAdmin,
      columnAvatar
    ]);

    List<User> userList = <User>[];

    users.forEach((currentUser) {
      User user = User.fromMap(currentUser);

      userList.add(user);
    });

    return userList;
  }

  Future<List<Achievement>> getAchievements() async {
    final db = await database;

    var achievements = await db.query(tableAchievements,
        columns: [columnAchievementsId, columnAchievementsName]);

    List<Achievement> achievementList = <Achievement>[];

    achievements.forEach((currentAchievement) {
      Achievement achievement = Achievement.fromMap(currentAchievement);

      achievementList.add(achievement);
    });

    return achievementList;
  }

  Future<List<UserHasAchievement>> getUserHasAchievements() async {
    final db = await database;

    var userHasAchievements = await db.query(tableUserHasAchievements,
        columns: [columnUserId, columnAchievementId]);

    List<UserHasAchievement> userHasAchievementList = <UserHasAchievement>[];

    userHasAchievements.forEach((currentAchievement) {
      UserHasAchievement userHasAchievement = UserHasAchievement.fromMap(currentAchievement);

      userHasAchievementList.add(userHasAchievement);
    });

    return userHasAchievementList;
  }

  Future<List<Game>> getGames() async {
    final db = await database;

    var games = await db.query(tableGames,
        columns: [columnGamesId, columnGamesName]);

    List<Game> gameList = <Game>[];

    games.forEach((currentGame) {
      Game game = Game.fromMap(currentGame);

      gameList.add(game);
    });

    return gameList;
  }

  Future<List<Highscore>> getHighscores() async {
    final db = await database;

    var highscores = await db.query(tableHighscore,
        columns: [columnId, columnGameId, columnScore, columnUserId]);

    List<Highscore> highscoreList = <Highscore>[];

    highscores.forEach((currentHighscore) {
      Highscore highscore = Highscore.fromMap(currentHighscore);

      highscoreList.add(highscore);
    });

    return highscoreList;
  }

  Future<List<Subject>> getSubjects() async {
    final db = await database;

    var subjects = await db.query(tableSubjects,
        columns: [columnSubjectsId, columnSubjectsName]);

    List<Subject> subjectList = <Subject>[];

    subjects.forEach((currentSubject) {
      Subject subject = Subject.fromMap(currentSubject);

      subjectList.add(subject);
    });

    return subjectList;
  }

  Future<User> insertUser(User user) async {
    final db = await database;
    user.id = await db.insert(tableUser, user.toMap());
    return user;
  }

  Future<Achievement> insertAchievement(Achievement achievement) async {
    final db = await database;
    achievement.id = await db.insert(tableAchievements, achievement.toMap());
    return achievement;
  }

    insertUserHasAchievement(User user, Achievement achievement) async {
    final db = await database;
    UserHasAchievement userHasAchievement = UserHasAchievement(
      userID: user.id,
      achievementID: achievement.id
    );
    await db.insert(tableUserHasAchievements, userHasAchievement.toMap());
  }

  Future<Game> insertGame(Game game) async {
    final db = await database;
    game.id = await db.insert(tableGames, game.toMap());
    return game;
  }

  Future<Highscore> insertHighscore(Highscore highscore) async {
    final db = await database;
    highscore.id = await db.insert(tableHighscore, highscore.toMap());
    return highscore;
  }

  Future<Subject> insertSubject(Subject subject) async {
    final db = await database;
    subject.id = await db.insert(tableSubjects, subject.toMap());
    return subject;
  }

  Future<int> deleteUser(int id) async {
    final db = await database;

    return await db.delete(tableUser, where: "id = ?", whereArgs: [id]);
  }

  Future<int> deleteAchievement(int id) async {
    final db = await database;

    return await db.delete(tableAchievements, where: "id = ?", whereArgs: [id]);
  }

  Future<int> deleteUserHasAchievement(User user, Achievement achievement) async {
    final db = await database;
    return await db.delete(tableUserHasAchievements, where: "userId = ? and achievementID = ? ", whereArgs: [user.id, achievement.id]);
  }

  Future<int> deleteGame(int id) async {
    final db = await database;

    return await db.delete(tableGames, where: "id = ?", whereArgs: [id]);
  }

  Future<int> deleteHighscore(int id) async {
    final db = await database;

    return await db.delete(tableHighscore, where: "id = ?", whereArgs: [id]);
  }

  Future<int> deleteSubject(int id) async {
    final db = await database;

    return await db.delete(tableSubjects, where: "id = ?", whereArgs: [id]);
  }

  Future<int> updateUser(User user) async {
    final db = await database;

    return await db.update(tableUser, user.toMap(),
        where: " id = ?", whereArgs: [user.id]);
  }

  Future<int> updateAchievement(Achievement achievement) async {
    final db = await database;

    return await db.update(tableAchievements, achievement.toMap(),
        where: " id = ?", whereArgs: [achievement.id]);
  }

  Future<int> updateGame(Game game) async {
    final db = await database;

    return await db.update(tableGames, game.toMap(),
        where: " id = ?", whereArgs: [game.id]);
  }

  Future<int> updateHighscore(Highscore highscore) async {
    final db = await database;

    return await db.update(tableHighscore, highscore.toMap(),
        where: " id = ?", whereArgs: [highscore.id]);
  }

  Future<int> updateSubject(Subject subject) async {
    final db = await database;

    return await db.update(tableSubjects, subject.toMap(),
        where: " id = ?", whereArgs: [subject.id]);
  }

  Future<int> checkPassword(String password, User user) async{
    final db = await database;

    var passwords = await db.query(tableUser,
        columns: [columnPassword],
        where: "id = ?",
        whereArgs: [user.id]);

    Password pswd = Password.fromMap(passwords.first);

    if (password.length > 0){
      return (password.compareTo(pswd.password) == 0 ? 1 : 0);
    }
    return null;
  }

  Future<int> updatePassword(String newPassword, User user) async{
    final db = await database;
    Password password = Password( password: newPassword);
    return await db.update(tableUser,
        password.toMap(),
        where: "id = ?",
        whereArgs: [user.id]);
  }
}
