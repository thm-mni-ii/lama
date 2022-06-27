import 'package:flutter/cupertino.dart';
import 'package:lama_app/app/task-system/task.dart';

class KeyGenerator {
  static String generateRandomUniqueKey(List<Task> taskList) {
    UniqueKey key = UniqueKey();
/*     for (var i = 0; i < taskList.length; i++) {
      if (taskList[i].id == key) {
        i = 0;
        key = UniqueKey();
      }
    } */

    while (taskList.map((e) => e.id).any((element) => element == key)) {
      key = UniqueKey();
    }

    return key.toString();
  }
}
