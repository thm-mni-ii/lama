import 'package:lama_app/app/model/user_model.dart';

abstract class UserSelectionState {}

class UsersLoaded extends UserSelectionState {
  List<User> userList;
  UsersLoaded(this.userList);
}

class UserSelected extends UserSelectionState {
  User user;
  UserSelected(this.user);
}
