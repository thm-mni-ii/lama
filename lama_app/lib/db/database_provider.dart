import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lama_app/app/model/achievement_model.dart';
import 'package:lama_app/app/model/game_model.dart';
import 'package:lama_app/app/model/highscore_model.dart';
import 'package:lama_app/app/model/left_to_solve_model.dart';
import 'package:lama_app/app/model/password_model.dart';
import 'package:lama_app/app/model/taskUrl_model.dart';
import 'package:lama_app/app/model/userHasAchievement_model.dart';
import 'package:lama_app/app/model/subject_model.dart';
import 'package:lama_app/app/model/userSolvedTaskAmount_model.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/db/database_migrator.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  int currentVersion = 1;
  int oldVersion = 0;

  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();

  Database _database;

  Future<Database> get database async {
  //Check if there is currently a database and if the version of the database is the current version.
  //if it is the case, return the databse
    if (_database != null) {
      if (await _database.getVersion() == currentVersion) {
        return _database;
      }
    }
//if there is no database or the version is not the current version call createDatabase()
    _database = await createDatabase();

    return _database;
  }

  Future<Database> createDatabase() async {
    //get the Database Path for the current device
    String dbPath = await getDatabasesPath();
    if (_database != null) {
      //get the database Version on the device
      oldVersion = await _database.getVersion();
    }

    return await openDatabase(
      join(dbPath, "userDB.db"),
      version: currentVersion,
      //if there is no database on the device call onCreate
      onCreate: (Database database, int version) async {
        DBMigrator.migrations.keys.toList()
          ..sort()
          ..forEach((j) async {
            Map migrationsVersion = DBMigrator.migrations[j];
            migrationsVersion.keys.toList()
              ..sort()
              ..forEach((k) async {
                var script = migrationsVersion[k];
                await database.execute(script);
              });
          });
      },
      //if there is a database on the device, but the version is not the current version call onUpgrade
      onUpgrade: (Database database, int oldVersion, int newVersion) async {
        //Map the entrys from migrations new, which are higher then the oldVersion.
        var upgradeScripts = new Map.fromIterable(
            DBMigrator.migrations.keys.where((j) => j > oldVersion),
            key: (j) => j,
            value: (j) => DBMigrator.migrations[j]);

        if (upgradeScripts.length == 0) return;

        upgradeScripts.keys.toList()
          ..sort()
          ..forEach((j) async {
            Map migrationsVersion = upgradeScripts[j];
            migrationsVersion.keys.toList()
              ..sort()
              ..forEach((k) async {
                var script = migrationsVersion[k];
                await database.execute(script);
              });
          });
      },
    );
  }
//get a list from typ User from the database.
  Future<List<User>> getUser() async {
    final db = await database;

    var users = await db.query(tableUser, columns: [
      UserFields.columnId,
      UserFields.columnName,
      UserFields.columnGrade,
      UserFields.columnCoins,
      UserFields.columnIsAdmin,
      UserFields.columnAvatar
    ]);

    List<User> userList = <User>[];

    users.forEach((currentUser) {
      User user = User.fromMap(currentUser);

      userList.add(user);
    });

    return userList;
  }
//get a list from typ Achievement from the database.
  Future<List<Achievement>> getAchievements() async {
    final db = await database;

    var achievements = await db.query(tableAchievements, columns: [
      AchievementsFields.columnAchievementsId,
      AchievementsFields.columnAchievementsName
    ]);

    List<Achievement> achievementList = <Achievement>[];

    achievements.forEach((currentAchievement) {
      Achievement achievement = Achievement.fromMap(currentAchievement);

      achievementList.add(achievement);
    });

    return achievementList;
  }
//get a list from typ UserHasAchievement from the database.
  Future<List<UserHasAchievement>> getUserHasAchievements() async {
    final db = await database;

    var userHasAchievements =
        await db.query(tableUserHasAchievements, columns: [
      UserHasAchievementsFields.columnUserId,
      UserHasAchievementsFields.columnAchievementId
    ]);

    List<UserHasAchievement> userHasAchievementList = <UserHasAchievement>[];

    userHasAchievements.forEach((currentAchievement) {
      UserHasAchievement userHasAchievement =
          UserHasAchievement.fromMap(currentAchievement);

      userHasAchievementList.add(userHasAchievement);
    });

    return userHasAchievementList;
  }
//get a list from typ Games from the database.
  Future<List<Game>> getGames() async {
    final db = await database;

    var games = await db.query(tableGames,
        columns: [GamesFields.columnGamesId, GamesFields.columnGamesName]);

    List<Game> gameList = <Game>[];

    games.forEach((currentGame) {
      Game game = Game.fromMap(currentGame);

      gameList.add(game);
    });

    return gameList;
  }
