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
            json['left_to_solve'],
            json['question'],
            json['right_answer'],
            List<String>.from(json['wrong_answers']));
      case "ClozeTest":
        return TaskClozeTest(
            taskType,
            json['task_reward'],
            json['lama_text'],
            json['left_to_solve'],
            json['question'],
            json['right_answer'],
            List<String>.from(json['wrong_answers']));
      case "MarkWords":
        return TaskMarkWords(
            taskType,
            json['task_reward'],
            json['lama_text'],
            json['left_to_solve'],
            json['sentence'],
            List<String>.from(json['right_words']));
      case "MatchCategory":
        return TaskMatchCategory(
            taskType,
            json['task_reward'],
            json['lama_text'],
            json['left_to_solve'],
            json['nameCatOne'],
            json['nameCatTwo'],
            List<String>.from(json['categoryOne']),
            List<String>.from(json['categoryTwo']));
      case "GridSelect":
        return TaskGridSelect(taskType, json['task_reward'], json['lama_text'],
            json['left_to_solve'], List<String>.from(json['wordsToFind']));
      case "MoneyTask":
        return TaskMoney(taskType, json['task_reward'], json['lama_text'],
            json['left_to_solve'], json['moneyAmount']);
      case "VocableTest":
        var wordPairs = json['wordPairs'] as List;
        print(wordPairs.runtimeType);
        List<Pair<String, String>> wordPairList =
            wordPairs.map((pair) => Pair.fromJson(pair)).toList();
        return TaskVocableTest(taskType, json['task_reward'], json['lama_text'],
            json['left_to_solve'], wordPairList, json['randomizeSide']);
      default:
        return null;
    }
  }

  String type;
  int reward;
  String lamaText;
  int leftToSolve;

  Task(this.type, this.reward, this.lamaText, this.leftToSolve);

  @override
  String toString() {
    return type + reward.toString() + lamaText;
  }
}

class Task4Cards extends Task {
  String question;
  String rightAnswer;
  List<String> wrongAnswers;

  Task4Cards(String taskType, int reward, String lamaText, int leftToSolve,
      this.question, this.rightAnswer, this.wrongAnswers)
      : super(taskType, reward, lamaText, leftToSolve);

  @override
  String toString() {
    String s = super.toString() + rightAnswer;
    for (int i = 0; i < wrongAnswers.length; i++) {
      s += wrongAnswers[i];
    }
    return s;
  }
}

class TaskClozeTest extends Task {
  String question;
  String rightAnswer;
  List<String> wrongAnswers;

  TaskClozeTest(String taskType, int reward, String lamaText, int leftToSolve,
      this.question, this.rightAnswer, this.wrongAnswers)
      : super(taskType, reward, lamaText, leftToSolve);

  @override
  String toString() {
    String s = super.toString() + rightAnswer;
    for (int i = 0; i < wrongAnswers.length; i++) {
      s += wrongAnswers[i];
    }
    return s;
  }
}

class TaskMarkWords extends Task {
  List<String> rightWords;
  String sentence;

  TaskMarkWords(String taskType, int reward, String lamaText, int leftToSolve,
      this.sentence, this.rightWords)
      : super(taskType, reward, lamaText, leftToSolve);

  @override
  String toString() {
    String s = super.toString();
    for (int i = 0; i < rightWords.length; i++) {
      s += rightWords[i];
    }
    s += sentence;
    return s;
  }
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
      int leftToSolve,
      this.nameCatOne,
      this.nameCatTwo,
      this.categoryOne,
      this.categoryTwo)
      : super(taskType, reward, lamaText, leftToSolve);

  @override
  String toString() {
    String s = super.toString();
    for (int i = 0; i < categoryOne.length; i++) {
      s += categoryOne[i];
    }
    for (int i = 0; i < categoryTwo.length; i++) {
      s += categoryTwo[i];
    }
    s += nameCatOne;
    s += nameCatTwo;
    return s;
  }
}

class TaskGridSelect extends Task {
  List<String> wordsToFind;

  TaskGridSelect(String taskType, int reward, String lamaText, int leftToSolve,
      this.wordsToFind)
      : super(taskType, reward, lamaText, leftToSolve);

  @override
  String toString() {
    String s = super.toString();
    for (int i = 0; i < wordsToFind.length; i++) {
      s += wordsToFind[i];
    }
    return s;
  }
}

class TaskMoney extends Task {
  double moneyAmount;

  TaskMoney(String taskType, int reward, String lamaText, int leftToSolve,
      this.moneyAmount)
      : super(taskType, reward, lamaText, leftToSolve);

  @override
  String toString() {
    return super.toString() + moneyAmount.toString();
  }
}

class TaskVocableTest extends Task {
  List<Pair<String, String>> vocablePairs;
  bool randomizeSide;

  TaskVocableTest(String taskType, int reward, String lamaText, int leftToSolve,
      this.vocablePairs, this.randomizeSide)
      : super(taskType, reward, lamaText, leftToSolve);

  @override
  String toString() {
    String s = super.toString();
    for (int i = 0; i < vocablePairs.length; i++) {
      s += vocablePairs[i].a + vocablePairs[i].b;
    }
    return s + randomizeSide.toString();
  }
}
