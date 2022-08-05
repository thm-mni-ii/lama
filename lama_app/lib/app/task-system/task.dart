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
  empty,
  fourCards,
  clozeTest,
  zerlegung,
  clock,
  clockDifferent,
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
  String id;
  TaskType type;
  int reward;
  String lamaText;
  int originalLeftToSolve;
  int? leftToSolve;

  Task(this.id, this.type, this.reward, this.lamaText,
      this.originalLeftToSolve) {
    leftToSolve = originalLeftToSolve;
  }

  ///factory constructor that creates the corresponding
  ///subclass of [Task] based on the [taskType].
  factory Task.fromJson(Map<String, dynamic> json) {
    String taskType = json['task_type'];
    switch (taskType) {
      case "TaskType.fourCards":
        return Task4Cards(
          json['id'],
          TaskType.fourCards,
          json['task_reward'],
          json['lama_text'],
          json['left_to_solve'],
          json['question'],
          json['right_answer'],
          json['question_language'],
          json['answer_language'],
          List<String>.from(json['wrong_answers']),
        );
      case "TaskType.clozeTest":
        return TaskClozeTest(
          json['id'],
          TaskType.clozeTest,
          json['task_reward'],
          json['lama_text'],
          json['left_to_solve'],
          json['question'],
          json['right_answer'],
          json['question_language'],
          json['answer_language'],
          List<String>.from(json['wrong_answers']),
        );
      case "TaskType.zerlegung":
        return TaskZerlegung(
          json['id'],
          TaskType.zerlegung,
          json['task_reward'],
          json['lama_text'],
          json['left_to_solve'],
          json['reverse'],
          json['zeros'],
          json['boolThousands'],
          json['question_language'],
          json['answer_language'],
        );
      case "TaskType.clock":
        return ClockTest(
          json['id'],
          TaskType.clock,
          json['task_reward'],
          json['lama_text'],
          json['left_to_solve'],
          json['uhr'],
          json['timer'],
          json['right_answer'],
          json['wrong_answers'],
          json['question_language'],
          json['answer_language']
        );
      case "TaskType.clockDifferent":
        return ClockDifferent(
          json['id'],
          TaskType.clockDifferent,
          json['task_reward'],
          json['lama_text'],
          json['left_to_solve'], 
          json['uhr'], 
          json['clockMode']
        );
      case "TaskType.moneyTask":
        return TaskMoney(
            json['id'],
            TaskType.moneyTask,
            json['task_reward'],
            json['lama_text'],
            json['left_to_solve'],
            json['difficulty'],
            json['optimum'],
            json['question_language'],
            json['answer_language']
            );
      case "TaskType.markWords":
        return TaskMarkWords(
          json['id'],
          TaskType.markWords,
          json['task_reward'],
          json['lama_text'],
          json['left_to_solve'],
          json['sentence'],
          List<String>.from(json['right_words']),
          json['question_language'],
          json['answer_language']
        );
      case "TaskType.numberLine":
        return TaskNumberLine(
          json['id'],
          TaskType.numberLine,
          json['task_reward'],
          json['lama_text'],
          json['left_to_solve'],
          List<int>.from(json['range']),
          json["randomRange"],
          json['steps'],
          json['ontap'],
          json['question_language'],
          json['answer_language']
        );
      case "TaskType.matchCategory":
        return TaskMatchCategory(
          json['id'],
          TaskType.matchCategory,
          json['task_reward'],
          json['lama_text'],
          json['left_to_solve'],
          json['nameCatOne'],
          json['nameCatTwo'],
          List<String>.from(json['categoryOne']),
          List<String>.from(json['categoryTwo']),
          json['question_language'],
          json['answer_language']
        );
      case "TaskType.gridSelect":
        return TaskGridSelect(
          json['id'],
          TaskType.gridSelect,
          json['task_reward'],
          json['lama_text'],
          json['left_to_solve'],
          List<String>.from(json['wordsToFind']),
          json['question_language'],
          json['answer_language']
        );
      case "TaskType.vocableTest":
        var wordPairs = json['wordPairs'] as List;
        List<Pair<String?, String?>> wordPairList =
            wordPairs.map((pair) => Pair.fromJson(pair)).toList();
        return TaskVocableTest(
          json['id'],
          TaskType.vocableTest,
          json['task_reward'],
          json['lama_text'],
          json['left_to_solve'],
          wordPairList,
          json['randomizeSide'],
          json['question_language'],
          json['answer_language']
        );
      case "TaskType.connect":
        return TaskConnect(
          json['id'],
          TaskType.connect,
          json['task_reward'],
          json['lama_text'],
          json['left_to_solve'],
          List<String>.from(json['pair1']),
          List<String>.from(json['pair2']),
          List<String>.from(json['rightAnswers']),
          json['question_language'],
          json['answer_language']
        );
      case "TaskType.equation":
        List<String> equation = [];
        List<String> options = [];
        List<String> randomAllowedOperators = [];
        List<int> resultRange = [];
        bool? allowReplacingOperators;
        int? fieldsToReplace;
        int? operatorAmount;
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
          json['id'],
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
          json['question_language'],
          json['answer_language']
        );
      case "TaskType.buchstabieren":
        Map<String, String>? woerter;
        if (json['woerter'] != null) {
          woerter = Map<String, String>.from(json['woerter']);
        }
        int? firstLetterBig;
        if (json['first_Letter_caps'] != null) {
          firstLetterBig = json['first_Letter_caps'];
        }

        int? correctingModus;
        if (json['correcting_modus'] != null) {
          correctingModus = json['correcting_modus'];
        }
        int? multiplePoints;
        if (json['multiple_points'] != null) {
          multiplePoints = json['multiple_points'];
        }
        return TaskBuchstabieren(
          json['id'],
          TaskType.buchstabieren,
          json['task_reward'],
          json['lama_text'],
          json['left_to_solve'],
          woerter!,
          firstLetterBig,
          correctingModus,
          multiplePoints,
          json['question_language'],
          json['answer_language']
        );
      default:
        return TaskEmpty('', TaskType.empty, 0, "", 0);
    }
  }

  Map<String, dynamic> toJson() {
    switch (runtimeType) {
      case Task4Cards:
        return (this as Task4Cards).toJson();
      case TaskClozeTest:
        return (this as TaskClozeTest).toJson();
      case TaskMarkWords:
        return (this as TaskMarkWords).toJson();
      case TaskMatchCategory:
        return (this as TaskMatchCategory).toJson();
      case TaskGridSelect:
        return (this as TaskGridSelect).toJson();
      case ClockTest:
        return (this as ClockTest).toJson();
      case TaskMoney:
        return (this as TaskMoney).toJson();
      case TaskVocableTest:
        return (this as TaskVocableTest).toJson();
      case TaskConnect:
        return (this as TaskConnect).toJson();
      case TaskEquation:
        return (this as TaskEquation).toJson();
      case TaskZerlegung:
        return (this as TaskZerlegung).toJson();
      case TaskNumberLine:
        return (this as TaskNumberLine).toJson();
      case TaskZerlegung:
        return (this as TaskZerlegung).toJson();
      default:
        return {};
    }
  }

  @override
  String toString() {
    return type.toString().toString() + reward.toString() + lamaText;
  }
}

