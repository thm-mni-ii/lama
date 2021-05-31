import 'package:flutter/cupertino.dart';

abstract class TasksetOptionsEvent {}

class TasksetOptionsAbort extends TasksetOptionsEvent {
  BuildContext context;
  TasksetOptionsAbort(this.context);
}

class TasksetOptionsPush extends TasksetOptionsEvent {}
