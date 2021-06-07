import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/event/task_events.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/util/pair.dart';

class VocableTestTaskBloc
    extends Bloc<VocableTestTaskEvent, VocableTestTaskState> {
  final TaskVocableTest task;
  final List<bool> resultList = [];
  int curWordPair = 0;

  VocableTestTaskBloc(this.task) : super(VocableTestTaskInitState());

  @override
  Stream<VocableTestTaskState> mapEventToState(
      VocableTestTaskEvent event) async* {
    if (event is VocableTestTaskGetWordEvent) {
      yield VocableTestTaskTranslationState(
          task.vocablePairs[curWordPair].a, resultList);
    } else if (event is VocableTestTaskAnswerEvent) {
      print(event.answer);
    }
  }
}

class VocableTestTaskEvent {}

class VocableTestTaskGetWordEvent extends VocableTestTaskEvent {}

class VocableTestTaskAnswerEvent extends VocableTestTaskEvent {
  final String answer;
  VocableTestTaskAnswerEvent(this.answer);
}

class VocableTestTaskState {}

class VocableTestTaskInitState extends VocableTestTaskState {}

class VocableTestTaskTranslationState extends VocableTestTaskState {
  List<bool> resultList;
  String wordToTranslate;

  VocableTestTaskTranslationState(this.wordToTranslate, this.resultList);
}
