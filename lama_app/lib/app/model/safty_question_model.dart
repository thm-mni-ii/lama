//set table name
final String tableSaftyQuestion = "saftyquestion";

///Set the column names
///
/// Author: Lars Kammerer
class SaftyQuestionFields {
  static final String columnSaftyQuestionId = "id";
  static final String columnSaftyQuestionAdminId = "adminID";
  static final String columnSaftyQuestion = "question";
  static final String columnSaftyAnswer = "answer";
}

///This class help to work with the data's from the saftyquestion table
///
/// Author: Lars Kammerer
class SaftyQuestion {
  int id;
  int adminID;
  String question;
  String answer;

  SaftyQuestion({this.id, this.adminID, this.question, this.answer});

  ///Map the variables
  ///
  ///{@return} Map<String, dynamic>
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      SaftyQuestionFields.columnSaftyQuestionAdminId: adminID,
      SaftyQuestionFields.columnSaftyQuestion: question,
      SaftyQuestionFields.columnSaftyAnswer: answer,
    };
    return map;
  }

  ///get the data from the map
  ///
  ///{@param} Map<String, dynamic> map
  SaftyQuestion.fromMap(Map<String, dynamic> map) {
    id = map[SaftyQuestionFields.columnSaftyQuestionId];
    adminID = map[SaftyQuestionFields.columnSaftyQuestionAdminId];
    question = map[SaftyQuestionFields.columnSaftyQuestion];
    answer = map[SaftyQuestionFields.columnSaftyAnswer];
  }
}
