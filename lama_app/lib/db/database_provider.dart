import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lama_app/app/model/achievement_model.dart';
import 'package:lama_app/app/model/game_model.dart';
import 'package:lama_app/app/model/highscore_model.dart';
import 'package:lama_app/app/model/left_to_solve_model.dart';
import 'package:lama_app/app/model/password_model.dart';
import 'package:lama_app/app/model/safty_question_model.dart';
import 'package:lama_app/app/model/taskUrl_model.dart';
import 'package:lama_app/app/model/userHasAchievement_model.dart';
import 'package:lama_app/app/model/subject_model.dart';
import 'package:lama_app/app/model/userSolvedTaskAmount_model.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/db/database_migrator.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

///This file manage the database
///
///In this file the database will be create or update
///All methods to work with the database you will find here
///
/// Author: F.Brecher, L.Kammerer
/// latest Changes: 16.09.2021
class DatabaseProvider {
  int currentVersion = 2;
  int oldVersion = 0;

  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();

  Database _database;

  ///Return the Database
  ///
  /// If the Database doesn't exist or is not on the current version
  /// createDatabase() is called
  ///
  /// {@return} Database
  Future<Database> get database async {
    if (_database != null) {
      if (await _database.getVersion() == currentVersion) {
        return _database;
      }
    }

    _database = await createDatabase();

    return _database;
  }

  ///Create or Update the Database
  ///
  /// open a new database or a database with an old Version.
  ///
  /// if there is no database all migrations will be called and the
  /// code will be execute
  /// if there is an old database, the migrations which have a
  /// newer version will be called and the code will be execute
  ///
  /// {@return} Database
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
        //Map the entry's from migrations new, which are higher then the oldVersion.
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

  ///get all entry's from table User
  ///
  /// {@return} <List<User>>
  Future<List<User>> getUser() async {
    final db = await database;

    var users = await db.query(tableUser, columns: [
      UserFields.columnId,
      UserFields.columnName,
      UserFields.columnGrade,
      UserFields.columnCoins,
      UserFields.columnIsAdmin,
      UserFields.columnAvatar,
      UserFields.columnHighscorePermission
    ]);

    List<User> userList = <User>[];

    users.forEach((currentUser) {
      User user = User.fromMap(currentUser);

      userList.add(user);
    });

    return userList;
  }

  ///get all entry's from table Achievement
  ///
  /// {@return} <List<Achievement>>
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

  ///get all entry's from table UserHasAchievement
  ///
  /// {@return} <List<UserHasAchievement>>
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

  ///get all entry's from table Game
  ///
  /// {@return} <List<Game>>
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

  ///get all entry's from table Highscores
  ///
  /// {@return} <List<Highscores>>
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

  ///get the highscore from an user in a specific game from table highscore
  ///
  /// {@param} User user, int gameID
  ///
  /// {@return} <int>
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

  /// get the highscore from a game from table highscore
  ///
  /// {@param} int gameID
  ///
  /// {@return} <int>
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
  ///get all entry's from table Subject
  ///
  /// {@return} <List<Subject>>
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

  ///get all entry's from table UserSolvedTaskAmount
  ///
  /// {@return} <List<UserSolvedTaskAmount>>
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

  ///get all entry's from table TaskUrl
  ///
  /// {@return} <List<TaskUrl>>
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

  /// insert an new User in the table User
  ///
  /// {@param} User user
  ///
  /// {@return} <User> with the autoincremented id
  Future<User> insertUser(User user) async {
    final db = await database;
    user.id = await db.insert(tableUser, user.toMap());
    return user;
  }

  /// insert an new Achievement in the table Achievement
  ///
  /// {@param} Achievement achievement
  ///
  /// {@return} <Achievement> with the autoincremented id
  Future<Achievement> insertAchievement(Achievement achievement) async {
    final db = await database;
    achievement.id = await db.insert(tableAchievements, achievement.toMap());
    return achievement;
  }

  /// insert an new userId and an achievementId in the table UserHAsAchievement
  ///
  /// {@param} User user, Achievement achievement
  insertUserHasAchievement(User user, Achievement achievement) async {
    final db = await database;
    UserHasAchievement userHasAchievement =
        UserHasAchievement(userID: user.id, achievementID: achievement.id);
    await db.insert(tableUserHasAchievements, userHasAchievement.toMap());
  }

  /// insert an new Game in the table Game
  ///
  /// {@param} Game game
  ///
  /// {@return} <Game> with the autoincremented id
  Future<Game> insertGame(Game game) async {
    final db = await database;
    game.id = await db.insert(tableGames, game.toMap());
    return game;
  }

