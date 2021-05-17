import '../../db/database_provider.dart';

class Subject {
  int id;
  String name;

  Subject({this.name});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.columnSubjectsName: name,
    };
    return map;
  }

  Subject.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseProvider.columnSubjectsId];
    name = map[DatabaseProvider.columnSubjectsName];
  }
}