//get a list from typ highscores from the database.
  Future<List<Highscore>> getHighscores() async {
    final db = await database;

    var highscores = await db.query(tableHighscore, columns: [
      HighscoresFields.columnId,
      HighscoresFields.columnGameId,
      HighscoresFields.columnScore,
      HighscoresFields.columnUserId
    ]);

    List<Highscore> highscoreList = <Highscore>[];

    highscores.forEach((currentHighscore) {
      Highscore highscore = Highscore.fromMap(currentHighscore);

      highscoreList.add(highscore);
    });

    return highscoreList;
  }
//get a the highscore from an user in a specific game from the database.
  Future<int> getHighscoreOfUserInGame(User user, int gameID) async {
    final db = await database;

    var highscore = await db.query(tableHighscore,
        columns: [
          HighscoresFields.columnId,
          HighscoresFields.columnGameId,
          HighscoresFields.columnScore,
          HighscoresFields.columnUserId
        ],
        where:
            "${HighscoresFields.columnUserId} = ? and ${HighscoresFields.columnGameId} = ?",
        whereArgs: [user.id, gameID],
        orderBy: "${HighscoresFields.columnScore} DESC",
        limit: 1);

    if (highscore.isNotEmpty) {
      return Highscore.fromMap(highscore.first).score;
    }

    return 0;
  }
//get the highest score of an game from the database.
  Future<int> getHighscoreOfGame(int gameID) async {
    final db = await database;

    var highscore = await db.query(tableHighscore,
        columns: [
          HighscoresFields.columnId,
          HighscoresFields.columnGameId,
          HighscoresFields.columnScore,
          HighscoresFields.columnUserId
        ],
        where: "${HighscoresFields.columnGameId} = ?",
        whereArgs: [gameID],
        orderBy: "${HighscoresFields.columnScore} DESC",
        limit: 1);

    if (highscore.isNotEmpty) {
      return Highscore.fromMap(highscore.first).score;
    }

    return 0;
  }
//get a list from typ Subject from the database.
  Future<List<Subject>> getSubjects() async {
    final db = await database;

    var subjects = await db.query(tableSubjects, columns: [
      SubjectsFields.columnSubjectsId,
      SubjectsFields.columnSubjectsName
    ]);

    List<Subject> subjectList = <Subject>[];

    subjects.forEach((currentSubject) {
      Subject subject = Subject.fromMap(currentSubject);

      subjectList.add(subject);
    });

    return subjectList;
  }
