import 'package:flutter_test/flutter_test.dart';
import 'package:lama_app/app/model/achievement_model.dart';
import 'package:lama_app/app/model/game_model.dart';
import 'package:lama_app/app/model/highscore_model.dart';
import 'package:lama_app/app/model/subject_model.dart';
import 'package:lama_app/app/model/taskUrl_model.dart';
import 'package:lama_app/app/model/userHasAchievement_model.dart';
import 'package:lama_app/app/model/userSolvedTaskAmount_model.dart';
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
    isAdmin: false,
    avatar: "Vogel"
  );

  User user1 = User();

  Achievement achievement =Achievement(
      name: "Hast du toll gemacht!"
  );
  Achievement achievement1 = Achievement();

  Game game = Game(
      name: "Snake"
  );
  Game game1 = Game();

  Highscore highscore = Highscore(
      gameID: 5,
      score: 25,
      userID: 10
  );
  Highscore highscore1 = Highscore();

  Subject subject = Subject(
      name: "Aufgabe1"
  );
  Subject subject1 = Subject();

  UserSolvedTaskAmount userSolvedTaskAmount = UserSolvedTaskAmount();

  TaskUrl taskUrl = TaskUrl(
    url: "www.allesklapt.de"
  );
  TaskUrl taskUrl1 = TaskUrl();

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

          await DatabaseProvider.db.insertUser(user);
          expectLater((await DatabaseProvider.db.getUser()).length, 1);

          DatabaseProvider.db.insertUser(user);
          expectLater((await DatabaseProvider.db.getUser()).length, 2);

          DatabaseProvider.db.insertUser(user);
          DatabaseProvider.db.insertUser(user);
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
      group('UpdateTest',(){
        test('Update User', () async{
          await DatabaseProvider.db.insertUser(user);
          var userback = await DatabaseProvider.db.getUser();
          expect(userback.first.name, "Thorsten");
          expect(userback.first.password, null);
          expect(userback.first.grade, 2);
          expect(userback.first.coins, 60);
          expect(userback.first.isAdmin, false);
          expect(userback.first.avatar, "Vogel");

          user1 = userback.first;
          user1.name = "Frank";
          user1.grade = 3;
          user1.coins = 40;
          user1.isAdmin = true;
          user1.avatar = "Bieber";

          await DatabaseProvider.db.updateUser(user1);

          userback = await DatabaseProvider.db.getUser();
          expect(userback.first.name, "Frank");
          expect(userback.first.password, null);
          expect(userback.first.grade, 3);
          expect(userback.first.coins, 40);
          expect(userback.first.isAdmin, true);
          expect(userback.first.avatar, "Bieber");
        });
        test('Update User Name', () async{
          await DatabaseProvider.db.insertUser(user);
          var userback = await DatabaseProvider.db.getUser();
          expect(userback.first.name, "Thorsten");
          expect(userback.first.password, null);
          expect(userback.first.grade, 2);
          expect(userback.first.coins, 60);
          expect(userback.first.isAdmin, false);
          expect(userback.first.avatar, "Vogel");

          user1 = userback.first;

          await DatabaseProvider.db.updateUserName(user, "Timo");

          userback = await DatabaseProvider.db.getUser();
          expect(userback.first.name, "Timo");
          expect(userback.first.password, null);
          expect(userback.first.grade, 2);
          expect(userback.first.coins, 60);
          expect(userback.first.isAdmin, false);
          expect(userback.first.avatar, "Vogel");
        });
        test('Update User Grade', () async{
          await DatabaseProvider.db.insertUser(user);
          var userback = await DatabaseProvider.db.getUser();
          expect(userback.first.name, "Thorsten");
          expect(userback.first.password, null);
          expect(userback.first.grade, 2);
          expect(userback.first.coins, 60);
          expect(userback.first.isAdmin, false);
          expect(userback.first.avatar, "Vogel");

          user1 = userback.first;

          await DatabaseProvider.db.updateUserGrade(user1, 4);

          userback = await DatabaseProvider.db.getUser();
          expect(userback.first.name, "Thorsten");
          expect(userback.first.password, null);
          expect(userback.first.grade, 4);
          expect(userback.first.coins, 60);
          expect(userback.first.isAdmin, false);
          expect(userback.first.avatar, "Vogel");
        });
        test('Update User Coins', () async{
          await DatabaseProvider.db.insertUser(user);
          var userback = await DatabaseProvider.db.getUser();
          expect(userback.first.name, "Thorsten");
          expect(userback.first.password, null);
          expect(userback.first.grade, 2);
          expect(userback.first.coins, 60);
          expect(userback.first.isAdmin, false);
          expect(userback.first.avatar, "Vogel");

          user1 = userback.first;

          await DatabaseProvider.db.updateUserCoins(user1, 30);

          userback = await DatabaseProvider.db.getUser();
          expect(userback.first.name, "Thorsten");
          expect(userback.first.password, null);
          expect(userback.first.grade, 2);
          expect(userback.first.coins, 30);
          expect(userback.first.isAdmin, false);
          expect(userback.first.avatar, "Vogel");
        });
        test('Update User IsAdmin', () async{
          await DatabaseProvider.db.insertUser(user);
          var userback = await DatabaseProvider.db.getUser();
          expect(userback.first.name, "Thorsten");
          expect(userback.first.password, null);
          expect(userback.first.grade, 2);
          expect(userback.first.coins, 60);
          expect(userback.first.isAdmin, false);
          expect(userback.first.avatar, "Vogel");

          user1 = userback.first;

          await DatabaseProvider.db.updateUserIsAdmin(user1, true);

          userback = await DatabaseProvider.db.getUser();
          expect(userback.first.name, "Thorsten");
          expect(userback.first.password, null);
          expect(userback.first.grade, 2);
          expect(userback.first.coins, 60);
          expect(userback.first.isAdmin, true);
          expect(userback.first.avatar, "Vogel");
        });
        test('Update User Avatar', () async{
          await DatabaseProvider.db.insertUser(user);
          var userback = await DatabaseProvider.db.getUser();
          expect(userback.first.name, "Thorsten");
          expect(userback.first.password, null);
          expect(userback.first.grade, 2);
          expect(userback.first.coins, 60);
          expect(userback.first.isAdmin, false);
          expect(userback.first.avatar, "Vogel");

          user1 = userback.first;

          await DatabaseProvider.db.updateUserAvatar(user1, "Wildkatze");

          userback = await DatabaseProvider.db.getUser();
          expect(userback.first.name, "Thorsten");
          expect(userback.first.password, null);
          expect(userback.first.grade, 2);
          expect(userback.first.coins, 60);
          expect(userback.first.isAdmin, false);
          expect(userback.first.avatar, "Wildkatze");
        });
        test('Update Achievement', () async{
          await DatabaseProvider.db.insertAchievement(achievement);
          var achievementsback = await DatabaseProvider.db.getAchievements();
          expect(achievementsback.first.name, "Hast du toll gemacht!");

          achievement = achievementsback.first;
          achievement.name = "Großartig";

          await DatabaseProvider.db.updateAchievement(achievement);

          achievementsback = await DatabaseProvider.db.getAchievements();
          expect(achievementsback.first.name, "Großartig");
        });
        test('Update Game', () async{
          await DatabaseProvider.db.insertGame(game);
          var gamesback = await DatabaseProvider.db.getGames();
          expect(gamesback.first.name, "Snake");

          game = gamesback.first;
          game.name = "Snake2";

          await DatabaseProvider.db.updateGame(game);

          gamesback = await DatabaseProvider.db.getGames();
          expect(gamesback.first.name, "Snake2");
        });
        test('Update Highscore', () async{
          await DatabaseProvider.db.insertHighscore(highscore);
          var highscoresback = await DatabaseProvider.db.getHighscores();
          expect(highscoresback.first.userID, 10);
          expect(highscoresback.first.gameID, 5);
          expect(highscoresback.first.score, 25);

          highscore = highscoresback.first;
          highscore.userID = 12;
          highscore.gameID = 6;
          highscore.score = 110;


          await DatabaseProvider.db.updateHighscore(highscore);

          highscoresback = await DatabaseProvider.db.getHighscores();
          expect(highscoresback.first.userID, 12);
          expect(highscoresback.first.gameID, 6);
          expect(highscoresback.first.score, 110);
        });
        test('Update Subject', () async{
          await DatabaseProvider.db.insertSubject(subject);
          var subjectsback = await DatabaseProvider.db.getSubjects();
          expect(subjectsback.first.name, "Aufgabe1");

          subject = subjectsback.first;
          subject.name = "Aufgabe4";


          await DatabaseProvider.db.updateSubject(subject);

          subjectsback = await DatabaseProvider.db.getSubjects();
          expect(subjectsback.first.name, "Aufgabe4");
        });
        test('Update User solved Task amount', () async{
          user1 = await DatabaseProvider.db.insertUser(user);
          subject1 = await DatabaseProvider.db.insertSubject(subject);
          await DatabaseProvider.db.insertUserSolvedTaskAmount(user1, subject1, 50);
          var userSolvedTaskAmountBack = await DatabaseProvider.db.getUserSolvedTaskAmount();
          expect(userSolvedTaskAmountBack.first.userId, user1.id);
          expect(userSolvedTaskAmountBack.first.subjectId, subject1.id);
          expect(userSolvedTaskAmountBack.first.amount, 50);


          await DatabaseProvider.db.updateUserSolvedTaskAmount(user1, subject1, 100);

          userSolvedTaskAmountBack = await DatabaseProvider.db.getUserSolvedTaskAmount();
          expect(userSolvedTaskAmountBack.first.userId, user1.id);
          expect(userSolvedTaskAmountBack.first.subjectId, subject1.id);
          expect(userSolvedTaskAmountBack.first.amount, 100);
        });
        test('Update TaskUrl', () async{
          await DatabaseProvider.db.insertTaskUrl(taskUrl);
          var taskUrlsBack = await DatabaseProvider.db.getTaskUrl();
          expect(taskUrlsBack.first.url, "www.allesklapt.de");

          taskUrl = taskUrlsBack.first;
          taskUrl.url = "www.neueURL.de";

          await DatabaseProvider.db.updateTaskUrl(taskUrl);

          taskUrlsBack = await DatabaseProvider.db.getTaskUrl();
          expect(taskUrlsBack.first.url, "www.neueURL.de");
        });
      });
      group('Password Test',() {
        test('Check Password', () async {
          await DatabaseProvider.db.insertUser(user);
          expect(await DatabaseProvider.db.checkPassword("456", user), 1);
          expect(await DatabaseProvider.db.checkPassword("Baum", user), 0);
          expect(await DatabaseProvider.db.checkPassword("1gbdzgtf8edujdofh", user), 0);
        });

        test('Check Password', () async {
          await DatabaseProvider.db.insertUser(user);
          await DatabaseProvider.db.updatePassword("Vogel", user);
          expectLater(await DatabaseProvider.db.checkPassword("456", user), 0);
          expectLater(await DatabaseProvider.db.checkPassword("Baum", user), 0);
          expectLater(await DatabaseProvider.db.checkPassword("1gbdzgtf8edujdofh", user), 0);
          expectLater(await DatabaseProvider.db.checkPassword("Vogel", user), 1);
        });
      });
      group('Delete Test',(){
        test('Delete User', () async{
          var userback = await DatabaseProvider.db.getUser();
          expectLater(userback.isEmpty, true);

          user1 = await DatabaseProvider.db.insertUser(user);
          expectLater((await DatabaseProvider.db.getUser()).length, 1);

          await DatabaseProvider.db.deleteUser(user1.id);
          expectLater((await DatabaseProvider.db.getUser()).isEmpty, true);
        });
        test('Delete Achievement', () async{
          var achievementsback = await DatabaseProvider.db.getAchievements();
          expectLater(achievementsback.isEmpty, true);

          achievement1 = await DatabaseProvider.db.insertAchievement(achievement);
          expectLater((await DatabaseProvider.db.getAchievements()).length, 1);

          await DatabaseProvider.db.deleteAchievement(achievement1.id);
          expectLater((await DatabaseProvider.db.getAchievements()).isEmpty, true);
        });
        test('Delete UserHasAchievement', () async{
          user = await DatabaseProvider.db.insertUser(user);
          achievement = await DatabaseProvider.db.insertAchievement(achievement);
          var userHasAchievementsBack = await DatabaseProvider.db.getUserHasAchievements();
          expectLater(userHasAchievementsBack.isEmpty, true);

          await DatabaseProvider.db.insertUserHasAchievement(user, achievement);
          expectLater((await DatabaseProvider.db.getUserHasAchievements()).length, 1);

          await DatabaseProvider.db.deleteUserHasAchievement(user, achievement);
          expectLater((await DatabaseProvider.db.getUserHasAchievements()).isEmpty, true);
        });
        test('Delete Game', () async{
          var gamesBack = await DatabaseProvider.db.getGames();
          expectLater(gamesBack.isEmpty, true);

          game1 =  await DatabaseProvider.db.insertGame(game);
          expectLater((await DatabaseProvider.db.getGames()).length, 1);

          await DatabaseProvider.db.deleteGame(game1.id);
          expectLater((await DatabaseProvider.db.getGames()).isEmpty, true);
        });
        test('Delete Highscore', () async{
          var highscoresBack = await DatabaseProvider.db.getHighscores();
          expectLater(highscoresBack.isEmpty, true);

          highscore1 = await DatabaseProvider.db.insertHighscore(highscore);
          expectLater((await DatabaseProvider.db.getHighscores()).length, 1);

          await DatabaseProvider.db.deleteHighscore(highscore1.id);
          expectLater((await DatabaseProvider.db.getHighscores()).isEmpty, true);
        });
        test('Delete Subject', () async{
          var subjectsBack = await DatabaseProvider.db.getSubjects();
          expectLater(subjectsBack.isEmpty, true);

          subject1 = await DatabaseProvider.db.insertSubject(subject);
          expectLater((await DatabaseProvider.db.getSubjects()).length, 1);

          await DatabaseProvider.db.deleteSubject(subject1.id);
          expectLater((await DatabaseProvider.db.getSubjects()).isEmpty, true);
        });
        test('Delete UserSolvedTaskAmount', () async{
          user = await DatabaseProvider.db.insertUser(user);
          subject = await DatabaseProvider.db.insertSubject(subject);
          var userSolvedTaskAmountBack = await DatabaseProvider.db.getUserSolvedTaskAmount();
          expectLater(userSolvedTaskAmountBack.isEmpty, true);

          await DatabaseProvider.db.insertUserSolvedTaskAmount(user, subject, 50);
          expectLater((await DatabaseProvider.db.getUserSolvedTaskAmount()).length, 1);

          await DatabaseProvider.db.deleteUserSolvedTaskAmount(user, subject);
          expectLater((await DatabaseProvider.db.getUserSolvedTaskAmount()).isEmpty, true);
        });
      });
    });
  });
}