import 'package:flutter_bloc/flutter_bloc.dart';

class MarkWordsBloc extends Bloc<AddAnswerToListEvent, MarkWordState> {
  List<String> givenAnswers = [];

  MarkWordsBloc() : super(MarkWordState([]));

  @override
  Stream<MarkWordState> mapEventToState(AddAnswerToListEvent event) async* {
    if(givenAnswers.contains(event.answerToAdd)) {
      givenAnswers.remove(event.answerToAdd);
    } else
    givenAnswers.add(event.answerToAdd);
    yield MarkWordState(givenAnswers);
  }
}

class AddAnswerToListEvent {
  String answerToAdd;
  AddAnswerToListEvent(this.answerToAdd);
}

class MarkWordState {
  List<String> list;
  MarkWordState(this.list);
}
