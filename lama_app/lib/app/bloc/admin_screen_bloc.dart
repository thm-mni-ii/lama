import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/create_user_bloc.dart';
import 'package:lama_app/app/bloc/edit_user_bloc.dart';
import 'package:lama_app/app/bloc/taskset_options_bloc.dart';
import 'package:lama_app/app/bloc/user_login_bloc.dart';
import 'package:lama_app/app/event/admin_screen_event.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/app/screens/create_user_screen.dart';
import 'package:lama_app/app/screens/edit_user_screen.dart';
import 'package:lama_app/app/screens/taskset_option_screen.dart';
import 'package:lama_app/app/screens/user_login_screen.dart';
import 'package:lama_app/app/state/admin_state.dart';
import 'package:lama_app/db/database_provider.dart';

class AdminScreenBloc extends Bloc<AdminScreenEvent, AdminState> {
  AdminScreenBloc({AdminState initialState}) : super(initialState);

  @override
  Stream<AdminState> mapEventToState(AdminScreenEvent event) async* {
    if (event is LoadAllUsers) yield await _loadUsers();
    if (event is LogoutAdminScreen) _logout(event.context);
    if (event is CreateUser) _createUserScreen(event.context);
    if (event is EditUser) _editUserScreen(event.context, event.user);
    if (event is TasksetOption) _tasksetOption(event.context);
  }

  void _createUserScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (BuildContext context) => CreateUserBloc(),
          child: CreateUserScreen(),
        ),
      ),
    ).then((value) => context.read<AdminScreenBloc>().add(LoadAllUsers()));
  }

  void _editUserScreen(BuildContext context, User user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (BuildContext context) => EditUserBloc(user),
          child: EditUserScreen(user),
        ),
      ),
    ).then((value) => context.read<AdminScreenBloc>().add(LoadAllUsers()));
  }

  void _logout(BuildContext context) {
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

  void _tasksetOption(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (BuildContext context) => TasksetOprionsBloc(),
          child: OptionTaskScreen(),
        ),
      ),
    ).then((value) => context.read<AdminScreenBloc>().add(LoadAllUsers()));
  }

  //Operations
  Future<Loaded> _loadUsers() async {
    List<User> userList = await DatabaseProvider.db.getUser();
    return Loaded(userList);
  }
}
