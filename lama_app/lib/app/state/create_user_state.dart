/// States used by [CreateUserScreen] and [CreateUserBloc]
///
/// Author: L.Kammerer
/// latest Changes: 14.06.2021
class CreateUserState {}

///transmit that the insert of the new [User] was successfull
class UserPushSuccessfull extends CreateUserState {}

///transmit every available grade of the app
///
///{@param}[List<String>] grades with every provided grade of the app as [String]
class CreateUserLoaded extends CreateUserState {
  List<String> grades;
  CreateUserLoaded(this.grades);
}
