//set table name
final String tableTaskUrl = "task_url";

//set column names
class TaskUrlFields{
  static final String columnId = "id";
  static final String columnTaskUrl = "url";
}

class TaskUrl {
  int id;
  String url;

  TaskUrl({this.url});
  //Map the variables and return the map
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      TaskUrlFields.columnTaskUrl: url
    };
    return map;
  }
  //get the data from an map
  TaskUrl.fromMap(Map<String, dynamic> map) {
    id = map[TaskUrlFields.columnId];
    url = map[TaskUrlFields.columnTaskUrl];
  }
}