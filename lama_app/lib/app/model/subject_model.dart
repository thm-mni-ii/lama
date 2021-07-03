import '../../db/database_provider.dart';

final String tableSubjects = "subject";

class SubjectsFields{
  static final String columnSubjectsId = "id";
  static final String columnSubjectsName = "name";
}

class Subject {
  int id;
  String name;

  Subject({this.name});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      SubjectsFields.columnSubjectsName: name,
    };
    return map;
  }

  Subject.fromMap(Map<String, dynamic> map) {
    id = map[SubjectsFields.columnSubjectsId];
    name = map[SubjectsFields.columnSubjectsName];
  }
}