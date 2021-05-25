import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:lama_app/app/event/create_user_event.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/app/state/create_user_state.dart';
import 'package:lama_app/db/database_provider.dart';

class CreateUserBloc extends Bloc<CreateUserEvent, CreateUserState> {
  List<String> _grades = [
    'Klasse 1',
    'Klasse 2',
    'Klasse 3',
    'Klasse 4',
    'Klasse 5',
    'Klasse 6',
  ];
  User user = User(grade: 1, coins: 0, isAdmin: false, avatar: 'lama');

  CreateUserBloc({CreateUserState initialState}) : super(initialState);

  @override
  Stream<CreateUserState> mapEventToState(CreateUserEvent event) async* {
    if (event is CreateUserAbort) _createUserReturn(event.context);
    if (event is CreateUserPush) yield await _pushUser();
    if (event is LoadGrades) yield CreateUserLoaded(_grades);

    //Change Bloc User events
    if (event is UsernameChange) user.name = event.name;
    if (event is UserPasswortChange) user.password = event.passwort;
    if (event is UserGradeChange) {
      user.grade = event.grade;
      print(user.grade);
    }
  }

  //Change Screen

  void _createUserReturn(BuildContext context) {
    Navigator.pop(context);
  }

  Future<UserPushSuccessfull> _pushUser() async {
    await DatabaseProvider.db.insertUser(user);
    return UserPushSuccessfull();
  }
}
