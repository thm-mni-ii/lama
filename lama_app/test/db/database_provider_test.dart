import 'package:flutter_test/flutter_test.dart';
import 'package:lama_app/app/model/achievement_model.dart';
import 'package:lama_app/app/model/game_model.dart';
import 'package:lama_app/app/model/highscore_model.dart';
import 'package:lama_app/app/model/subject_model.dart';
import 'package:lama_app/app/model/taskUrl_model.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/db/database_provider.dart';

//@Skip("sqflite cannot run on the machine")
Future<void> main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  User user = User(
    name: "Thorsten",
    password: "456",
    grade: 2,
    coins: 60,
    isAdmin: false
  );

  User user1 = User(
      name: "Fabian",
      password: "123",
      grade: 1,
      coins: 5,
      isAdmin: true
  );

  Achievement achievement =Achievement(
      name: "Hast du toll gemacht!"
  );

  Game game = Game(
      name: "Snake"
  );
  Highscore highscore = Highscore(
      gameID: 5,
      score: 25,
      userID: 10
  );
  Subject subject = Subject(
      name: "Aufgabe1"
  );

  TaskUrl taskUrl = TaskUrl(
    url: "www.allesklapt.de"
  );

  setUp(() async {
    await DatabaseProvider.db.deleteDatabase();
  });

  tearDownAll(() async {
    await DatabaseProvider.db.deleteDatabase();
  });

  group('DatabaseTest', () {
    group('MethodsTest', (){
      group('insertTest',(){
        test('Insert User', () async{
          var userback = await DatabaseProvider.db.getUser();
          expectLater(userback.isEmpty, true);
          print(userback);

          await DatabaseProvider.db.insertUser(user);
          userback = await DatabaseProvider.db.getUser();
          expectLater(userback.length, 1);
          expect(userback.first.name, "Thorsten");
          expect(userback.first.password, null);
          expect(userback.first.grade, 2);
          expect(userback.first.coins, 60);
          expect(userback.first.isAdmin, false);


          DatabaseProvider.db.insertUser(user1);
          expectLater((await DatabaseProvider.db.getUser()).length, 2);

          DatabaseProvider.db.insertUser(user1);
          DatabaseProvider.db.insertUser(user1);
          expectLater((await DatabaseProvider.db.getUser()).length, 4);
      });
        test('Insert Achievement', () async{
          var achievementsback = await DatabaseProvider.db.getAchievements();
          expectLater(achievementsback.isEmpty, true);

          await DatabaseProvider.db.insertAchievement(achievement);
          expectLater((await DatabaseProvider.db.getAchievements()).length, 1);


          DatabaseProvider.db.insertAchievement(achievement);
          expectLater((await DatabaseProvider.db.getAchievements()).length, 2);

          DatabaseProvider.db.insertAchievement(achievement);
          DatabaseProvider.db.insertAchievement(achievement);
          expectLater((await DatabaseProvider.db.getAchievements()).length, 4);
        });
        test('Insert Games', () async{
          var gamesback = await DatabaseProvider.db.getGames();
          expectLater(gamesback.isEmpty, true);

          await DatabaseProvider.db.insertGame(game);
          expectLater((await DatabaseProvider.db.getGames()).length, 1);


          DatabaseProvider.db.insertGame(game);
          expectLater((await DatabaseProvider.db.getGames()).length, 2);

          DatabaseProvider.db.insertGame(game);
          DatabaseProvider.db.insertGame(game);
          expectLater((await DatabaseProvider.db.getGames()).length, 4);
        });
        test('Insert Highscores', () async{
          var highscoresback = await DatabaseProvider.db.getHighscores();
          expectLater(highscoresback.isEmpty, true);

          await DatabaseProvider.db.insertHighscore(highscore);
          expectLater((await DatabaseProvider.db.getHighscores()).length, 1);


          DatabaseProvider.db.insertHighscore(highscore);
          expectLater((await DatabaseProvider.db.getHighscores()).length, 2);

          DatabaseProvider.db.insertHighscore(highscore);
          DatabaseProvider.db.insertHighscore(highscore);
          expectLater((await DatabaseProvider.db.getHighscores()).length, 4);
        });
        test('Insert Subjects', () async{
          var subjectsback = await DatabaseProvider.db.getSubjects();
          expectLater(subjectsback.isEmpty, true);

          await DatabaseProvider.db.insertSubject(subject);
          expectLater((await DatabaseProvider.db.getSubjects()).length, 1);


          DatabaseProvider.db.insertSubject(subject);
          expectLater((await DatabaseProvider.db.getSubjects()).length, 2);

          DatabaseProvider.db.insertSubject(subject);
          DatabaseProvider.db.insertSubject(subject);
          expectLater((await DatabaseProvider.db.getSubjects()).length, 4);
        });
        test('Insert User_has_achievement', () async{
          var userHasAchievementsBack = await DatabaseProvider.db.getUserHasAchievements();
          expectLater(userHasAchievementsBack.isEmpty, true);

          await DatabaseProvider.db.insertUserHasAchievement(user, achievement);
          expectLater((await DatabaseProvider.db.getUserHasAchievements()).length, 1);


          DatabaseProvider.db.insertUserHasAchievement(user, achievement);
          expectLater((await DatabaseProvider.db.getUserHasAchievements()).length, 2);

          DatabaseProvider.db.insertUserHasAchievement(user, achievement);
          DatabaseProvider.db.insertUserHasAchievement(user, achievement);
          expectLater((await DatabaseProvider.db.getUserHasAchievements()).length, 4);
        });
        test('Insert User_has_achievement', () async{
          var userHasAchievementsBack = await DatabaseProvider.db.getUserHasAchievements();
          expectLater(userHasAchievementsBack.isEmpty, true);

          await DatabaseProvider.db.insertUserHasAchievement(user, achievement);
          expectLater((await DatabaseProvider.db.getUserHasAchievements()).length, 1);


          DatabaseProvider.db.insertUserHasAchievement(user, achievement);
          expectLater((await DatabaseProvider.db.getUserHasAchievements()).length, 2);

          DatabaseProvider.db.insertUserHasAchievement(user, achievement);
          DatabaseProvider.db.insertUserHasAchievement(user, achievement);
          expectLater((await DatabaseProvider.db.getUserHasAchievements()).length, 4);
        });
        test('Insert User_solved_task_amount', () async{
          var userSolvedTaskAmountsBack = await DatabaseProvider.db.getUserSolvedTaskAmount();
          expectLater(userSolvedTaskAmountsBack.isEmpty, true);

          await DatabaseProvider.db.insertUserSolvedTaskAmount(user, subject, 5);
          expectLater((await DatabaseProvider.db.getUserSolvedTaskAmount()).length, 1);


          DatabaseProvider.db.insertUserSolvedTaskAmount(user, subject, 60);
          expectLater((await DatabaseProvider.db.getUserSolvedTaskAmount()).length, 2);

          DatabaseProvider.db.insertUserSolvedTaskAmount(user, subject, 80);
          DatabaseProvider.db.insertUserSolvedTaskAmount(user, subject, 50);
          expectLater((await DatabaseProvider.db.getUserSolvedTaskAmount()).length, 4);
        });
        test('Insert TaskUrl', () async{
          var taksUrlsBack = await DatabaseProvider.db.getTaskUrl();
          expectLater(taksUrlsBack.isEmpty, true);

          await DatabaseProvider.db.insertTaskUrl(taskUrl);
          expectLater((await DatabaseProvider.db.getTaskUrl()).length, 1);


          DatabaseProvider.db.insertTaskUrl(taskUrl);
          expectLater((await DatabaseProvider.db.getTaskUrl()).length, 2);

          DatabaseProvider.db.insertTaskUrl(taskUrl);
          DatabaseProvider.db.insertTaskUrl(taskUrl);
          expectLater((await DatabaseProvider.db.getTaskUrl()).length, 4);
        });
      });
    });
  });
}