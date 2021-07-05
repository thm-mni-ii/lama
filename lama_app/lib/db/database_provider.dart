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
    print("database getter called!");

    if (_database != null) {
      if(await _database.getVersion() == currentVersion) {
        return _database;
      }
    }

    _database = await createDatabase();

    return _database;
  }

  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();
    if(_database != null) {
      oldVersion = await _database.getVersion();
    }

    return await openDatabase(join(dbPath, "userDB.db"), version: currentVersion,
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

    onUpgrade: (Database database, int oldVersion, int newVersion) async {

      var upgradeScripts = new Map.fromIterable(
          DBMigrator.migrations.keys.where((j) => j > oldVersion),
      key: (j) => j, value: (j) => DBMigrator.migrations[j]
      );

      if(upgradeScripts.length == 0) return;

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

  Future<List<Achievement>> getAchievements() async {
    final db = await database;

    var achievements = await db.query(tableAchievements,
        columns: [AchievementsFields.columnAchievementsId, AchievementsFields.columnAchievementsName]);

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
        columns: [UserHasAchievementsFields.columnUserId, UserHasAchievementsFields.columnAchievementId]);

    List<UserHasAchievement> userHasAchievementList = <UserHasAchievement>[];

    userHasAchievements.forEach((currentAchievement) {
      UserHasAchievement userHasAchievement =
          UserHasAchievement.fromMap(currentAchievement);

      userHasAchievementList.add(userHasAchievement);
    });

    return userHasAchievementList;
  }

  Future<List<Game>> getGames() async {
    final db = await database;

    var games =
        await db.query(tableGames, columns: [GamesFields.columnGamesId, GamesFields.columnGamesName]);

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
        columns: [
          HighscoresFields.columnId,
          HighscoresFields.columnGameId,
          HighscoresFields.columnScore,
          HighscoresFields.columnUserId]);

    List<Highscore> highscoreList = <Highscore>[];

    highscores.forEach((currentHighscore) {
      Highscore highscore = Highscore.fromMap(currentHighscore);

      highscoreList.add(highscore);
    });

    return highscoreList;
  }

  Future<int> getHighscoreOfUserInGame(User user, int gameID) async {
    final db = await database;

    var highscore = await db.query(tableHighscore,
      columns: [
        HighscoresFields.columnId,
        HighscoresFields.columnGameId,
        HighscoresFields.columnScore,
        HighscoresFields.columnUserId],
      where: "${HighscoresFields.columnUserId} = ? and ${HighscoresFields.columnGameId} = ?",
      whereArgs: [user.id, gameID],
      orderBy: "${HighscoresFields.columnScore} DESC",
      limit: 1);

    if (highscore.isNotEmpty) {
      return Highscore.fromMap(highscore.first).score;
    }

    return 0;
  }

  Future<int> getHighscoreOfGame(int gameID) async {
    final db = await database;

    var highscore = await db.query(tableHighscore,
        columns: [
          HighscoresFields.columnId,
          HighscoresFields.columnGameId,
          HighscoresFields.columnScore,
          HighscoresFields.columnUserId],
        where: "${HighscoresFields.columnGameId} = ?",
        whereArgs: [gameID],
        orderBy: "${HighscoresFields.columnScore} DESC",
        limit: 1);

    if (highscore.isNotEmpty) {
      return Highscore.fromMap(highscore.first).score;
    }

    return 0;
  }

  Future<List<Subject>> getSubjects() async {
    final db = await database;

    var subjects = await db
        .query(tableSubjects, columns: [SubjectsFields.columnSubjectsId, SubjectsFields.columnSubjectsName]);

    List<Subject> subjectList = <Subject>[];

    subjects.forEach((currentSubject) {
      Subject subject = Subject.fromMap(currentSubject);

      subjectList.add(subject);
    });

    return subjectList;
  }

  Future<List<UserSolvedTaskAmount>> getUserSolvedTaskAmount() async {
    final db = await database;

    var userSolvedTaskAmounts = await db.query(tableUserSolvedTaskAmount,
        columns: [
          UserSolvedTaskAmountFields.columnUserId,
          UserSolvedTaskAmountFields.columnSubjectId,
          UserSolvedTaskAmountFields.columnAmount]);

    List<UserSolvedTaskAmount> userSolvedTaskAmountList =
        <UserSolvedTaskAmount>[];

    userSolvedTaskAmounts.forEach((currentUserSolvedTaskAmount) {
      UserSolvedTaskAmount userSolvedTaskAmount =
          UserSolvedTaskAmount.fromMap(currentUserSolvedTaskAmount);

      userSolvedTaskAmountList.add(userSolvedTaskAmount);
    });

    return userSolvedTaskAmountList;
  }

  Future<List<TaskUrl>> getTaskUrl() async {
    final db = await database;

    var taskUrl =
        await db.query(tableTaskUrl, columns: [TaskUrlFields.columnId, TaskUrlFields.columnTaskUrl]);

    List<TaskUrl> taskUrlList = <TaskUrl>[];

    taskUrl.forEach((currentTaskUrl) {
      TaskUrl taskUrl = TaskUrl.fromMap(currentTaskUrl);

      taskUrlList.add(taskUrl);
    });

    return taskUrlList;
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
    UserHasAchievement userHasAchievement =
        UserHasAchievement(userID: user.id, achievementID: achievement.id);
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

  insertUserSolvedTaskAmount(User user, Subject subject, int amount) async {
    final db = await database;
    UserSolvedTaskAmount userSolvedTaskAmount = UserSolvedTaskAmount(
        userId: user.id, subjectId: subject.id, amount: amount);
    await db.insert(tableUserSolvedTaskAmount, userSolvedTaskAmount.toMap());
  }

  Future<TaskUrl> insertTaskUrl(TaskUrl taskUrl) async {
    final db = await database;
    taskUrl.id = await db.insert(tableTaskUrl, taskUrl.toMap());
    return taskUrl;
  }

  Future<int> deleteUser(int id) async {
    final db = await database;

    return await db.delete(tableUser, where: "${UserFields.columnId} = ?", whereArgs: [id]);
  }

  Future<int> deleteAchievement(int id) async {
    final db = await database;

    return await db.delete(tableAchievements,
        where: "${AchievementsFields.columnAchievementsId} = ?", whereArgs: [id]);
  }

  Future<int> deleteUserHasAchievement(
      User user, Achievement achievement) async {
    final db = await database;
    return await db.delete(tableUserHasAchievements,
        where: "${UserHasAchievementsFields.columnUserId} = ? and ${UserHasAchievementsFields.columnAchievementId} = ? ",
        whereArgs: [user.id, achievement.id]);
  }

  Future<int> deleteGame(int id) async {
    final db = await database;

    return await db
        .delete(tableGames, where: "${GamesFields.columnGamesId} = ?", whereArgs: [id]);
  }

  Future<int> deleteHighscore(int id) async {
    final db = await database;

    return await db
        .delete(tableHighscore, where: "${HighscoresFields.columnId} = ?", whereArgs: [id]);
  }

  Future<int> deleteSubject(int id) async {
    final db = await database;

    return await db
        .delete(tableSubjects, where: "${SubjectsFields.columnSubjectsId} = ?", whereArgs: [id]);
  }

  Future<int> deleteUserSolvedTaskAmount(User user, Subject subject) async {
    final db = await database;

    return await db.delete(tableUserSolvedTaskAmount,
        where: "${UserSolvedTaskAmountFields.columnSubjectId} = ? and ${UserSolvedTaskAmountFields.columnUserId} = ?",
        whereArgs: [subject.id, user.id]);
  }

  Future<int> deleteTaskUrl(int id) async {
    final db = await database;

    return await db
        .delete(tableTaskUrl, where: "${TaskUrlFields.columnId} = ?", whereArgs: [id]);
  }

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

  Future<User> updateUserIsAdmin(User user, bool isAdmin) async {
    final db = await database;

    int updated = await db.update(tableUser,
        <String, dynamic>{UserFields.columnIsAdmin: isAdmin ? 1 : 0},
        where: " ${UserFields.columnId} = ?", whereArgs: [user.id]);

    if (updated != null) {
      return await _getUser(user.id);
    }
    return null;
  }

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

  Future<int> updateAchievement(Achievement achievement) async {
    final db = await database;

    return await db.update(tableAchievements, achievement.toMap(),
        where: " ${AchievementsFields.columnAchievementsId} = ?", whereArgs: [achievement.id]);
  }

  Future<int> updateGame(Game game) async {
    final db = await database;

    return await db.update(tableGames, game.toMap(),
        where: "${GamesFields.columnGamesId} = ?", whereArgs: [game.id]);
  }

  Future<int> updateHighscore(Highscore highscore) async {
    final db = await database;

    return await db.update(tableHighscore, highscore.toMap(),
        where: "${HighscoresFields.columnId} = ?", whereArgs: [highscore.id]);
  }

  Future<int> updateSubject(Subject subject) async {
    final db = await database;

    return await db.update(tableSubjects, subject.toMap(),
        where: "${SubjectsFields.columnSubjectsId}  = ?", whereArgs: [subject.id]);
  }

  Future<int> updateUserSolvedTaskAmount(
      User user, Subject subject, int amount) async {
    final db = await database;
    UserSolvedTaskAmount userSolvedTaskAmount = UserSolvedTaskAmount(
        userId: user.id, subjectId: subject.id, amount: amount);

    return await db.update(
        tableUserSolvedTaskAmount, userSolvedTaskAmount.toMap(),
        where: "${UserSolvedTaskAmountFields.columnSubjectId}  = ? and ${UserSolvedTaskAmountFields.columnUserId} = ?",
        whereArgs: [subject.id, user.id]);
  }

  Future<int> updateTaskUrl(TaskUrl taskUrl) async {
    final db = await database;

    return await db.update(tableTaskUrl, taskUrl.toMap(),
        where: " ${TaskUrlFields.columnId} = ?", whereArgs: [taskUrl.id]);
  }

  Future<int> checkPassword(String password, User user) async {
    Password pswd = await _getPassword(user);
    return (password.compareTo(pswd.password) == 0 ? 1 : 0);
  }

  Future<int> updatePassword(String newPassword, User user) async {
    final db = await database;
    Password password = Password(password: newPassword);
    return await db.update(tableUser, password.toMap(),
        where: "${UserFields.columnId} = ?", whereArgs: [user.id]);
  }

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

  Future<int> insertLeftToSolve(String taskString, int leftToSolve, User user) async {
    final db = await database;
    LeftToSolve lts =
    LeftToSolve(taskString: taskString, leftToSolve: leftToSolve, userLTSId: user.id, doesStillExist: 0);
    return await db.insert(tableLeftToSolve, lts.toMap());
  }

  Future<int> getLeftToSolve(String taskString, User user) async {
    final db = await database;
    print("looking up task with: " + taskString);
    var leftToSolve = await db.query(tableLeftToSolve,
        columns: [LeftToSolveFields.columnLeftToSolve],
        where: "${LeftToSolveFields.columnTaskString} = ? and ${LeftToSolveFields
            .columnUserLTSId} = ?",
        whereArgs: [taskString, user.id]);
    if (leftToSolve.length > 0) return leftToSolve.first[LeftToSolveFields.columnLeftToSolve];
    return Future.value(-3);
  }

  Future<void> removeUnusedLeftToSolveEntries(List<Task> loadedTasks, User user) async {
    final db = await database;
    db.delete(tableLeftToSolve,
        where: "${LeftToSolveFields.columnUserLTSId} = ?", whereArgs: [user.id]);
    loadedTasks.forEach((task) {
      insertLeftToSolve(task.toString(), task.leftToSolve, user);
    });
  }

  Future<int> decrementLeftToSolve(Task t, User user) async {
    final db = await database;
    print("curVal: " + t.leftToSolve.toString());
    int newVal = max(t.leftToSolve - 1, -2);
    print("setting to: " + newVal.toString());
    return await db.update(tableLeftToSolve, <String, dynamic>{LeftToSolveFields.columnLeftToSolve: newVal},
        where: "${LeftToSolveFields.columnTaskString} = ? and ${LeftToSolveFields.columnUserLTSId} = ?",
        whereArgs: [t.toString(), user.id]);
  }

  Future<int> setDoesStillExist(Task t) async {
    final db = await database;
    print("Set flag for " + t.toString());
    return await db.update(tableLeftToSolve, <String, dynamic>{LeftToSolveFields.columnDoesStillExist: 1},
        where: "${LeftToSolveFields.columnTaskString} = ?", whereArgs: [t.toString()]);
  }

  Future<int> removeAllNonExistent() async {
    final db = await database;
    int val = 0;
    return await db.delete(tableLeftToSolve,
        where: "${LeftToSolveFields.columnDoesStillExist} = ?", whereArgs: [val]);
  }

  Future<int> resetAllStillExistFlags() async {
    final db = await database;
    return await db.update(tableLeftToSolve, <String, dynamic>{LeftToSolveFields.columnDoesStillExist: 0});
  }
}