///Subclass of [Task] for the Tasktype "4Cards"
///
///Author: K.Binder
class Task4Cards extends Task {
  String? question;
  String? rightAnswer;
  List<String> wrongAnswers;
  String? questionLanguage;
  String? answerLanguage;


  Task4Cards(String id, TaskType taskType, int reward, String lamaText,
      int leftToSolve, this.question, this.rightAnswer, this.questionLanguage, this.answerLanguage, this.wrongAnswers)
      : super(id, taskType, reward, lamaText, leftToSolve);

  Map<String, dynamic> toJson() => {
        "id": id,
        "task_type": type.toString(),
        'task_reward': reward,
        'lama_text': lamaText,
        'left_to_solve': leftToSolve,
        'question': question,
        'right_answer': rightAnswer,
        'wrong_answers': wrongAnswers,
      };

  @override
  String toString() {
    String s = super.toString() + question! + rightAnswer!;
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
  String? question;
  String? rightAnswer;
  List<String> wrongAnswers;
  String? questionLanguage;
  String? answerLanguage;

  TaskClozeTest(String id, TaskType taskType, int reward, String lamaText,
      int leftToSolve, this.question, this.rightAnswer, this.questionLanguage, this.answerLanguage, this.wrongAnswers)
      : super(id, taskType, reward, lamaText, leftToSolve);

  Map<String, dynamic> toJson() => {
        "id": id,
        "task_type": type.toString(),
        'task_reward': reward,
        'lama_text': lamaText,
        'left_to_solve': leftToSolve,
        'question': question,
        'right_answer': rightAnswer,
        'wrong_answers': wrongAnswers,
      };

  @override
  String toString() {
    String s = super.toString() + question! + rightAnswer!;
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
  String? sentence;
  String? questionLanguage;
  String? answerLanguage;

  TaskMarkWords(String id, TaskType taskType, int reward, String lamaText,
      int leftToSolve, this.sentence, this.rightWords, this.questionLanguage, this.answerLanguage)
      : super(id, taskType, reward, lamaText, leftToSolve);

  Map<String, dynamic> toJson() => {
        'id': id,
        "task_type": type.toString(),
        'task_reward': reward,
        'lama_text': lamaText,
        'left_to_solve': leftToSolve,
        'sentence': sentence,
        'right_words': rightWords,
      };

  @override
  String toString() {
    String s = super.toString();
    rightWords.sort();
    for (int i = 0; i < rightWords.length; i++) {
      s += rightWords[i];
    }
    s += sentence!;
    return s;
  }
}

///Subclass of [Task] for the Tasktype "MatchCategory"
///
///Author: T.Rentsch
class TaskMatchCategory extends Task {
  List<String> categoryOne;
  List<String> categoryTwo;
  String? nameCatOne;
  String? nameCatTwo;
  String? questionLanguage;
  String? answerLanguage;

  TaskMatchCategory(
      String id,
      TaskType taskType,
      int reward,
      String lamaText,
      int leftToSolve,
      this.nameCatOne,
      this.nameCatTwo,
      this.categoryOne,
      this.categoryTwo,
      this.questionLanguage,
      this.answerLanguage
      )
      : super(id, taskType, reward, lamaText, leftToSolve);

  Map<String, dynamic> toJson() => {
        'id': id,
        "task_type": type.toString(),
        'task_reward': reward,
        'lama_text': lamaText,
        'left_to_solve': leftToSolve,
        'nameCatOne': nameCatOne,
        'nameCatTwo': nameCatTwo,
        'categoryOne': categoryOne,
        'categoryTwo': categoryTwo,
      };

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
    s += nameCatOne!;
    s += nameCatTwo!;
    return s;
  }
}

///Subclass of [Task] for the Tasktype "GridSelect"
///
///Author: K.Binder
class TaskGridSelect extends Task {
  List<String> wordsToFind;
  String? questionLanguage;
  String? answerLanguage;

