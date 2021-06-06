import '../../db/database_provider.dart';

class TaskUrl {
  int id;
  String url;

  TaskUrl({this.url});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.columnTaskUrl: url,
    };
    return map;
  }

  TaskUrl.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseProvider.columnId];
    url = map[DatabaseProvider.columnTaskUrl];
  }
}