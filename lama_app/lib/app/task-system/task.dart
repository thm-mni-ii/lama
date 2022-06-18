import 'package:lama_app/util/pair.dart';

///This file contains the Basic Task class with its factory Method and all Task subtypes.
///To create a new TaskType create a class that extends Task and add it to the factory method in [Task].
///
///Note that the toString MUST be overriden by the subclass with all its task specific variables for the "left_to_solve" feature to work.
///(Have a look at an existing subclass for an example)
///
///This should be changed in the future since this is not enforced by the compiler at the moment.
///
///Author: K.Binder
///
enum TaskType {
  fourCards,
  clozeTest,
  zerlegung,
  clock,
  moneyTask,
  markWords,
  numberLine,
  matchCategory,
  gridSelect,
  vocableTest,
  connect,
  equation,
  buchstabieren
}

class Task {
// TODO jetzt muss string zu TaskType machen
  ///factory constructor that creates the corresponding
  ///subclass of [Task] based on the [taskType].
  factory Task.fromJson(Map<String, dynamic> json) {
    String taskType = json['task_type'];
    switch (taskType) {
      case "TaskType.fourCards":
        print(taskType);
        return Task4Cards(
          TaskType.fourCards,
          json['task_reward'],
          json['lama_text'],
          json['left_to_solve'],
          json['question'],
          json['right_answer'],
          List<String>.from(json['wrong_answers']),
        );
      case "TaskType.clozeTest":
        return TaskClozeTest(
          TaskType.clozeTest,
          json['task_reward'],
          json['lama_text'],
          json['left_to_solve'],
          json['question'],
          json['right_answer'],
          List<String>.from(json['wrong_answers']),
        );
      case "TaskType.zerlegung":
        return TaskZerlegung(
          TaskType.zerlegung,
          json['task_reward'],
          json['lama_text'],
          json['left_to_solve'],
          json['reverse'],
          json['zeros'],
          json['boolThousands'],
        );
      case "TaskType.clock":
        return ClockTest(
          TaskType.clock,
          json['task_reward'],
          json['lama_text'],
          json['left_to_solve'],
          json['uhr'],
          json['timer'],
          json['right_answer'],
          json['wrong_answers'],
        );
      case "TaskType.moneyTask":
        return TaskMoney(
          TaskType.moneyTask,
          json['task_reward'],
          json['lama_text'],
          json['left_to_solve'],
          json['difficulty'],
          json['optimum'],
        );
      case "TaskType.markWords":
        return TaskMarkWords(
          TaskType.markWords,
          json['task_reward'],
          json['lama_text'],
          json['left_to_solve'],
          json['sentence'],
          List<String>.from(json['right_words']),
        );
      case "TaskType.numberLine":
        return TaskNumberLine(
          TaskType.numberLine,
          json['task_reward'],
          json['lama_text'],
          json['left_to_solve'],
          List<int>.from(json['range']),
          json["randomRange"],
          json['steps'],
          json['ontap'],
        );
      case "TaskType.matchCategory":
        return TaskMatchCategory(
          TaskType.matchCategory,
          json['task_reward'],
          json['lama_text'],
          json['left_to_solve'],
          json['nameCatOne'],
          json['nameCatTwo'],
          List<String>.from(json['categoryOne']),
          List<String>.from(json['categoryTwo']),
        );
      case "TaskType.gridSelect":
        return TaskGridSelect(
          TaskType.gridSelect,
          json['task_reward'],
          json['lama_text'],
          json['left_to_solve'],
          List<String>.from(json['wordsToFind']),
        );
      case "TaskType.vocableTest":
        var wordPairs = json['wordPairs'] as List;
        List<Pair<String, String>> wordPairList =
            wordPairs.map((pair) => Pair.fromJson(pair)).toList();
        return TaskVocableTest(
          TaskType.vocableTest,
          json['task_reward'],
          json['lama_text'],
          json['left_to_solve'],
          wordPairList,
          json['randomizeSide'],
        );
      case "TaskType.connect":
        return TaskConnect(
          TaskType.connect,
          json['task_reward'],
          json['lama_text'],
          json['left_to_solve'],
          List<String>.from(json['pair1']),
          List<String>.from(json['pair2']),
          List<String>.from(json['rightAnswers']),
        );
      case "TaskType.equation":
        List<String> equation = [];
        List<String> options = [];
        List<String> randomAllowedOperators = [];
        List<int> resultRange = [];
        bool allowReplacingOperators;
        int fieldsToReplace;
        int operatorAmount;
        if (json['equation'] != null)
          equation = List<String>.from(json['equation']);
        if (json['options'] != null)
          options = List<String>.from(json['options']);
        if (json['random_allowed_operators'] != null)
          randomAllowedOperators =
              List<String>.from(json['random_allowed_operators']);
        else
          randomAllowedOperators = ["+", "-", "*", "/"];
        if (json['operand_range'] != null)
          resultRange = List<int>.from(json['operand_range']);
        json['allow_replacing_operators'] != null
            ? allowReplacingOperators = json['allow_replacing_operators']
            : allowReplacingOperators = false;
        json['fields_to_replace'] != null
            ? fieldsToReplace = json['fields_to_replace']
            : fieldsToReplace = -1;
        json['operator_amount'] != null
            ? operatorAmount =
                (json['operator_amount'] > 2 || json['operator_amount'] < 1)
                    ? null
                    : json['operator_amount']
            : operatorAmount = null;
        return TaskEquation(
          TaskType.equation,
          json['task_reward'],
          json['lama_text'],
          json['left_to_solve'],
          equation,
          options,
          randomAllowedOperators,
          allowReplacingOperators,
          resultRange,
          operatorAmount,
          fieldsToReplace,
        );
      case "TaskType.buchstabieren":
        Map<String, String> woerter = Map<String, String>.from(json['woerter']);
        int firstLetterBig = json['first_Letter_Caps'];
        int correctingModus = json['correcting_Modus'];
        return TaskBuchstabieren(
          TaskType.buchstabieren,
          json['task_reward'],
          json['lama_text'],
          json['left_to_solve'],
          woerter,
          firstLetterBig,
          correctingModus,
        );
      default:
        return null;
    }
  }