  /// insert an new Highscore in the table Highscore
  ///
  /// {@param} Highscore highscore
  ///
  /// {@return} <Highscore> with the autoincremented id
  Future<Highscore> insertHighscore(Highscore highscore) async {
    final db = await database;
    highscore.id = await db.insert(tableHighscore, highscore.toMap());
    return highscore;
  }

  /// insert an new Subject in the table Subject
  ///
  /// {@param} Subject subject
  ///
  /// {@return} <Subject> with the autoincremented id
  Future<Subject> insertSubject(Subject subject) async {
    final db = await database;
    subject.id = await db.insert(tableSubjects, subject.toMap());
    return subject;
  }

  /// insert an UserId, a subjectId and an amount in the table UserSolvedTaskAmount
  ///
  /// {@param} User user, Subject subject, int amount
  insertUserSolvedTaskAmount(User user, Subject subject, int amount) async {
    final db = await database;
    UserSolvedTaskAmount userSolvedTaskAmount = UserSolvedTaskAmount(
        userId: user.id, subjectId: subject.id, amount: amount);
    await db.insert(tableUserSolvedTaskAmount, userSolvedTaskAmount.toMap());
  }

  /// insert a new TaskUrl in the table TaskUrl
  ///
  /// {@param} TaskUrl taskUrl
  ///
  /// {@return} <TaskUrl> with the autoincremented id
  Future<TaskUrl> insertTaskUrl(TaskUrl taskUrl) async {
    final db = await database;
    taskUrl.id = await db.insert(tableTaskUrl, taskUrl.toMap());
    return taskUrl;
  }

