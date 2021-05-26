class CreateUserState {}

class UserPushSuccessfull extends CreateUserState {}

class CreateUserLoaded extends CreateUserState {
  List<String> grades;
  CreateUserLoaded(this.grades);
}
