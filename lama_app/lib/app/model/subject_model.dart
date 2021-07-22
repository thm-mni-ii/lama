//set table name
final String tableSubjects = "subject";

//set column names
class SubjectsFields{
  static final String columnSubjectsId = "id";
  static final String columnSubjectsName = "name";
}

class Subject {
  int id;
  String name;

  Subject({this.name});
  //Map the variables and return the map
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      SubjectsFields.columnSubjectsName: name,
    };
    return map;
  }
  //get the data from an map
  Subject.fromMap(Map<String, dynamic> map) {
    id = map[SubjectsFields.columnSubjectsId];
    name = map[SubjectsFields.columnSubjectsName];
  }
}