import 'package:lama_app/app/model/taskUrl_model.dart';

/// States used by [TasksetOptionScreen] and [TasksetOptionsBloc]
///
/// Author: L.Kammerer
/// latest Changes: 14.06.2021
abstract class TasksetOptionsState {}

///transmit every [TaskUrl] stored in the database and
///every deletedUrl stored in the [TasksetOptionsBloc]
///
///{@params}
///[List<TaskUrl>] urls [TaskUrl] stored in the database
///[List<TaskUrl>] deletedUrls [TaskUrl] stored in the [TasksetOptionsBloc]
class TasksetOptionsDefault extends TasksetOptionsState {
  List<TaskUrl> urls;
  List<TaskUrl> deletedUrls;
  TasksetOptionsDefault(this.urls, this.deletedUrls);
}

///used to transmit an success after inserting an [TaskUrl] into the database
class TasksetOptionsPushSuccess extends TasksetOptionsState {}

///used to transmit an error by inserting an [TaskUrl] into the database
///also transmit an error message and the url that caused the error
///
///{@params}
///[String] error contains the error message
///[String] failedUrl contains the url that caused the error
class TasksetOptionsPushFailed extends TasksetOptionsState {
  String error;
  String failedUrl;
  TasksetOptionsPushFailed(
      {this.error = 'Da ist wohl was gehörig schiefgelaufen', this.failedUrl});
}

///used to transmit an waiting state with waiting message
///
///{@param}[String] waitingText to transmit an waiting message
class TasksetOptionsWaiting extends TasksetOptionsState {
  String waitingText;
  TasksetOptionsWaiting(this.waitingText);
}

///used to replay with an selected url
///
///{@param}[String] url that is selected
class TasksetOptionsUrlSelected extends TasksetOptionsState {
  String url;
  TasksetOptionsUrlSelected(this.url);
}

///used to transmit an success after deleting an [TaskUrl] from the database
class TasksetOptionsDeleteSuccess extends TasksetOptionsState {}
