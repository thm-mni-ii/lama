import 'package:flutter/cupertino.dart';
import 'package:lama_app/app/model/taskUrl_model.dart';

abstract class TasksetOptionsEvent {}

class TasksetOptionsAbort extends TasksetOptionsEvent {
  BuildContext context;
  TasksetOptionsAbort(this.context);
}

class TasksetOptionsPush extends TasksetOptionsEvent {}

class TasksetOptionsDelete extends TasksetOptionsEvent {
  TaskUrl url;
  TasksetOptionsDelete(this.url);
}

class TasksetOptionsReload extends TasksetOptionsEvent {}

//Change Events
class TasksetOptionsChangeURL extends TasksetOptionsEvent {
  String tasksetUrl;
  TasksetOptionsChangeURL(this.tasksetUrl);
}
