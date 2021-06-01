import 'package:lama_app/app/model/taskUrl_model.dart';

abstract class TasksetOptionsState {}

class TasksetOptionsDefault extends TasksetOptionsState {
  List<TaskUrl> urls;
  TasksetOptionsDefault(this.urls);
}

class TasksetOptionsPushSuccess extends TasksetOptionsState {}
