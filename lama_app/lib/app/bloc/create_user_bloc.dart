import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:lama_app/app/event/create_user_event.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/app/state/create_user_state.dart';
import 'package:lama_app/db/database_provider.dart';

///[Bloc] for the [CreateUserScreen]
///
/// * see also
///    [CreateUserScreen]
///    [CreateUserEvent]
///    [CreateUserState]
///    [Bloc]
///
/// Author: L.Kammerer
/// latest Changes: 26.06.2021
class CreateUserBloc extends Bloc<CreateUserEvent, CreateUserState?> {
  //grades supported by this App
  List<String> _grades = [
    'Klasse 1',
    'Klasse 2',
    'Klasse 3',
    'Klasse 4',
    'Klasse 5',
    'Klasse 6',
  ];

  ///[User] that is inserted in to the Database later on
  ///incoming events are used to change the values of this [User]
  User user = User(grade: 1, coins: 0, isAdmin: false, avatar: 'lama');

  CreateUserBloc({CreateUserState? initialState}) : super(initialState) {
    on<LoadGrades>((event, emit) async {
      emit(await CreateUserLoaded(_grades));
    });
    on<CreateUserAbort>((event, emit) async {
      _createUserReturn(event.context);
    });
    on<CreateUserPush>((event, emit) async {
      emit(await _pushUser());
    });
    //Change Bloc User events
    on<UsernameChange>((event, emit) async {
      user.name = event.name;
    });
    on<UserPasswortChange>((event, emit) async {
      user.password = event.passwort;
    });
    on<UserGradeChange>((event, emit) async {
      user.grade = event.grade;
      print(user.grade);
    });
  }

  ///(private)
  ///pops the Screen
  ///
  ///{@param}[BuildContext] as context
  void _createUserReturn(BuildContext context) {
    Navigator.pop(context);
  }

  ///(private)
  ///inserting the given [User] [user] into the Database
  Future<UserPushSuccessfull> _pushUser() async {
    await DatabaseProvider.db.insertUser(user);
    return UserPushSuccessfull();
  }
}
