import 'package:lama_app/app/model/user_model.dart';

abstract class EditUserState {}

class EditUserDefault extends EditUserState {
  User user;
  EditUserDefault(this.user);
}

class EditUserChangeSuccess extends EditUserState {
  User user;
  User changedUser;
  EditUserChangeSuccess(this.user, this.changedUser);
}

class EditUserDeleteCheck extends EditUserState {
  String message;
  EditUserDeleteCheck(this.message);
}
