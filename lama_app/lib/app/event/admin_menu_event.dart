import 'package:lama_app/app/repository/taskset_repository.dart';

abstract class AdminMenuEvent {}

class AdminMenuLoadPrefsEvent extends AdminMenuEvent {}

class AdminMenuChangePrefsEvent extends AdminMenuEvent {
  String key;
  var value;
  TasksetRepository repository;
  AdminMenuChangePrefsEvent(this.key, this.value, this.repository);
}

class AdminMenuLoadDefaultEvent extends AdminMenuEvent {}
