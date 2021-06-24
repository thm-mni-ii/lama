import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/event/choose_taskset_events.dart';
import 'package:lama_app/app/repository/taskset_repository.dart';
import 'package:lama_app/app/state/choose_taskset_state.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';

class ChooseTasksetBloc extends Bloc<ChooseTasksetEvent, ChooseTasksetState> {
  TasksetRepository repository;

  ChooseTasksetBloc(this.repository) : super(LoadingAllTasksetsState());

  @override
  Stream<ChooseTasksetState> mapEventToState(ChooseTasksetEvent event) async* {
    if (event is LoadAllTasksetsEvent) {
      yield LoadingAllTasksetsState();
      List<Taskset> tasksets =
          repository.getTasksetsForSubjectAndGrade(event.subject, event.grade);
      //TODO: Maybe remove this? it serves no real purpose but it makes it look more professional
      await Future.delayed(Duration(milliseconds: 500));
      //
      yield LoadedAllTasksetsState(tasksets);
    }
  }
}
