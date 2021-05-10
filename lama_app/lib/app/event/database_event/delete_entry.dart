import 'entry_event.dart';

class DeleteUser extends EntryEvent {
  int userIndex;

  DeleteUser(int index) {
    userIndex = index;
  }
}