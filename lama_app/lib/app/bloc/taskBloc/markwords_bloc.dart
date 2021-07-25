import 'package:flutter_bloc/flutter_bloc.dart';

///[Bloc] for the [MarkWordsTaskScreen]
///
/// * see also
///     [MarkWordsTaskScreen]
///     [AddAnswerToListEvent]
///     [MarkWordState]
///
/// Add a String to the answer list
/// if the answer ist already contained in the list, it will be removed
///
/// Author: F.Leonhardt
class MarkWordsBloc extends Bloc<AddAnswerToListEvent, MarkWordState> {
  List<String> givenAnswers = [];

  MarkWordsBloc() : super(MarkWordState([]));

  ///
  @override
  Stream<MarkWordState> mapEventToState(AddAnswerToListEvent event) async* {
    if(givenAnswers.contains(event.answerToAdd)) {
      givenAnswers.remove(event.answerToAdd);
    } else
    givenAnswers.add(event.answerToAdd);
    yield MarkWordState(givenAnswers);
  }
}

/// Event for the [MarkWordsBloc]
///
/// The Event contains a String
///
/// Author: F.Leonhardt
class AddAnswerToListEvent {
  String answerToAdd;
  AddAnswerToListEvent(this.answerToAdd);
}

/// State for the [MarkWordsBloc]
///
/// The State contains a Stringlist
///
/// Author: F.Leonhardt
class MarkWordState {
  List<String> list;
  MarkWordState(this.list);
}
