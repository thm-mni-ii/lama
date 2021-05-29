abstract class EditUserState {}

class EditUserDefault extends EditUserState {}

class EditUserDeleteCheck extends EditUserState {
  String message;
  EditUserDeleteCheck(this.message);
}