//get a list from typ UserSolvedTaskAmount from the database.
  Future<List<UserSolvedTaskAmount>> getUserSolvedTaskAmount() async {
    final db = await database;

    var userSolvedTaskAmounts =
        await db.query(tableUserSolvedTaskAmount, columns: [
      UserSolvedTaskAmountFields.columnUserId,
      UserSolvedTaskAmountFields.columnSubjectId,
      UserSolvedTaskAmountFields.columnAmount
    ]);

    List<UserSolvedTaskAmount> userSolvedTaskAmountList =
        <UserSolvedTaskAmount>[];

    userSolvedTaskAmounts.forEach((currentUserSolvedTaskAmount) {
      UserSolvedTaskAmount userSolvedTaskAmount =
          UserSolvedTaskAmount.fromMap(currentUserSolvedTaskAmount);

      userSolvedTaskAmountList.add(userSolvedTaskAmount);
    });

    return userSolvedTaskAmountList;
  }
  //get a list from typ TaskUrl from the database.
  Future<List<TaskUrl>> getTaskUrl() async {
    final db = await database;

    var taskUrl = await db.query(tableTaskUrl,
        columns: [TaskUrlFields.columnId, TaskUrlFields.columnTaskUrl]);

    List<TaskUrl> taskUrlList = <TaskUrl>[];

    taskUrl.forEach((currentTaskUrl) {
      TaskUrl taskUrl = TaskUrl.fromMap(currentTaskUrl);

      taskUrlList.add(taskUrl);
    });

    return taskUrlList;
  }
  //insert an user in the database.
  //returns the user white the autoincremented id
  Future<User> insertUser(User user) async {
    final db = await database;
    user.id = await db.insert(tableUser, user.toMap());
    return user;
  }
  //insert an achievement in the database.
  //returns the achievement white the autoincremented id
  Future<Achievement> insertAchievement(Achievement achievement) async {
    final db = await database;
    achievement.id = await db.insert(tableAchievements, achievement.toMap());
    return achievement;
  }
  //insert the userId and the achievementId in the database.
  insertUserHasAchievement(User user, Achievement achievement) async {
    final db = await database;
    UserHasAchievement userHasAchievement =
        UserHasAchievement(userID: user.id, achievementID: achievement.id);
    await db.insert(tableUserHasAchievements, userHasAchievement.toMap());
  }
  //insert a game in the database.
  //returns the game white the autoincremented id
  Future<Game> insertGame(Game game) async {
    final db = await database;
    game.id = await db.insert(tableGames, game.toMap());
    return game;
  }
  //insert a highscore in the database.
  //returns the highscore white the autoincremented id
  Future<Highscore> insertHighscore(Highscore highscore) async {
    final db = await database;
    highscore.id = await db.insert(tableHighscore, highscore.toMap());
    return highscore;
  }
  //insert a subject in the database.
  //returns the subject white the autoincremented id
  Future<Subject> insertSubject(Subject subject) async {
    final db = await database;
    subject.id = await db.insert(tableSubjects, subject.toMap());
    return subject;
  }
  //insert an user, a subject and the amount in the database.
  insertUserSolvedTaskAmount(User user, Subject subject, int amount) async {
    final db = await database;
    UserSolvedTaskAmount userSolvedTaskAmount = UserSolvedTaskAmount(
        userId: user.id, subjectId: subject.id, amount: amount);
    await db.insert(tableUserSolvedTaskAmount, userSolvedTaskAmount.toMap());
  }
  //insert an taskUrl in the database.
  //returns the taskUrl white the autoincremented id
  Future<TaskUrl> insertTaskUrl(TaskUrl taskUrl) async {
    final db = await database;
    taskUrl.id = await db.insert(tableTaskUrl, taskUrl.toMap());
    return taskUrl;
  }
  //delete an entry from user
  Future<int> deleteUser(int id) async {
    final db = await database;

    return await db.delete(tableUser,
        where: "${UserFields.columnId} = ?", whereArgs: [id]);
  }
  //delete an entry from achievement
  Future<int> deleteAchievement(int id) async {
    final db = await database;

    return await db.delete(tableAchievements,
        where: "${AchievementsFields.columnAchievementsId} = ?",
        whereArgs: [id]);
  }
  //delete an entry from userHasAchievement
  Future<int> deleteUserHasAchievement(
      User user, Achievement achievement) async {
    final db = await database;
    return await db.delete(tableUserHasAchievements,
        where:
            "${UserHasAchievementsFields.columnUserId} = ? and ${UserHasAchievementsFields.columnAchievementId} = ? ",
        whereArgs: [user.id, achievement.id]);
  }
  //delete an entry from game
  Future<int> deleteGame(int id) async {
    final db = await database;

    return await db.delete(tableGames,
        where: "${GamesFields.columnGamesId} = ?", whereArgs: [id]);
  }
  //delete an entry from highscore
  Future<int> deleteHighscore(int id) async {
    final db = await database;

    return await db.delete(tableHighscore,
        where: "${HighscoresFields.columnId} = ?", whereArgs: [id]);
  }
  //delete an entry from subject
  Future<int> deleteSubject(int id) async {
    final db = await database;

    return await db.delete(tableSubjects,
        where: "${SubjectsFields.columnSubjectsId} = ?", whereArgs: [id]);
  }
  //delete an entry from userSolvedTaskAmount
  Future<int> deleteUserSolvedTaskAmount(User user, Subject subject) async {
    final db = await database;

    return await db.delete(tableUserSolvedTaskAmount,
        where:
            "${UserSolvedTaskAmountFields.columnSubjectId} = ? and ${UserSolvedTaskAmountFields.columnUserId} = ?",
        whereArgs: [subject.id, user.id]);
  }
  //delete an entry from taskUrl
  Future<int> deleteTaskUrl(int id) async {
    final db = await database;

    return await db.delete(tableTaskUrl,
        where: "${TaskUrlFields.columnId} = ?", whereArgs: [id]);
  }
  //update an entry from user
  Future<User> updateUser(User user) async {
    final db = await database;

    Password pswd = await _getPassword(user);
    User newUser = User(
        name: user.name,
        password: pswd.password,
        grade: user.grade,
        coins: user.coins,
        isAdmin: user.isAdmin,
        avatar: user.avatar);

    int updated = await db.update(tableUser, newUser.toMap(),
        where: " ${UserFields.columnId} = ?", whereArgs: [user.id]);

    if (updated != null) {
      return await _getUser(user.id);
    }
    return null;
  }
 //update the name column from an user
  Future<User> updateUserName(User user, String name) async {
    final db = await database;

    int updated = await db.update(
        tableUser, <String, dynamic>{UserFields.columnName: name},
        where: " ${UserFields.columnId} = ?", whereArgs: [user.id]);

    if (updated != null) {
      return await _getUser(user.id);
    }
    return null;
  }

  //update the grade column from an user
  Future<User> updateUserGrade(User user, int grade) async {
    final db = await database;

    int updated = await db.update(
        tableUser, <String, dynamic>{UserFields.columnGrade: grade},
        where: " ${UserFields.columnId} = ?", whereArgs: [user.id]);

    if (updated != null) {
      return await _getUser(user.id);
    }
    return null;
  }

  //update the coins column from an user
  Future<User> updateUserCoins(User user, int coins) async {
    final db = await database;

    int updated = await db.update(
        tableUser, <String, dynamic>{UserFields.columnCoins: coins},
        where: " ${UserFields.columnId} = ?", whereArgs: [user.id]);

    if (updated != null) {
      return await _getUser(user.id);
    }
    return null;
  }

  //update the isAdmin column from an user
  Future<User> updateUserIsAdmin(User user, bool isAdmin) async {
    final db = await database;

    int updated = await db.update(
        tableUser, <String, dynamic>{UserFields.columnIsAdmin: isAdmin ? 1 : 0},
        where: " ${UserFields.columnId} = ?", whereArgs: [user.id]);

    if (updated != null) {
      return await _getUser(user.id);
    }
    return null;
  }

  //update the avatar column from an user
  Future<User> updateUserAvatar(User user, String avatar) async {
    final db = await database;

    int updated = await db.update(
        tableUser, <String, dynamic>{UserFields.columnAvatar: avatar},
        where: " ${UserFields.columnId} = ?", whereArgs: [user.id]);

    if (updated != null) {
      return await _getUser(user.id);
    }
    return null;
  }

  //update an entry from achievement
  Future<int> updateAchievement(Achievement achievement) async {
    final db = await database;

    return await db.update(tableAchievements, achievement.toMap(),
        where: " ${AchievementsFields.columnAchievementsId} = ?",
        whereArgs: [achievement.id]);
  }
  //update an entry from game
  Future<int> updateGame(Game game) async {
    final db = await database;

    return await db.update(tableGames, game.toMap(),
        where: "${GamesFields.columnGamesId} = ?", whereArgs: [game.id]);
  }
  //update an entry from highscore
  Future<int> updateHighscore(Highscore highscore) async {
    final db = await database;

    return await db.update(tableHighscore, highscore.toMap(),
        where: "${HighscoresFields.columnId} = ?", whereArgs: [highscore.id]);
  }
  //update an entry from subject
  Future<int> updateSubject(Subject subject) async {
    final db = await database;

    return await db.update(tableSubjects, subject.toMap(),
        where: "${SubjectsFields.columnSubjectsId}  = ?",
        whereArgs: [subject.id]);
  }
  //update an entry from userSolvedTaskAmount
  Future<int> updateUserSolvedTaskAmount(
      User user, Subject subject, int amount) async {
    final db = await database;
    UserSolvedTaskAmount userSolvedTaskAmount = UserSolvedTaskAmount(
        userId: user.id, subjectId: subject.id, amount: amount);

    return await db.update(
        tableUserSolvedTaskAmount, userSolvedTaskAmount.toMap(),
        where:
            "${UserSolvedTaskAmountFields.columnSubjectId}  = ? and ${UserSolvedTaskAmountFields.columnUserId} = ?",
        whereArgs: [subject.id, user.id]);
  }
  //update an entry from TaskUrl
  Future<int> updateTaskUrl(TaskUrl taskUrl) async {
    final db = await database;

    return await db.update(tableTaskUrl, taskUrl.toMap(),
        where: " ${TaskUrlFields.columnId} = ?", whereArgs: [taskUrl.id]);
  }
  //check if the transferred password is the password from the user
  Future<int> checkPassword(String password, User user) async {
    Password pswd = await _getPassword(user);
    return (password.compareTo(pswd.password) == 0 ? 1 : 0);
  }
  //update the password column from an user
  Future<int> updatePassword(String newPassword, User user) async {
    final db = await database;
    Password password = Password(password: newPassword);
    return await db.update(tableUser, password.toMap(),
        where: "${UserFields.columnId} = ?", whereArgs: [user.id]);
  }
 //get an user
  Future<User> _getUser(int id) async {
    final db = await database;

    var users = await db.query(tableUser,
        columns: [
          UserFields.columnId,
          UserFields.columnName,
          UserFields.columnGrade,
          UserFields.columnCoins,
          UserFields.columnIsAdmin,
          UserFields.columnAvatar
        ],
        where: "${UserFields.columnId} = ?",
        whereArgs: [id]);

    if (users.length > 0) {
      User user = User.fromMap(users.first);
      return user;
    }
    return null;
  }
  //get the password from an user
  Future<Password> _getPassword(User user) async {
    final db = await database;
    var passwords = await db.query(tableUser,
        columns: [UserFields.columnPassword],
        where: "${UserFields.columnId} = ?",
        whereArgs: [user.id]);
    if (passwords.length > 0) {
      Password pswd = Password.fromMap(passwords.first);
      return pswd;
    }
    return null;
  }
  //delete all entry's from the database
  Future deleteDatabase() async {
    final db = await database;
    await db.delete(tableUser);
    await db.delete(tableAchievements);
    await db.delete(tableUserHasAchievements);
    await db.delete(tableGames);
    await db.delete(tableHighscore);
    await db.delete(tableHighscore);
    await db.delete(tableSubjects);
    await db.delete(tableUserSolvedTaskAmount);
    await db.delete(tableTaskUrl);
    await db.delete(tableLeftToSolve);
  }
  //insert a taskString, a leftToSolve value, an userId and a doesStill Exist Value in the table leftToSolve
  Future<int> insertLeftToSolve(
      String taskString, int leftToSolve, User user) async {
    final db = await database;
    LeftToSolve lts = LeftToSolve(
        taskString: taskString,
        leftToSolve: leftToSolve,
        userLTSId: user.id,
        doesStillExist: 0);
    return await db.insert(tableLeftToSolve, lts.toMap());
  }
 //get how the leftToSolve value from task and an specific User
  Future<int> getLeftToSolve(String taskString, User user) async {
    final db = await database;
    print("looking up task with: " + taskString);
    var leftToSolve = await db.query(tableLeftToSolve,
        columns: [LeftToSolveFields.columnLeftToSolve],
        where:
            "${LeftToSolveFields.columnTaskString} = ? and ${LeftToSolveFields.columnUserLTSId} = ?",
        whereArgs: [taskString, user.id]);
    if (leftToSolve.length > 0)
      return leftToSolve.first[LeftToSolveFields.columnLeftToSolve];
    return Future.value(-3);
  }

  Future<void> removeUnusedLeftToSolveEntries(
      List<Task> loadedTasks, User user) async {
    final db = await database;
    db.delete(tableLeftToSolve,
        where: "${LeftToSolveFields.columnUserLTSId} = ?",
        whereArgs: [user.id]);
    loadedTasks.forEach((task) {
      insertLeftToSolve(task.toString(), task.leftToSolve, user);
    });
  }
  //decrement the leftToSolve value from a task and an specific user
  Future<int> decrementLeftToSolve(Task t, User user) async {
    final db = await database;
    print("curVal: " + t.leftToSolve.toString());
    int newVal = max(t.leftToSolve - 1, -2);
    print("setting to: " + newVal.toString());
    return await db.update(tableLeftToSolve,
        <String, dynamic>{LeftToSolveFields.columnLeftToSolve: newVal},
        where:
            "${LeftToSolveFields.columnTaskString} = ? and ${LeftToSolveFields.columnUserLTSId} = ?",
        whereArgs: [t.toString(), user.id]);
  }
  //update the columns doesStillExist to 1 from all entry's where columnTaskString is the transferred task
  Future<int> setDoesStillExist(Task t) async {
    final db = await database;
    print("Set flag for " + t.toString());
    return await db.update(tableLeftToSolve,
        <String, dynamic>{LeftToSolveFields.columnDoesStillExist: 1},
        where: "${LeftToSolveFields.columnTaskString} = ?",
        whereArgs: [t.toString()]);
  }
  //delete all entry's where the column doesStillExist is 0
  Future<int> removeAllNonExistent() async {
    final db = await database;
    int val = 0;
    return await db.delete(tableLeftToSolve,
        where: "${LeftToSolveFields.columnDoesStillExist} = ?",
        whereArgs: [val]);
  }

  //update all columns doesStillExist to 0
  Future<int> resetAllStillExistFlags() async {
    final db = await database;
    return await db.update(tableLeftToSolve,
        <String, dynamic>{LeftToSolveFields.columnDoesStillExist: 0});
  }
}
