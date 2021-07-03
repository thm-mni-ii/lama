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
      {this.error = 'Da ist wohl was gehörig schiefgelaufen', this.failedUrl});
}

class TasksetOptionsWaiting extends TasksetOptionsState {
  String waitingText;
  TasksetOptionsWaiting(this.waitingText);
}

class TasksetOptionsUrlSelected extends TasksetOptionsState {
  String url;
  TasksetOptionsUrlSelected(this.url);
}

class TasksetOptionsDeleteSuccess extends TasksetOptionsState {}
