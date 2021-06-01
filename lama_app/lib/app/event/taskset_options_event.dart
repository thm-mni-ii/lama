import 'package:flutter/cupertino.dart';

abstract class TasksetOptionsEvent {}

class TasksetOptionsAbort extends TasksetOptionsEvent {
  BuildContext context;
  TasksetOptionsAbort(this.context);
}

class TasksetOptionsPush extends TasksetOptionsEvent {}

class TasksetOptionsReload extends TasksetOptionsEvent {}

//Change Events
class TasksetOptionsChangeURL extends TasksetOptionsEvent {
  String tasksetUrl;
  TasksetOptionsChangeURL(this.tasksetUrl);
}
