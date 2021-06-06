import 'package:lama_app/app/model/user_model.dart';

abstract class UserManagementState {}

class Loaded extends UserManagementState {
  List<User> userList;
  Loaded(this.userList);
}
