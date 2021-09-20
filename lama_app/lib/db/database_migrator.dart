import 'package:lama_app/app/model/achievement_model.dart';
import 'package:lama_app/app/model/game_model.dart';
import 'package:lama_app/app/model/highscore_model.dart';
import 'package:lama_app/app/model/left_to_solve_model.dart';
import 'package:lama_app/app/model/safty_question_model.dart';
import 'package:lama_app/app/model/subject_model.dart';
import 'package:lama_app/app/model/taskUrl_model.dart';
import 'package:lama_app/app/model/userHasAchievement_model.dart';
import 'package:lama_app/app/model/userSolvedTaskAmount_model.dart';
import 'package:lama_app/app/model/user_model.dart';

/// This class is a helper to handle the code which create or update tables in the database.
///
///If you want to create a new table or update a table, you have to write a new map migrationVx with the version.
///Add the new map to the migrations map
///

///
/// Author: F.Brecher, L.Kammerer
/// latest Changes: 13.09.2021
class DBMigrator {
  ///map the migrationVx maps
  ///
  /// {@return} Map<int, Map>
  static final Map<int, Map> migrations = {
    1: migrationsV1,
    2: migrationsV2,
    3: migrationsV3,
  };

  ///map the code to create the tables for Version 1
  ///
  /// {@return} Map<int, Map>
  static final Map<int, String> migrationsV1 = {
    1: "Create TABLE IF NOT EXISTS $tableUser("
        "${UserFields.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,"
        "${UserFields.columnName} TEXT,"
        "${UserFields.columnPassword} TEXT,"
        "${UserFields.columnGrade} INTEGER,"
        "${UserFields.columnCoins} INTEGER,"
        "${UserFields.columnIsAdmin} INTEGER,"
        "${UserFields.columnAvatar} TEXT"
        ");",
    2: "Create TABLE IF NOT EXISTS $tableAchievements("
        "${AchievementsFields.columnAchievementsId} INTEGER PRIMARY KEY AUTOINCREMENT,"
        "${AchievementsFields.columnAchievementsName} TEXT"
        ");",
    3: "Create TABLE IF NOT EXISTS $tableUserHasAchievements("
        "${UserHasAchievementsFields.columnUserId} INTEGER,"
        "${UserHasAchievementsFields.columnAchievementId} INTEGER"
        ");",
    4: "Create TABLE IF NOT EXISTS $tableGames("
        "${GamesFields.columnGamesId} INTEGER PRIMARY KEY AUTOINCREMENT,"
        "${GamesFields.columnGamesName} TEXT"
        ");",
    5: "Create TABLE IF NOT EXISTS $tableHighscore("
        "${HighscoresFields.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,"
        "${HighscoresFields.columnGameId} INTEGER,"
        "${HighscoresFields.columnScore} INTEGER,"
        "${HighscoresFields.columnUserId} INTEGER"
        ");",
    6: "Create TABLE IF NOT EXISTS $tableSubjects("
        "${SubjectsFields.columnSubjectsId} INTEGER PRIMARY KEY AUTOINCREMENT,"
        "${SubjectsFields.columnSubjectsName} TEXT"
        ");",
    7: "Create TABLE IF NOT EXISTS $tableUserSolvedTaskAmount("
        "${UserSolvedTaskAmountFields.columnUserId} INTEGER,"
        "${UserSolvedTaskAmountFields.columnSubjectId} INTEGER,"
        "${UserSolvedTaskAmountFields.columnAmount} INTEGER"
        ");",
    8: "Create TABLE IF NOT EXISTS $tableTaskUrl("
        "${TaskUrlFields.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,"
        "${TaskUrlFields.columnTaskUrl} TEXT"
        ");",
    9: "CREATE TABLE IF NOT EXISTS $tableLeftToSolve("
        "${LeftToSolveFields.columnLeftToSolveID} INTEGER PRIMARY KEY AUTOINCREMENT,"
        "${LeftToSolveFields.columnTaskString} TEXT,"
        "${LeftToSolveFields.columnLeftToSolve} INTEGER,"
        "${LeftToSolveFields.columnUserLTSId} INTEGER,"
        "${LeftToSolveFields.columnDoesStillExist} INTEGER"
        ");"
  };

  ///map the code to create the tables for Version 2
  ///
  /// {@return} Map<int, Map>
  static final Map<int, String> migrationsV2 = {
    1: "CREATE TABLE IF NOT EXISTS $tableSaftyQuestion("
        "${SaftyQuestionFields.columnSaftyQuestionId} INTEGER PRIMARY KEY AUTOINCREMENT,"
        "${SaftyQuestionFields.columnSaftyQuestionAdminId} INTEGER,"
        "${SaftyQuestionFields.columnSaftyQuestion} TEXT,"
        "${SaftyQuestionFields.columnSaftyAnswer} TEXT"
        ");",
  };

  ///map the code to create the tables for Version 3
  ///
  /// {@return} Map<int, Map>
  static final Map<int, String> migrationsV3 = {
    1: "ALTER TABLE $tableUser "
        "ADD COLUMN ${UserFields.columnHighscorePermission} INTEGER DEFAULT 0;"
  };
}