  TaskGridSelect(String id, TaskType taskType, int reward, String lamaText,
      int leftToSolve, this.wordsToFind, this.questionLanguage, this.answerLanguage)
      : super(id, taskType, reward, lamaText, leftToSolve);

  Map<String, dynamic> toJson() => {
        'id': id,
        "task_type": type.toString(),
        'task_reward': reward,
        'lama_text': lamaText,
        'left_to_solve': leftToSolve,
        'wordsToFind': wordsToFind,
      };

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
//Task for Clock Different
class ClockDifferent extends Task {
  String? uhr;
  String? clockMode;

  ClockDifferent(String id, TaskType taskType, int reward, String lamaText,
      int leftToSolve, this.uhr, this.clockMode)
      : super(id, taskType, reward, lamaText, leftToSolve);

  @override
  String toString() {
    String s = super.toString() + uhr!;
    return s;
  }
}

//Author Handito Bismo
class ClockTest extends Task {
  String? uhr;
  bool? timer;
  String? rightAnswer;
  String? wrongAnswers;
  String? questionLanguage;
  String? answerLanguage;

  ClockTest(
      String id,
      TaskType taskType,
      int reward,
      String lamaText,
      int leftToSolve,
      this.uhr,
      this.timer,
      this.rightAnswer,
      this.wrongAnswers,
      this.questionLanguage, 
      this.answerLanguage)
      : super(id, taskType, reward, lamaText, leftToSolve);