  /// delete an user in table User
  ///
  /// {@param} int id
  ///
  /// {@return} <int> which shows the number of deleted rows
  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete(tableUser,
        where: "${UserFields.columnId} = ?", whereArgs: [id]);
  }

  /// delete an achievement in table Achievement
  ///
  /// {@param} int id
  ///
  /// {@return} <int> which shows the number of deleted rows
  Future<int> deleteAchievement(int id) async {
    final db = await database;

    return await db.delete(tableAchievements,
        where: "${AchievementsFields.columnAchievementsId} = ?",
        whereArgs: [id]);
  }

  /// delete an entry in table UserHasAchievement
  ///
  /// {@param} User user, Achievement achievement
  ///
  /// {@return} <int> which shows the number of deleted rows
  Future<int> deleteUserHasAchievement(
      User user, Achievement achievement) async {
    final db = await database;
    return await db.delete(tableUserHasAchievements,
        where:
            "${UserHasAchievementsFields.columnUserId} = ? and ${UserHasAchievementsFields.columnAchievementId} = ? ",
        whereArgs: [user.id, achievement.id]);
  }

  /// delete a game in table Game
  ///
  /// {@param} int id
  ///
  /// {@return} <int> which shows the number of deleted rows
  Future<int> deleteGame(int id) async {
    final db = await database;

    return await db.delete(tableGames,
        where: "${GamesFields.columnGamesId} = ?", whereArgs: [id]);
  }

  /// delete a highscore in table Highscore
  ///
  /// {@param} int id
  ///
  /// {@return} <int> which shows the number of deleted rows
  Future<int> deleteHighscore(int id) async {
    final db = await database;

    return await db.delete(tableHighscore,
        where: "${HighscoresFields.columnId} = ?", whereArgs: [id]);
  }

  /// delete an subject in table Subject
  ///
  /// {@param} int id
  ///
  /// {@return} <int> which shows the number of deleted rows
  Future<int> deleteSubject(int id) async {
    final db = await database;

    return await db.delete(tableSubjects,
        where: "${SubjectsFields.columnSubjectsId} = ?", whereArgs: [id]);
  }

  /// delete an entry in table UserSolvedTaskAMount
  ///
  /// {@param} User user, Subject subject
  ///
  /// {@return} <int> which shows the number of deleted rows
  Future<int> deleteUserSolvedTaskAmount(User user, Subject subject) async {
    final db = await database;

    return await db.delete(tableUserSolvedTaskAmount,
        where:
            "${UserSolvedTaskAmountFields.columnSubjectId} = ? and ${UserSolvedTaskAmountFields.columnUserId} = ?",
        whereArgs: [subject.id, user.id]);
  }

  /// delete a taskUrl in table TaskUrl
  ///
  /// {@param} int id
  ///
  /// {@return} <int> which shows the number of deleted rows
  Future<int> deleteTaskUrl(int id) async {
    final db = await database;

    return await db.delete(tableTaskUrl,
        where: "${TaskUrlFields.columnId} = ?", whereArgs: [id]);
  }

  /// update an user in table User
  ///
  /// {@param} User user
  ///
  /// {@return} <User>
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

  /// update the name from an user in table User
  ///
  /// {@param} User user, String name
  ///
  /// {@return} <User>
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

  /// update the grade from an user in table User
  ///
  /// {@param} User user, int grade
  ///
  /// {@return} <User>
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

  /// update the coins from an user in table User
  ///
  /// {@param} User user, int coins
  ///
  /// {@return} <User>
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

  /// update the isAdmin field from an user in table User
  ///
  /// {@param} User user, bool isAdmin
  ///
  /// {@return} <User>
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

  /// update the highscorePermission field from an user in table User
  ///
  /// {@param} User user, bool highscorePermission
  ///
  /// {@return} <User>
  Future<User> updateUserHighscorePermission(
      User user, bool highscorePermission) async {
    final db = await database;

    int updated = await db.update(
        tableUser,
        <String, dynamic>{
          UserFields.columnHighscorePermission: highscorePermission ? 1 : 0
        },
        where: " ${UserFields.columnId} = ?",
        whereArgs: [user.id]);

    if (updated != null) {
      return await _getUser(user.id);
    }
    return null;
  }

  /// update the highscorePermission field for alle users in table User
  ///
  /// {@param} User user, bool highscorePermission
  ///
  /// {@return} <User>
  Future<void> updateAllUserHighscorePermission(List<User> userList) async {
    userList.forEach((user) async {
      await updateUserHighscorePermission(user, user.highscorePermission);
    });
  }

  /// update the avatar from an user in table User
  ///
  /// {@param} User user, String avatar
  ///
  /// {@return} <User>
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

  /// update an achievement in table Achievement
  ///
  /// {@param} Achievement achievement
  ///
  /// {@return} <int> which shows the number of updated rows
  Future<int> updateAchievement(Achievement achievement) async {
    final db = await database;

    return await db.update(tableAchievements, achievement.toMap(),
        where: " ${AchievementsFields.columnAchievementsId} = ?",
        whereArgs: [achievement.id]);
  }

  /// update a game in table Game
  ///
  /// {@param} Game game
  ///
  /// {@return} <int> which shows the number of updated rows
  Future<int> updateGame(Game game) async {
    final db = await database;

    return await db.update(tableGames, game.toMap(),
        where: "${GamesFields.columnGamesId} = ?", whereArgs: [game.id]);
  }

  /// update a highscore in table Highscore
  ///
  /// {@param} Highscore highscore
  ///
  /// {@return} <int> which shows the number of updated rows
  Future<int> updateHighscore(Highscore highscore) async {
    final db = await database;

    return await db.update(tableHighscore, highscore.toMap(),
        where: "${HighscoresFields.columnId} = ?", whereArgs: [highscore.id]);
  }

  /// update a subject in table Subject
  ///
  /// {@param} Subject subject
  ///
  /// {@return} <int> which shows the number of updated rows
  Future<int> updateSubject(Subject subject) async {
    final db = await database;

    return await db.update(tableSubjects, subject.toMap(),
        where: "${SubjectsFields.columnSubjectsId}  = ?",
        whereArgs: [subject.id]);
  }

  /// update an entry in table UserSolvedTaskAmount
  ///
  /// {@param} User user, Subject subject, int amount
  ///
  /// {@return} <int> which shows the number of updated rows
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

  /// update a taskUrl in table TaskUrl
  ///
  /// {@param} TaskUrl taskUrl
  ///
  /// {@return} <int> which shows the number of updated rows
  Future<int> updateTaskUrl(TaskUrl taskUrl) async {
    final db = await database;

    return await db.update(tableTaskUrl, taskUrl.toMap(),
        where: " ${TaskUrlFields.columnId} = ?", whereArgs: [taskUrl.id]);
  }

  /// checks if the transferred password is the password from the user
  ///
  /// {@param} String password, User user
  ///
  /// {@return} <int> true == 1, false == 0
  //check if the transferred password is the password from the user
  Future<int> checkPassword(String password, User user) async {
    Password pswd = await _getPassword(user);
    return (password.compareTo(pswd.password) == 0 ? 1 : 0);
  }

  /// update the password field in table User
  ///
  /// {@param} String newPassword, User user
  ///
  /// {@return} <int> which shows the number of updated rows
  Future<int> updatePassword(String newPassword, User user) async {
    final db = await database;
    Password password = Password(password: newPassword);
    return await db.update(tableUser, password.toMap(),
        where: "${UserFields.columnId} = ?", whereArgs: [user.id]);
  }

  Future<SaftyQuestion> _insertSaftyQuestion(
      SaftyQuestion saftyQuestion) async {
    final db = await database;
    saftyQuestion.id =
        await db.insert(tableSaftyQuestion, saftyQuestion.toMap());
    return saftyQuestion;
  }

  Future<SaftyQuestion> updateSaftyQuestion(SaftyQuestion saftyQuestion) async {
    final db = await database;
    SaftyQuestion allreadyExist = await getSaftyQuestion(saftyQuestion.adminID);
    if (allreadyExist != null) {
      await db.update(tableSaftyQuestion, saftyQuestion.toMap(),
          where: "${SaftyQuestionFields.columnSaftyQuestionAdminId} = ?",
          whereArgs: [saftyQuestion.adminID]);
    } else {
      return _insertSaftyQuestion(saftyQuestion);
    }
    return saftyQuestion;
  }

  Future<SaftyQuestion> getSaftyQuestion(int adminId) async {
    final db = await database;
    var saftyQuestionMap = await db.query(tableSaftyQuestion,
        columns: [
          SaftyQuestionFields.columnSaftyQuestionId,
          SaftyQuestionFields.columnSaftyQuestionAdminId,
          SaftyQuestionFields.columnSaftyQuestion,
          SaftyQuestionFields.columnSaftyAnswer
        ],
        where: "${SaftyQuestionFields.columnSaftyQuestionAdminId} = ?",
        whereArgs: [adminId]);

    if (saftyQuestionMap.length > 0) {
      return SaftyQuestion.fromMap(saftyQuestionMap.first);
    }
    return null;
  }

  Future<int> deleteSaftyQuestion(int adminId) async {
    final db = await database;
    return await db.delete(tableSaftyQuestion,
        where: "${SaftyQuestionFields.columnSaftyQuestionAdminId} = ?",
        whereArgs: [adminId]);
  }

  ///(private)
  ///get an user from table User
  ///
  /// {@param} int id
  ///
  /// {@return} <User>
  Future<User> _getUser(int id) async {
    final db = await database;

    var users = await db.query(tableUser,
        columns: [
          UserFields.columnId,
          UserFields.columnName,
          UserFields.columnGrade,
          UserFields.columnCoins,
          UserFields.columnIsAdmin,
          UserFields.columnAvatar,
          UserFields.columnHighscorePermission
        ],
        where: "${UserFields.columnId} = ?",
        whereArgs: [id]);

    if (users.length > 0) {
      User user = User.fromMap(users.first);
      return user;
    }
    return null;
  }

  ///(private)
  ///get the password from an user from table User
  ///
  /// {@param} User user
  ///
  /// {@return} <Password>
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

  ///delete all entrys in all databases
  Future deleteDatabase() async {
    final db = await database;
    await db.delete(tableUser);
    await db.delete(tableSaftyQuestion);
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

  /// insert a taskString, a leftToSolve value, an userId and a doesStill Exist Value in the table leftToSolve
  ///
  /// {@param} String taskString, int leftToSolve, User user
  ///
  /// {@return} <int> which represent the id
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

  /// get the leftToSolve value from a task with an specific user
  ///
  /// {@param} String taskString,  User user
  ///
  /// {@return} <int>
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

  /// decrement the leftToSolve value from a task with an specific user
  ///
  /// {@param} Task t,  User user
  ///
  /// {@return} <int> which shows the number of updated rows
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

  /// update the columns doesStillExist to 1 from all entry's where columnTaskString is the transferred task
  ///
  /// {@param} Task t
  ///
  /// {@return} <int> which shows the number of updated rows
  Future<int> setDoesStillExist(Task t) async {
    final db = await database;
    print("Set flag for " + t.toString());
    return await db.update(tableLeftToSolve,
        <String, dynamic>{LeftToSolveFields.columnDoesStillExist: 1},
        where: "${LeftToSolveFields.columnTaskString} = ?",
        whereArgs: [t.toString()]);
  }

  /// delete all entry's where the column doesStillExist is 0
  ///
  /// {@return} <int> which shows the number of deleted rows
  Future<int> removeAllNonExistent() async {
    final db = await database;
    int val = 0;
    return await db.delete(tableLeftToSolve,
        where: "${LeftToSolveFields.columnDoesStillExist} = ?",
        whereArgs: [val]);
  }

  /// update all columns doesStillExist to 0
  ///
  /// {@return} <int> which shows the number of updated rows
  Future<int> resetAllStillExistFlags() async {
    final db = await database;
    return await db.update(tableLeftToSolve,
        <String, dynamic>{LeftToSolveFields.columnDoesStillExist: 0});
  }
}