  TaskType type;
  int reward;
  String lamaText;
  int originalLeftToSolve;
  int leftToSolve;

  Task(this.type, this.reward, this.lamaText, this.originalLeftToSolve) {
    leftToSolve = originalLeftToSolve;
  }

  @override
  String toString() {
    return type.toString() + reward.toString() + lamaText;
  }
}

///Subclass of [Task] for the Tasktype "4Cards"
///
///Author: K.Binder
class Task4Cards extends Task {
  String question;
  String rightAnswer;
  List<String> wrongAnswers;

  Task4Cards(TaskType taskType, int reward, String lamaText, int leftToSolve,
      this.question, this.rightAnswer, this.wrongAnswers)
      : super(taskType, reward, lamaText, leftToSolve);

  @override
  String toString() {
    String s = super.toString() + question + rightAnswer;
    wrongAnswers.sort();
    for (int i = 0; i < wrongAnswers.length; i++) {
      s += wrongAnswers[i];
    }
    return s;
  }
}

///Subclass of [Task] for the Tasktype "ClozeTest"
///
///Author: T.Rentsch
class TaskClozeTest extends Task {
  String question;
  String rightAnswer;
  List<String> wrongAnswers;

  TaskClozeTest(TaskType taskType, int reward, String lamaText, int leftToSolve,
      this.question, this.rightAnswer, this.wrongAnswers)
      : super(taskType, reward, lamaText, leftToSolve);

  @override
  String toString() {
    String s = super.toString() + question + rightAnswer;
    wrongAnswers.sort();
    for (int i = 0; i < wrongAnswers.length; i++) {
      s += wrongAnswers[i];
    }
    return s;
  }
}

///Subclass of [Task] for the Tasktype "MarkWords"
///
///Author: F.Leonhardt
class TaskMarkWords extends Task {
  List<String> rightWords;
  String sentence;

  TaskMarkWords(TaskType taskType, int reward, String lamaText, int leftToSolve,
      this.sentence, this.rightWords)
      : super(taskType, reward, lamaText, leftToSolve);

  @override
  String toString() {
    String s = super.toString();
    rightWords.sort();
    for (int i = 0; i < rightWords.length; i++) {
      s += rightWords[i];
    }
    s += sentence;
    return s;
  }
}

///Subclass of [Task] for the Tasktype "MatchCategory"
///
///Author: T.Rentsch
class TaskMatchCategory extends Task {
  List<String> categoryOne;
  List<String> categoryTwo;
  String nameCatOne;
  String nameCatTwo;