  Map<String, dynamic> toJson() => {
        'id': id,
        "task_type": type.toString(),
        'task_reward': reward,
        'lama_text': lamaText,
        'left_to_solve': leftToSolve,
        'uhr': uhr,
        'timer': timer,
      };

  @override
  String toString() =>
      super.toString() + (uhr ?? "Uhr is null") + timer.toString();
}

///Subclass of [Task] for the Tasktype "MoneyTask"
///
///Author: T.Rentsch
class TaskMoney extends Task {
  int? difficulty;
  bool? optimum;
  String? questionLanguage;
  String? answerLanguage;

  TaskMoney(String id, TaskType taskType, int reward, String lamaText,
      int leftToSolve, this.difficulty, this.optimum, this.questionLanguage, this.answerLanguage)
      : super(id, taskType, reward, lamaText, leftToSolve);

  Map<String, dynamic> toJson() => {
        "id": id,
        "task_type": type.toString(),
        "task_reward": reward,
        "lama_text": lamaText,
        "left_to_solve": leftToSolve,
        "difficulty": difficulty,
        "optimum": optimum,
      };

  @override
  String toString() => super.toString() + difficulty.toString();
}

///Subclass of [Task] for the Tasktype "VocableTest"
///
///Author: K.Binder
class TaskVocableTest extends Task {
  List<Pair<String?, String?>> vocablePairs;
  bool? randomizeSide;
  String answerLanguage;
  String questionLanguage;

  TaskVocableTest(String id, TaskType taskType, int reward, String lamaText,
      int leftToSolve, this.vocablePairs, this.randomizeSide, this.questionLanguage, this.answerLanguage)
      : super(id, taskType, reward, lamaText, leftToSolve);

  Map<String, dynamic> toJson() => {
        'id': id,
        "task_type": type.toString(),
        'task_reward': reward,
        'lama_text': lamaText,
        'left_to_solve': leftToSolve,
        'vocable_pairs': vocablePairs,
        'randomize_side': randomizeSide,
      };

