/// States used by [SaftyQuestionScreen] and [SaftyQuestionBloc]
///
/// Author: L.Kammerer
/// latest Changes: 10.09.2021

abstract class SaftyQuestionState {}

class SaftyQuestionContent extends SaftyQuestionState {
  String question;
  String answer;
  SaftyQuestionContent(this.question, this.answer);
}
