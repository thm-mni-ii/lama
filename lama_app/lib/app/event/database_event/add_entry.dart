
import 'package:lama_app/app/model/user_model.dart';
import 'entry_event.dart';

class AddUser extends EntryEvent {
  User newUser;

  AddUser(User user){
    newUser = user;
  }
}