  @override
  String toString() {
    String s = super.toString();
    vocablePairs.sort((a, b) => a.a!.compareTo(b.a!));
    for (int i = 0; i < vocablePairs.length; i++) {
      s += vocablePairs[i].a! + vocablePairs[i].b!;
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
  String? questionLanguage;
  String? answerLanguage;

  TaskConnect(String id, TaskType taskType, int reward, String lamaText,
      int leftToSolve, this.pair1, this.pair2, this.rightAnswers, this.questionLanguage, this.answerLanguage)
      : super(id, taskType, reward, lamaText, leftToSolve);

  Map<String, dynamic> toJson() => {
        'id': id,
        "task_type": type.toString(),
        'task_reward': reward,
        'lama_text': lamaText,
        'left_to_solve': leftToSolve,
        'pair1': pair1,
        'pair2': pair2,
        'right_answers': rightAnswers,
      };

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

  int? fieldsToReplace;
  int? operatorAmount;

  bool? allowReplacingOperators;
  bool isRandom = false;

  String? questionLanguage;
  String? answerLanguage;

  TaskEquation(
      String id,
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
      this.fieldsToReplace,
      this.questionLanguage,
      this.answerLanguage)
      : super(id, taskType, reward, lamaText, leftToSolve) {
    print("meep");
    print(this.randomAllowedOperators);
    print("meep2");
    print(this.operandRange);
    if (this.operandRange.length > 0) isRandom = true;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        "task_type": type.toString(),
        'task_reward': reward,
        'lama_text': lamaText,
        'left_to_solve': leftToSolve,
        'equation': equation,
        'options': options,
        'random_allowed_operators': randomAllowedOperators,
        'operand_range': operandRange,
        'fields_to_replace': fieldsToReplace,
        'operator_amount': operatorAmount,
        'allow_replacing_operators': allowReplacingOperators,
        'is_random': isRandom,
      };

  @override
  String toString() {
    String s = super.toString();
    for (int i = 0; i < equation.length; i++) s += equation[i];
    for (int i = 0; i < options.length; i++) s += options[i];
    for (int i = 0; i < randomAllowedOperators.length; i++)
      s += randomAllowedOperators[i];
    for (int i = 0; i < operandRange.length; i++)
      s += operandRange[i].toString();
    return s;
  }
}

class TaskZerlegung extends Task {
  bool? zeros;
  bool? boolThousands;
  bool? reverse;
  String? questionLanguage;
  String? answerLanguage;

  TaskZerlegung(String id, TaskType taskType, int reward, String lamaText,
      int leftToSolve, this.reverse, this.zeros, this.boolThousands, this.questionLanguage, this.answerLanguage)
      : super(id, taskType, reward, lamaText, leftToSolve);

  Map<String, dynamic> toJson() => {
        'id': id,
        "task_type": type.toString(),
        'task_reward': reward,
        'lama_text': lamaText,
        'left_to_solve': leftToSolve,
        'reverse': reverse,
        'zeros': zeros,
        'boolThousands': boolThousands,
      };

  // do toString Method

}

///Subclass of [Task] for the Tasktype "NumberLine"
///
///Author: J.Decher
class TaskNumberLine extends Task {
  List<int> range;
  bool? randomrange;
  int? steps;
  bool? ontap;
  String? questionLanguage;
  String? answerLanguage;
  TaskNumberLine(String id, TaskType taskType, int reward, String lamaText,
      int leftToSolve, this.range, this.randomrange, this.steps, this.ontap, this.questionLanguage, this.answerLanguage)
      : super(id, taskType, reward, lamaText, leftToSolve);

  Map<String, dynamic> toJson() => {
        'id': id,
        "task_type": type.toString(),
        'task_reward': reward,
        'lama_text': lamaText,
        'left_to_solve': leftToSolve,
        'range': range,
        'randomRange': randomrange,
        'steps': steps,
        'ontap': ontap,
      };

  @override
  String toString() => super.toString();
}

///Author: J.Decher, A.Pusch
class TaskBuchstabieren extends Task {
  Map<String, String> woerter;
  int? first_Letter_Caps;
  int? correctingModus;
  int? multiplePoints;
  String? questionLanguage;
  String? answerLanguage;

  TaskBuchstabieren(
      String id,
      TaskType taskType,
      int reward,
      String lamaText,
      int leftToSolve,
      this.woerter,
      this.first_Letter_Caps,
      this.correctingModus,
      this.multiplePoints,
      this.questionLanguage,
      this.answerLanguage)
      : super(id, taskType, reward, lamaText, leftToSolve);

  @override
  String toString() => super.toString();
}

class TaskEmpty extends Task {
  TaskEmpty(
    String id,
    TaskType taskType,
    int reward,
    String lamaText,
    int leftToSolve,
  ) : super(id, taskType, reward, lamaText, leftToSolve);

  @override
  String toString() => super.toString();
}
