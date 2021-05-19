import 'package:lama_app/app/model/user_model.dart';

abstract class AdminScreenEvent {}

class LoadAllUsers extends AdminScreenEvent {}

class SelectUser extends AdminScreenEvent {
  User user;
  SelectUser(this.user);
}
