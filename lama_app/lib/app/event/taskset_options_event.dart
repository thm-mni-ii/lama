import 'package:lama_app/app/model/taskUrl_model.dart';

/// Events used by [TasksetOptionScreen] and [TasksetOptionsBloc]
///
/// Author: L.Kammerer
/// latest Changes: 14.07.2021
abstract class TasksetOptionsEvent {}

///used to insert an [TaskUrl] into the database and finish the add url process
class TasksetOptionsPush extends TasksetOptionsEvent {}

///used to add an deleted [TaskUrl] back into the database
///
///{@param}[TaskUrl] url that should be inserted into the database
class TasksetOptionsReAddUrl extends TasksetOptionsEvent {
  TaskUrl url;
  TasksetOptionsReAddUrl(this.url);
}

///used to delete an specific [TaskUrl] from the database
///
///{@param}[TaskUrl] tasksetUrl that should be set
class TasksetOptionsDelete extends TasksetOptionsEvent {
  TaskUrl url;
  TasksetOptionsDelete(this.url);
}

///used to let the [TasksetOptionsBloc] know that an specific [TaskUrl] is selected
///
///{@param}[TaskUrl] url that is selected
class TasksetOptionsSelectUrl extends TasksetOptionsEvent {
  TaskUrl url;
  TasksetOptionsSelectUrl(this.url);
}

///load all stored [TaskUrl] from the database and
class TasksetOptionsReload extends TasksetOptionsEvent {}

//Change Events
///used to change the [TaskUrl] in Bloc
///
///{@param}[String] tasksetUrl that should be set
class TasksetOptionsChangeURL extends TasksetOptionsEvent {
  String tasksetUrl;
  TasksetOptionsChangeURL(this.tasksetUrl);
}
