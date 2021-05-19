import 'package:lama_app/app/model/user_model.dart';

abstract class AdminState {}

class Loaded extends AdminState {
  List<User> userList;
  Loaded(this.userList);
}

class AddUserState extends AdminState {}
