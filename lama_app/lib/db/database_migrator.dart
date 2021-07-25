import 'package:lama_app/app/model/achievement_model.dart';
import 'package:lama_app/app/model/game_model.dart';
import 'package:lama_app/app/model/highscore_model.dart';
import 'package:lama_app/app/model/left_to_solve_model.dart';
import 'package:lama_app/app/model/subject_model.dart';
import 'package:lama_app/app/model/taskUrl_model.dart';
import 'package:lama_app/app/model/userHasAchievement_model.dart';
import 'package:lama_app/app/model/userSolvedTaskAmount_model.dart';
import 'package:lama_app/app/model/user_model.dart';



class DBMigrator{

  static final Map<int, Map> migrations = {
    1: migrationsV1,
  };

  static final Map<int, String> migrationsV1 = {

    1:  "Create TABLE IF NOT EXISTS $tableUser("
        "${UserFields.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,"
        "${UserFields.columnName} TEXT,"
        "${UserFields.columnPassword} TEXT,"
        "${UserFields.columnGrade} INTEGER,"
        "${UserFields.columnCoins} INTEGER,"
        "${UserFields.columnIsAdmin} INTEGER,"
        "${UserFields.columnAvatar} TEXT"
        ");",

    2:   "Create TABLE IF NOT EXISTS $tableAchievements("
        "${AchievementsFields.columnAchievementsId} INTEGER PRIMARY KEY AUTOINCREMENT,"
        "${AchievementsFields.columnAchievementsName} TEXT"
        ");",

    3:    "Create TABLE IF NOT EXISTS $tableUserHasAchievements("
        "${UserHasAchievementsFields.columnUserId} INTEGER,"
        "${UserHasAchievementsFields.columnAchievementId} INTEGER"
        ");",

    4:  "Create TABLE IF NOT EXISTS $tableGames("
        "${GamesFields.columnGamesId} INTEGER PRIMARY KEY AUTOINCREMENT,"
        "${GamesFields.columnGamesName} TEXT"
        ");",

    5:  "Create TABLE IF NOT EXISTS $tableHighscore("
        "${HighscoresFields.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,"
        "${HighscoresFields.columnGameId} INTEGER,"
        "${HighscoresFields.columnScore} INTEGER,"
        "${HighscoresFields.columnUserId} INTEGER"
        ");",


    6:  "Create TABLE IF NOT EXISTS $tableSubjects("
        "${SubjectsFields.columnSubjectsId} INTEGER PRIMARY KEY AUTOINCREMENT,"
        "${SubjectsFields.columnSubjectsName} TEXT"
        ");",

    7:   "Create TABLE IF NOT EXISTS $tableUserSolvedTaskAmount("
        "${UserSolvedTaskAmountFields.columnUserId} INTEGER,"
        "${UserSolvedTaskAmountFields.columnSubjectId} INTEGER,"
        "${UserSolvedTaskAmountFields.columnAmount} INTEGER"
        ");",


    8:  "Create TABLE IF NOT EXISTS $tableTaskUrl("
        "${TaskUrlFields.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,"
        "${TaskUrlFields.columnTaskUrl} TEXT"
        ");",

    9:  "CREATE TABLE $tableLeftToSolve("
        "${LeftToSolveFields.columnLeftToSolveID} INTEGER PRIMARY KEY AUTOINCREMENT,"
        "${LeftToSolveFields.columnTaskString} TEXT,"
        "${LeftToSolveFields.columnLeftToSolve} INTEGER,"
        "${LeftToSolveFields.columnUserLTSId} INTEGER,"
        "${LeftToSolveFields.columnDoesStillExist} INTEGER"
        ");"
  };
  }