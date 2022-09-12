import 'package:bloc/bloc.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:meta/meta.dart';

part 'taskset_create_tasklist_event.dart';
part 'taskset_create_tasklist_state.dart';

class TasksetCreateTasklistBloc
    extends Bloc<TasksetCreateTasklistEvent, TasksetCreateTasklistState> {
  List<Task> taskList;
  TasksetCreateTasklistBloc(this.taskList) : super(TasksetCreateTasklistInitial()) {
    on<AddToTaskList>((event, emit) {
      taskList.add(event.task);
      emit(UpdateTaskList());
    });
    on<RemoveFromTaskList>((event, emit) {
      taskList.removeWhere((element) => element.id == event.id);
      emit(UpdateTaskList());
    });
    on<EditTaskInTaskList>((event, emit) {
      taskList.removeAt(event.pos!);
      taskList.insert(event.pos!, event.task);
      emit(UpdateTaskList());
    });
  }
}
