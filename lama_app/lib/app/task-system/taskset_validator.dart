import 'package:lama_app/util/pair.dart';

///This class provides methods to validate a [Taskset] and a [Task].
///
///It checks if all mandatory json keys are present and if the have the right type.
///This is used before loading a taskset and also during the addition
///of a url in the admin menu to prevent crashes of the app
///
///Author: K.Binder
class TasksetValidator {
  ///Checks if the passed json is a valid taskset.
  ///
  ///Use jsonDecode() with the corresponding json-string as argument when calling this method.
  ///
  ///Confirms whether all mandatory json keys are present and if the have the right type.
  static bool isValidTaskset(Map<String, dynamic> json) {
    if (json.containsKey("taskset_name") &&
        json.containsKey("taskset_subject") &&
        json.containsKey("taskset_grade") &&
        json.containsKey("tasks")) {
      if (json["taskset_name"] is String &&
          json["taskset_subject"] is String &&
          json["taskset_grade"] is int &&
          json["tasks"] is List &&
          (json["tasks"] as List).length > 0) {
        if (json.containsKey("taskset_choose_amount") &&
            !(json["taskset_choose_amount"] is int)) return false;
        if (json.containsKey("taskset_randomize_order") &&
            !(json["taskset_randomize_order"] is bool)) return false;
        //VALIDATE TASKS
        var tasksetTasks = json['tasks'] as List;
        for (int i = 0; i < tasksetTasks.length; i++) {
          bool isValid = _isValidTask(tasksetTasks[i]);
          if (!isValid) return false;
        }
        return true;
      }
    }
    return false;
  }

  ///Checks if the passed json is a valid Task.
  ///
  ///Confirms whether all mandatory json keys are present and if
  ///the have the right type for the corresponding TaskType.
  ///
  ///Used internally by [isValidTaskset()]
  static bool _isValidTask(Map<String, dynamic> json) {
    if (json.containsKey("task_type") &&
        json.containsKey("task_reward") &&
        json.containsKey("lama_text") &&
        json.containsKey("left_to_solve")) {
      if (json["task_type"] is String &&
          json["task_reward"] is int &&
          json["lama_text"] is String &&
          json["left_to_solve"] is int) {
        switch (json["task_type"]) {
          case "4Cards":
            if (json.containsKey("question") &&
                json["question"] is String &&
                json.containsKey("right_answer") &&
                json["right_answer"] is String &&
                json.containsKey("wrong_answers") &&
                json["wrong_answers"] is List &&
                _checkListType<String>(json["wrong_answers"])) return true;
            print("4Cards false");
            return false;
          case "ClozeTest":
            if (json.containsKey("question") &&
                json["question"] is String &&
                json.containsKey("right_answer") &&
                json["right_answer"] is String &&
                json.containsKey("wrong_answers") &&
                json["wrong_answers"] is List &&
                _checkListType<String>(json["wrong_answers"])) return true;
            print("Cloze false");
            return false;
          case "MarkWords":
            if (json.containsKey("right_words") &&
                json["right_words"] is List &&
                _checkListType<String>(json["right_words"]) &&
                json.containsKey("sentence") &&
                json["sentence"] is String) return true;
            print("MarkWords false");
            return false;
          case "MatchCategory":
            if (json.containsKey("nameCatOne") &&
                json["nameCatOne"] is String &&
                json.containsKey("nameCatTwo") &&
                json["nameCatTwo"] is String &&
                json.containsKey("categoryOne") &&
                json["categoryOne"] is List &&
                _checkListType<String>(json["categoryOne"]) &&
                json.containsKey("categoryTwo") &&
                json["categoryTwo"] is List &&
                _checkListType<String>(json["categoryTwo"])) return true;
            print("Match false");
            return false;
          case "GridSelect":
            if (json.containsKey("wordsToFind") &&
                json["wordsToFind"] is List &&
                _checkListType<String>(json["wordsToFind"])) return true;
            print("Grid false");
            return false;
          case "MoneyTask":
            if (json.containsKey("moneyAmount") &&
                json["moneyAmount"] is double) return true;
            print("Money false");
            return false;
          case "VocableTest":
            if (json.containsKey("randomizeSide") &&
                json["randomizeSide"] is bool &&
                json.containsKey("wordPairs")) {
              var wordPairs = json['wordPairs'] as List;
              List<Pair<String, String>> wordPairList =
                  wordPairs.map((pair) => Pair.fromJson(pair)).toList();
              for (int i = 0; i < wordPairList.length; i++) {
                if (wordPairList[i].a == null ||
                    !(wordPairList[i].a is String) ||
                    wordPairList[i].b == null ||
                    !(wordPairList[i].b is String)) {
                  print("Voc Pairs false");
                  return false;
                }
              }
              return true;
            }
            print("Voc false");
            return false;
          case "Connect":
            if (json.containsKey("pair1") &&
                json.containsKey("pair2") &&
                json.containsKey("rightAnswers")) {
              if (json["pair1"] is List &&
                  _checkListType<String>(json["pair1"]) &&
                  json["pair2"] is List &&
                  _checkListType<String>(json["pair2"]) &&
                  json["rightAnswers"] is List &&
                  _checkListType<String>(json["rightAnswers"])) {
                return true;
              }
            }
            return false;
          case "Equation":
            if (json.containsKey("equation") && json.containsKey("options")) {
              if (json["equation"] is List &&
                  _checkListType<String>(json["equation"]) &&
                  json["options"] is List &&
                  _checkListType<String>(json["options"])) {
                return true;
              }
            } else if (json.containsKey("random_allowed_operators") &&
                json.containsKey("operand_range")) {
              if (json["random_allowed_operators"] is List &&
                  _checkListType<String>(json["random_allowed_operators"]) &&
                  json["operand_range"] is List &&
                  json["operand_range"].length == 2 &&
                  _checkListType<int>(json["operand_range"])) {
                return true;
              }
            }
            return false;
          default:
            return false;
        }
      }
    }
    return false;
  }

  ///Returns whether all items in a list are of type [T]
  ///
  ///Needed because [jsonDecode()] provides a Map with dynamic values,
  ///which means it COULD contain a list with different types.
  ///
  ///Used internally by [_isValidTask()]
  static bool _checkListType<T>(List list) {
    for (int i = 0; i < list.length; i++) {
      if (!(list[i] is T)) return false;
    }
    return true;
  }
}
