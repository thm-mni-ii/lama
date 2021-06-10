import 'package:lama_app/app/model/taskUrl_model.dart';

abstract class TasksetOptionsState {}

class TasksetOptionsDefault extends TasksetOptionsState {
  List<TaskUrl> urls;
  List<TaskUrl> deletedUrls;
  TasksetOptionsDefault(this.urls, this.deletedUrls);
}

class TasksetOptionsPushSuccess extends TasksetOptionsState {}

class TasksetOptionsPushFailed extends TasksetOptionsState {
  String error;
  String failedUrl;
  TasksetOptionsPushFailed(
      {this.error = 'Da ist wohl was schiefgelaufen', this.failedUrl});
}

class TasksetOptionsDeleteSuccess extends TasksetOptionsState {}
