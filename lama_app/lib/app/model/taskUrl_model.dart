import '../../db/database_provider.dart';

final String tableTaskUrl = "task_url";

class TaskUrlFields{
  static final String columnId = "id";
  static final String columnTaskUrl = "url";
}

class TaskUrl {
  int id;
  String url;

  TaskUrl({this.url});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      TaskUrlFields.columnTaskUrl: url
    };
    return map;
  }

  TaskUrl.fromMap(Map<String, dynamic> map) {
    id = map[TaskUrlFields.columnId];
    url = map[TaskUrlFields.columnTaskUrl];
  }
}