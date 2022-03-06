// import 'dart:ffi';

import 'package:lama_app/util/pair.dart';

///This class provides methods to validate a [Taskset] and a [Task].
///
///It checks if all mandatory json keys are present and if the have the right type.
///This is used before loading a taskset and also during the addition
///of a url in the admin menu to prevent crashes of the app
///
/// Author: K.Binder, L.Kammerer
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
          if (isValid != null)
            return "Fehler in Aufgabe ${i + 1} \n\n $isValid";
        }
        return null;
      }
      return "Prüfen Sie folgendes: \n\n 'taskset_name' und 'taskset_subject' sind Zeichenketten \n\n 'taskset_grade' ist ein Zahlenwert \n\n tasks besitzt '[' und ']' und ist nicht leer.";
    }
    return "Eines der folgenden Felder konnte nicht gefunden werden: \n\n 'taskset_name',\n 'taskset_subject',\n 'taskset_grade'\n oder\n 'tasks'.";
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

          case "Zerlegung":
            if (json.containsKey("right_answer") &&
                json["right_answer"] is int &&
                json.containsKey("reverse") &&
                json["reverse"] is bool) return null;
            return "Aufgabentyp: Zerlegung";

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

          ///Bild4Cards
          case "Bild4Cards":
            if (json.containsKey("question") &&
                json["question"] is String &&
                json.containsKey("right_answer") &&
                json["right_answer"] is String &&
                json.containsKey("wrong_answers") &&
                json["wrong_answers"] is List &&
                _checkListType<String>(json["wrong_answers"])) return null;
            return "Aufgabentyp: Bild4Cards";
          case "Buchstabieren":
            if (json.containsKey("words") && json["words"] is List) return null;
            return "Aufgabentyp: Buchstabieren";

          case "2Cards":
            if (json.containsKey("question") &&
                json["question"] is String &&
                json.containsKey("right_answer") &&
                json["right_answer"] is String &&
                json.containsKey("wrong_answers") &&
                json["wrong_answers"] is List &&
                _checkListType<String>(json["wrong_answers"])) return null;
            return "Aufgabentyp: 2Cards";

          ///BildCard
          case "BildCard":
            if (json.containsKey("question") &&
                json["question"] is String &&
                json.containsKey("right_answer") &&
                json["right_answer"] is String &&
                json.containsKey("wrong_answers") &&
                json["wrong_answers"] is List &&
                _checkListType<String>(json["wrong_answers"])) return null;
            return "Aufgabentyp: BildCard";

          case "Clock":
            if (json.containsKey("uhr") &&
                json["uhr"] is String &&
                json.containsKey("timer") &&
                json["timer"] is bool) return null;
            return "Aufgabentyp: Clock";

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

          ///MatchRandom
          case "MatchRandom":
            if (json.containsKey("boxLeft") &&
                json["boxLeft"] is String &&
                json.containsKey("boxMiddle") &&
                json["boxMiddle"] is String &&
                json.containsKey("boxRight") &&
                json["boxRight"] is String &&
                json.containsKey("ansLeft") &&
                json["ansLeft"] is List &&
                _checkListType<String>(json["ansLeft"]) &&
                json.containsKey("ansMiddle") &&
                json["ansMiddle"] is List &&
                _checkListType<String>(json["ansRight"]) &&
                json.containsKey("ansRight") &&
                json["ansMiddle"] is List &&
                _checkListType<String>(json["ansRight"])) return null;
            return "Aufgabentyp: MatchRandom";

          ///GridSelect
          case "GridSelect":
            if (json.containsKey("wordsToFind") &&
                json["wordsToFind"] is List &&
                _checkListType<String>(json["wordsToFind"])) return null;
            return "Aufgabentyp: GridSelect";

          ///MoneyTask
          case "MoneyTask":
            if (json.containsKey("difficulty") &&
                json["difficulty"] is int &&
                json['optimum'] is bool) return null;
            return "Aufgabentyp: MoneyTask";

          case "NumberLine":
            if (json.containsKey("steps") &&
                json["steps"] is int &&
                json.containsKey("randomRange") &&
                json["randomRange"] is bool &&
                json.containsKey("ontap") &&
                json["ontap"] is bool &&
                json["range"] is List &&
                _checkListType<int>(json["range"])) return null;
            return "Aufgabentyp: NumberLine";

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
            if (json.containsKey("equation") && json.containsKey("options")) {
              if (json["equation"] is List &&
                  _checkListType<String>(json["equation"]) &&
                  json["options"] is List &&
                  _checkListType<String>(json["options"])) {
                return null;
              } else {
                return "Fehler im Feld 'equation' oder im Feld 'options'";
              }
            } else if (json.containsKey("operand_range")) {
              if (json["operand_range"] is List &&
                  json["operand_range"].length == 2 &&
                  _checkListType<int>(json["operand_range"])) {
                if (json.containsKey("random_allowed_operators") &&
                    !(json["random_allowed_operators"] is List) &&
                    !_checkListType<String>(json["random_allowed_operators"]))
                  return "Aufgabentyp: Equation \n Hinweis: Fehler in Feld 'random_allowed_operators'";
                if (json.containsKey("allow_replacing_operators") &&
                    !(json["allow_replacing_operators"] is bool))
                  return "Aufgabentyp: Equation \n Hinweis: Fehler in Feld 'allow_replacing_operators'";
                if (json.containsKey("fields_to_replace") &&
                    !(json["fields_to_replace"] is int))
                  return "Aufgabentyp: Equation \n Hinweis: Fehler in Feld 'fields_to_replace'";
                if (json.containsKey("operator_amount") &&
                    !(json["operator_amount"] is int))
                  return "Aufgabentyp: Equation \n Hinweis: Fehler in Feld 'operator_amount'";
                return null;
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
