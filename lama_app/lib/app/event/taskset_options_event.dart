import 'package:flutter/cupertino.dart';
import 'package:lama_app/app/model/taskUrl_model.dart';
import 'package:lama_app/app/repository/taskset_repository.dart';
import 'package:lama_app/app/task-system/taskset_loader.dart';

abstract class TasksetOptionsEvent {}

class TasksetOptionsAbort extends TasksetOptionsEvent {
  BuildContext context;
  TasksetOptionsAbort(this.context);
}

class TasksetOptionsPush extends TasksetOptionsEvent {
  BuildContext context;
  TasksetOptionsPush(this.context);
}

class TasksetOptionsPushUrl extends TasksetOptionsEvent {
  TaskUrl url;
  TasksetOptionsPushUrl(this.url);
}

class TasksetOptionsDelete extends TasksetOptionsEvent {
  TaskUrl url;
  TasksetRepository tasksetRepository;
  TasksetOptionsDelete(this.url, this.tasksetRepository);
}

class TasksetOptionsReload extends TasksetOptionsEvent {}

//Change Events
class TasksetOptionsChangeURL extends TasksetOptionsEvent {
  String tasksetUrl;
  TasksetOptionsChangeURL(this.tasksetUrl);
}
