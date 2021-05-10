import 'package:lama_app/app/model/user_model.dart';
import 'entry_event.dart';

class UpdateUser extends EntryEvent {
  User newUser;
  int userIndex;

  UpdateUser(int index, User user) {
    newUser = user;
    userIndex = index;
  }
}