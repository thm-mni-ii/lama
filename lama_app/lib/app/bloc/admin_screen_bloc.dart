import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/user_login_bloc.dart';
import 'package:lama_app/app/event/admin_screen_event.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/app/repository/user_repository.dart';
import 'package:lama_app/app/screens/user_login_screen.dart';
import 'package:lama_app/app/state/admin_state.dart';
import 'package:lama_app/db/database_provider.dart';

class AdminScreenBloc extends Bloc<AdminScreenEvent, AdminState> {
  UserRepository userRepo;
  List<String> _grades = [
    'Klasse 1',
    'Klasse 2',
    'Klasse 3',
    'Klasse 4',
    'Klasse 5',
    'Klasse 6',
  ];
  User user = User(grade: 1, coins: 0, isAdmin: false, avatar: 'lama');

  AdminScreenBloc({AdminState initialState, this.userRepo})
      : super(initialState);

  @override
  Stream<AdminState> mapEventToState(AdminScreenEvent event) async* {
    if (event is LoadAllUsers) yield await _loadUsers();
    if (event is LogoutAdminScreen) _logout(event.context);
    if (event is CreateUser) yield CreateUserState(_grades);
    if (event is CreateUserAbort) yield await _loadUsers();
    if (event is CreateUserPush) yield await _pushUser();

    //Change BLoc User events
    if (event is UsernameChange) user.name = event.name;
    if (event is UserPasswortChange) user.password = event.passwort;
    if (event is UserGradeChange) {
      user.grade = event.grade;
      print(user.grade);
    }
  }

  void _logout(BuildContext context) {
    user = User();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (BuildContext context) => UserLoginBloc(),
          child: UserLoginScreen(),
        ),
      ),
    );
  }

  Future<Loaded> _loadUsers() async {
    List<User> userList = await DatabaseProvider.db.getUser();
    return Loaded(userList);
  }

  Future<UserPushSuccessfull> _pushUser() async {
    await DatabaseProvider.db.insertUser(user);
    return UserPushSuccessfull();
  }
}
