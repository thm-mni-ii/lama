//set table name
final String tableTaskUrl = "task_url";

///Set the column names
///
/// Author: F.Brecher
class TaskUrlFields {
  static final String columnId = "id";
  static final String columnTaskUrl = "url";
}

///This class help to work with the data's from the taskUrl table
///
/// Author: F.Brecher
class TaskUrl {
  int? id;
  String? url;

  TaskUrl({this.url});

  ///Map the variables
  ///
  ///{@return} Map<String, dynamic>
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{TaskUrlFields.columnTaskUrl: url};
    return map;
  }

  ///get the data from the map
  ///
  ///{@param} Map<String, dynamic> map
  TaskUrl.fromMap(Map<dynamic, dynamic> map) {
    id = map[TaskUrlFields.columnId];
    url = map[TaskUrlFields.columnTaskUrl];
  }
}

class TaskUrlList {
  List<TaskUrl>? taskUrlList;
  TaskUrlList(this.taskUrlList);

  TaskUrlList.fromJson(Map<String, dynamic> json) {
    if (json['taskUrlList'] != null) {
      taskUrlList = <TaskUrl>[];
      json['taskUrlList'].forEach((v) {
        taskUrlList!.add(new TaskUrl.fromMap(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.taskUrlList != null) {
      data['taskUrlList'] = this.taskUrlList!.map((e) => e.toMap()).toList();
    }
    return data;
  }
}
