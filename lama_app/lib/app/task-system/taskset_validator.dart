import 'package:lama_app/util/pair.dart';

///This class provides methods to validate a [Taskset] and a [Task].
///
///It checks if all mandatory json keys are present and if the have the right type.
///This is used before loading a taskset and also during the addition
///of a url in the admin menu to prevent crashes of the app
///
/// Author: K.Binder, Lars Kammerer
/// Latest Changes: 14.09.2021
class TasksetValidator {
  ///Checks if the passed json is a valid taskset.
  ///
  ///Use jsonDecode() with the corresponding json-string as argument when calling this method.
  ///
  ///Confirms whether all mandatory json keys are present and if the have the right type.
  static String isValidTaskset(Map<String, dynamic> json) {
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
            !(json["taskset_choose_amount"] is int))
          return "Feld 'taskset_choose_amount' nicht gefunden oder besitzt keinen Zahlenwert!";
        if (json.containsKey("taskset_randomize_order") &&
            !(json["taskset_randomize_order"] is bool))
          return "Feld 'taskset_randomize_order' nicht gefunden oder nicht richtig beschrieben!";
        //VALIDATE TASKS
        var tasksetTasks = json['tasks'] as List;
        for (int i = 0; i < tasksetTasks.length; i++) {
          String isValid = _isValidTask(tasksetTasks[i]);
          if (isValid != null) return "Fehler in Aufgabe ${i + 1} \n $isValid";
        }
        return null;
      }
      return "Prüfen Sie ob folgendes: \n 'taskset_name', 'taskset_subject' sind Zeichenketten \n 'taskset_grade' ist ein Zahlenwert \n tasks besitzt '[' und ']' und ist nicht leer.";
    }
    return "Eines der folgenden Felder konnte nicht gefunden werden: \n 'taskset_name', 'taskset_subject', 'taskset_grade' oder 'tasks'.";
  }

  ///Checks if the passed json is a valid Task.
  ///
  ///Confirms whether all mandatory json keys are present and if
  ///the have the right type for the corresponding TaskType.
  ///
  ///Used internally by [isValidTaskset()]
  static String _isValidTask(Map<String, dynamic> json) {
    if (json.containsKey("task_type") &&
        json.containsKey("task_reward") &&
        json.containsKey("lama_text") &&
        json.containsKey("left_to_solve")) {
      if (json["task_type"] is String &&
          json["task_reward"] is int &&
          json["lama_text"] is String &&
          json["left_to_solve"] is int) {
        switch (json["task_type"]) {

          ///4Cards
          case "4Cards":
            if (json.containsKey("question") &&
                json["question"] is String &&
                json.containsKey("right_answer") &&
                json["right_answer"] is String &&
                json.containsKey("wrong_answers") &&
                json["wrong_answers"] is List &&
                _checkListType<String>(json["wrong_answers"])) return null;
            return "Aufgabentyp: 4Cards";

          ///ClozeTest
          case "ClozeTest":
            if (json.containsKey("question") &&
                json["question"] is String &&
                json.containsKey("right_answer") &&
                json["right_answer"] is String &&
                json.containsKey("wrong_answers") &&
                json["wrong_answers"] is List &&
                _checkListType<String>(json["wrong_answers"])) return null;
            return "Aufgabentyp: ClozeTest";

          ///MarkWords
          case "MarkWords":
            if (json.containsKey("right_words") &&
                json["right_words"] is List &&
                _checkListType<String>(json["right_words"]) &&
                json.containsKey("sentence") &&
                json["sentence"] is String) return null;
            return "Aufgabentyp: MarkWords";

          ///MatchCategory
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
                _checkListType<String>(json["categoryTwo"])) return null;
            return "Aufgabentyp: MatchCategory";

          ///GridSelect
          case "GridSelect":
            if (json.containsKey("wordsToFind") &&
                json["wordsToFind"] is List &&
                _checkListType<String>(json["wordsToFind"])) return null;
            return "Aufgabentyp: GridSelect";

          ///MoneyTask
          case "MoneyTask":
            if (json.containsKey("moneyAmount") &&
                json["moneyAmount"] is double) return null;
            return "Aufgabentyp: MoneyTask";

          ///VocableTest
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
                  return "Aufgabentyp: VocableTest \n Fehler in Feld 'wordPairs' an Stelle ${i + 1}";
                }
              }
              return null;
            }
            return "Aufgabentyp: VocableTest";

          ///Connect
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
                return null;
              }
            }
            return "Aufgabentyp: Connect";

          ///Equation
          case "Equation":
            if (json.containsKey("operator(1-2)")) {
              if (json.containsKey("random")) {
                if (json["random"] is List &&
                    _checkListType<String>(json["random"])) return null;
              } else if (json.containsKey("equation") &&
                  json.containsKey("missing_elements") &&
                  json.containsKey("wrong_answers")) {
                if (json["equation"] is List &&
                    _checkListType<String>(json["equation"]) &&
                    json["missing_elements"] is List &&
                    _checkListType<String>(json["missing_elements"]) &&
                    json["wrong_answers"] is List &&
                    _checkListType<String>(json["wrong_answers"])) return null;
              }
            }
            return "Aufgabentyp: Equation";
          default:
            return "";
        }
      }
    }
    return "";
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
