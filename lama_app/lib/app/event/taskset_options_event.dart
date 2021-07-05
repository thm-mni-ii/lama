import 'package:flutter/cupertino.dart';
import 'package:lama_app/app/model/taskUrl_model.dart';
import 'package:lama_app/app/repository/taskset_repository.dart';

abstract class TasksetOptionsEvent {}

class TasksetOptionsAbort extends TasksetOptionsEvent {
  BuildContext context;
  TasksetOptionsAbort(this.context);
}

class TasksetOptionsPush extends TasksetOptionsEvent {
  TasksetRepository tasksetRepository;
  TasksetOptionsPush(this.tasksetRepository);
}

class TasksetOptionsReAddUrl extends TasksetOptionsEvent {
  TaskUrl url;
  TasksetRepository tasksetRepository;
  TasksetOptionsReAddUrl(this.url, this.tasksetRepository);
}

class TasksetOptionsDelete extends TasksetOptionsEvent {
  TaskUrl url;
  TasksetRepository tasksetRepository;
  TasksetOptionsDelete(this.url, this.tasksetRepository);
}

class TasksetOptionsSelectUrl extends TasksetOptionsEvent {
  TaskUrl url;
  TasksetOptionsSelectUrl(this.url);
}

class TasksetOptionsReload extends TasksetOptionsEvent {}

//Change Events
class TasksetOptionsChangeURL extends TasksetOptionsEvent {
  String tasksetUrl;
  TasksetOptionsChangeURL(this.tasksetUrl);
}
