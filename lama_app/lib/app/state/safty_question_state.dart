abstract class SaftyQuestionState {}

class SaftyQuestionContent extends SaftyQuestionState {
  String question;
  String answer;
  SaftyQuestionContent(this.question, this.answer);
}
