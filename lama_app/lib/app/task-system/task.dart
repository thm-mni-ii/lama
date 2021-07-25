import 'package:lama_app/util/pair.dart';

///This file contains the Basic Task class with its factory Method and all Task subtypes
///To create a new Task subtype create a class that extends Task and add it to the factory method in Task

class Task {
  factory Task.fromJson(Map<String, dynamic> json) {
    String taskType = json['task_type'];
    switch (taskType) {
      case "4Cards":
        return Task4Cards(
            taskType,
            json['task_reward'],
            json['lama_text'],
            json['question'],
            json['right_answer'],
            List<String>.from(json['wrong_answers']));
      case "ClozeTest":
        return TaskClozeTest(
            taskType,
            json['task_reward'],
            json['lama_text'],
            json['question'],
            json['right_answer'],
            List<String>.from(json['wrong_answers']));
      case "MarkWords":
        return TaskMarkWords(
            taskType,
            json['task_reward'],
            json['lama_text'],
            json['question'],
            json['sentence'],
            List<String>.from(json['right_words']));
      case "MatchCategory":
        return TaskMatchCategory(
            taskType,
            json['task_reward'],
            json['lama_text'],
            json['question'],
            json['nameCatOne'],
            json['nameCatTwo'],
            List<String>.from(json['categoryOne']),
            List<String>.from(json['categoryTwo']));
      case "GridSelect":
        return TaskGridSelect(taskType, json['task_reward'], json['lama_text'],
            json['question'], List<String>.from(json['wordsToFind']));
      case "MoneyTask":
        return TaskMoney(taskType, json['task_reward'], json['lama_text'],
            json['question'], json['moneyAmount']);
      case "VocableTest":
        var wordPairs = json['wordPairs'] as List;
        print(wordPairs.runtimeType);
        List<Pair<String, String>> wordPairList =
            wordPairs.map((pair) => Pair.fromJson(pair)).toList();
        return TaskVocableTest(taskType, json['task_reward'], json['lama_text'],
            json['question'], wordPairList, json['randomizeSide']);
      default:
        return null;
    }
  }

  String type;
  int reward;
  String question;
  String lamaText;

  Task(this.type, this.reward, this.question, this.lamaText);
}

class Task4Cards extends Task {
  String rightAnswer;
  List<String> wrongAnswers;

  Task4Cards(String taskType, int reward, String lamaText, String question,
      this.rightAnswer, this.wrongAnswers)
      : super(taskType, reward, question, lamaText);
}

class TaskClozeTest extends Task {
  String rightAnswer;
  List<String> wrongAnswers;

  TaskClozeTest(String taskType, int reward, String lamaText, String question,
      this.rightAnswer, this.wrongAnswers)
      : super(taskType, reward, question, lamaText);
}

class TaskMarkWords extends Task {
  List<String> rightWords;
  String sentence;

  TaskMarkWords(String taskType, int reward, String lamaText, String question,
      this.sentence, this.rightWords)
      : super(taskType, reward, question, lamaText);
}

class TaskMatchCategory extends Task {
  List<String> categoryOne;
  List<String> categoryTwo;
  String nameCatOne;
  String nameCatTwo;

  TaskMatchCategory(
      String taskType,
      int reward,
      String lamaText,
      String question,
      this.nameCatOne,
      this.nameCatTwo,
      this.categoryOne,
      this.categoryTwo)
      : super(taskType, reward, question, lamaText);
}

class TaskGridSelect extends Task {
  List<String> wordsToFind;

  TaskGridSelect(String taskType, int reward, String lamaText, String question,
      this.wordsToFind)
      : super(taskType, reward, question, lamaText);
}

class TaskMoney extends Task {
  double moneyAmount;

  TaskMoney(String taskType, int reward, String lamaText, String question,
      this.moneyAmount)
      : super(taskType, reward, question, lamaText);
}

class TaskVocableTest extends Task {
  List<Pair<String, String>> vocablePairs;
  bool randomizeSide;

  TaskVocableTest(String taskType, int reward, String lamaText, String question,
      this.vocablePairs, this.randomizeSide)
      : super(taskType, reward, question, lamaText);
}
