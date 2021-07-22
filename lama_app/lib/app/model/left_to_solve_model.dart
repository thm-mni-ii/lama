//set table name
final String tableLeftToSolve = "left_to_solve";

//set column names
class LeftToSolveFields{
  static const String columnLeftToSolveID = "id";
  static const String columnTaskString = "task_string";
  static const String columnUserLTSId = "user_id";
  static const String columnLeftToSolve = "left_to_solve";
  static const String columnDoesStillExist = "does_still_exist";
}

class LeftToSolve {
  int id;
  String taskString;
  int userLTSId;
  int leftToSolve;
  int doesStillExist;

  LeftToSolve({this.taskString, this.userLTSId, this.leftToSolve, this.doesStillExist});
  //Map the variables and return the map
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      LeftToSolveFields.columnTaskString: taskString,
      LeftToSolveFields.columnUserLTSId: userLTSId,
      LeftToSolveFields.columnLeftToSolve: leftToSolve,
      LeftToSolveFields.columnDoesStillExist: doesStillExist
      };
    return map;
  }
  //get the data from an map
  LeftToSolve.fromMap(Map<String, dynamic> map) {
    id = map[LeftToSolveFields.columnLeftToSolveID];
    taskString = map[LeftToSolveFields.columnTaskString];
    userLTSId = map[LeftToSolveFields.columnUserLTSId];
    leftToSolve = map[LeftToSolveFields.columnLeftToSolve];
    doesStillExist = map[LeftToSolveFields.columnDoesStillExist];
  }
}