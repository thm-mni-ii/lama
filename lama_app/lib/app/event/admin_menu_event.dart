abstract class AdminMenuEvent {}

class AdminMenuLoadPrefsEvent extends AdminMenuEvent {}

class AdminMenuChangePrefsEvent extends AdminMenuEvent {
  String key;
  var value;
  AdminMenuChangePrefsEvent(this.key, this.value);
}

class AdminMenuLoadDefaultEvent extends AdminMenuEvent {}