  TaskMatchCategory(
      TaskType taskType,
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
    categoryOne.sort();
    categoryTwo.sort();
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

///Subclass of [Task] for the Tasktype "GridSelect"
///
///Author: K.Binder
class TaskGridSelect extends Task {
  List<String> wordsToFind;

  TaskGridSelect(TaskType taskType, int reward, String lamaText,
      int leftToSolve, this.wordsToFind)
      : super(taskType, reward, lamaText, leftToSolve);

  @override
  String toString() {
    String s = super.toString();
    wordsToFind.sort();
    for (int i = 0; i < wordsToFind.length; i++) {
      s += wordsToFind[i];
    }
    return s;
  }
}

//Author Handito Bismo
class ClockTest extends Task {
  String uhr;
  bool timer;
  String rightAnswer;
  String wrongAnswers;

  ClockTest(TaskType taskType, int reward, String lamaText, int leftToSolve,
      this.uhr, this.timer, this.rightAnswer, this.wrongAnswers)
      : super(taskType, reward, lamaText, leftToSolve);

  @override
  String toString() {
    String s = super.toString() + uhr;
    return s + timer.toString();
  }
}

///Subclass of [Task] for the Tasktype "MoneyTask"
///
///Author: T.Rentsch
class TaskMoney extends Task {
  int difficulty;
  bool optimum;

  TaskMoney(TaskType taskType, int reward, String lamaText, int leftToSolve,
      this.difficulty, this.optimum)
      : super(taskType, reward, lamaText, leftToSolve);

  @override
  String toString() {
    return super.toString() + difficulty.toString();
  }
}

///Subclass of [Task] for the Tasktype "VocableTest"
///
///Author: K.Binder
class TaskVocableTest extends Task {
  List<Pair<String, String>> vocablePairs;
  bool randomizeSide;

  TaskVocableTest(TaskType taskType, int reward, String lamaText,
      int leftToSolve, this.vocablePairs, this.randomizeSide)
      : super(taskType, reward, lamaText, leftToSolve);

  @override
  String toString() {
    String s = super.toString();
    vocablePairs.sort((a, b) => a.a.compareTo(b.a));
    for (int i = 0; i < vocablePairs.length; i++) {
      s += vocablePairs[i].a + vocablePairs[i].b;
    }
    return s + randomizeSide.toString();
  }
}

///Subclass of [Task] for the Tasktype "Connect"
///
///Author: T.Rentsch
class TaskConnect extends Task {
  List<String> pair1;
  List<String> pair2;
  List<String> rightAnswers;

  TaskConnect(TaskType taskType, int reward, String lamaText, int leftToSolve,
      this.pair1, this.pair2, this.rightAnswers)
      : super(taskType, reward, lamaText, leftToSolve);

  @override
  String toString() {
    String s = super.toString();
    pair1.sort();
    for (int i = 0; i < pair1.length; i++) {
      s += pair1[i];
    }
    pair2.sort();
    for (int i = 0; i < pair2.length; i++) {
      s += pair2[i];
    }
    rightAnswers.sort();
    for (int i = 0; i < rightAnswers.length; i++) {
      s += rightAnswers[i];
    }
    return s;
  }
}

///Subclass of [Task] for the Tasktype "Equation"
///
///Author: F.Leonhardt
class TaskEquation extends Task {
  List<String> equation;
  List<String> options;

  List<String> randomAllowedOperators;
  List<int> operandRange;

  int fieldsToReplace;
  int operatorAmount;

  bool allowReplacingOperators;
  bool isRandom = false;

  TaskEquation(
      TaskType taskType,
      int reward,
      String lamaText,
      int leftToSolve,
      this.equation,
      this.options,
      this.randomAllowedOperators,
      this.allowReplacingOperators,
      this.operandRange,
      this.operatorAmount,
      this.fieldsToReplace)
      : super(taskType, reward, lamaText, leftToSolve) {
    print("meep");
    print(this.randomAllowedOperators);
    print("meep2");
    print(this.operandRange);
    if (this.operandRange.length > 0) isRandom = true;
  }

  @override
  String toString() {
    String s = super.toString();
    if (equation != null)
      for (int i = 0; i < equation.length; i++) s += equation[i];
    if (options != null)
      for (int i = 0; i < options.length; i++) s += options[i];
    if (randomAllowedOperators != null)
      for (int i = 0; i < randomAllowedOperators.length; i++)
        s += randomAllowedOperators[i];
    if (operandRange != null)
      for (int i = 0; i < operandRange.length; i++)
        s += operandRange[i].toString();
    return s;
  }
}

class TaskZerlegung extends Task {
  bool zeros;
  bool boolThousands;
  bool reverse;

  TaskZerlegung(TaskType taskType, int reward, String lamaText, int leftToSolve,
      this.reverse, this.zeros, this.boolThousands)
      : super(taskType, reward, lamaText, leftToSolve);

  // do toString Method

}

///Subclass of [Task] for the Tasktype "NumberLine"
///
///Author: J.Decher
class TaskNumberLine extends Task {
  List<int> range;
  bool randomrange;
  int steps;
  bool ontap;
  TaskNumberLine(TaskType taskType, int reward, String lamaText,
      int leftToSolve, this.range, this.randomrange, this.steps, this.ontap)
      : super(taskType, reward, lamaText, leftToSolve);

  @override
  String toString() {
    String s = super.toString();
    return s;
  }
}

///Author: J.Decher, A.Pusch
class TaskBuchstabieren extends Task {
  Map<String, String> woerter;
  int first_Letter_Caps;
  int correctingModus;

  TaskBuchstabieren(
      TaskType taskType,
      int reward,
      String lamaText,
      int leftToSolve,
      this.woerter,
      this.first_Letter_Caps,
      this.correctingModus)
      : super(taskType, reward, lamaText, leftToSolve);

  @override
  String toString() {
    String s = super.toString();
    return s;
  }
}
