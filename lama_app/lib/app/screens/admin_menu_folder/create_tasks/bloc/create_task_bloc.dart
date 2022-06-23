import 'package:bloc/bloc.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:meta/meta.dart';

part 'create_task_event.dart';
part 'create_task_state.dart';

class CreateTaskBloc extends Bloc<CreateTaskEvent, CreateTaskState> {
  Task? task;
  CreateTaskBloc(this.task) : super(CreateTaskInitial()) {
    on<EditTask>((event, emit) {
      task = event.task;
    });
  }
}
