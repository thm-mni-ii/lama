import 'package:lama_app/app/model/user_model.dart';

import 'entry_event.dart';

class SetUser extends EntryEvent {
  List<User> userList;

  SetUser(List<User> users){
    userList = users;
  }
}