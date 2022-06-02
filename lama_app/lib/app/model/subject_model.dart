//set table name
final String tableSubjects = "subject";

///Set the column names
///
/// Author: F.Brecher
class SubjectsFields{
  static final String columnSubjectsId = "id";
  static final String columnSubjectsName = "name";
}

///This class help to work with the data's from the subject table
///
/// Author: F.Brecher
class Subject {
  int id;
  String name;

  Subject({this.name});

  ///Map the variables
  ///
  ///{@return} Map<String, dynamic>
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      SubjectsFields.columnSubjectsName: name,
    };
    return map;
  }

  ///get the data from the map
  ///
  ///{@param} Map<String, dynamic> map
  Subject.fromMap(Map<String, dynamic> map) {
    id = map[SubjectsFields.columnSubjectsId];
    name = map[SubjectsFields.columnSubjectsName];
  }
}