import 'package:lama_app/app/model/taskUrl_model.dart';

abstract class TasksetOptionsState {}

class TasksetOptionsDefault extends TasksetOptionsState {
  List<TaskUrl> urls;
  List<TaskUrl> deletedUrls;
  TasksetOptionsDefault(this.urls, this.deletedUrls);
}

class TasksetOptionsPushSuccess extends TasksetOptionsState {}

class TasksetOptionsDeleteSuccess extends TasksetOptionsState {}
