import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/event/create_admin_event.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/app/state/create_admin_state.dart';
import 'package:lama_app/db/database_provider.dart';

class CreateAdminBloc extends Bloc<CreateAdminEvent, CreateAdminState> {
  User _user = User(grade: 1, coins: 0, isAdmin: true, avatar: 'admin');

  CreateAdminBloc({CreateAdminState initialState}) : super(initialState);

  @override
  Stream<CreateAdminState> mapEventToState(CreateAdminEvent event) async* {
    if (event is CreateAdminPush) _adminPush(_user, event.context);
    if (event is CreateAdminChangeName) _user.name = event.name;
    if (event is CreateAdminChangePassword) _user.password = event.password;
    if (event is CreateAdminAbort) _adminAbort(event.context);
  }

  //pop with return value _user
  Future<void> _adminPush(User user, BuildContext context) async {
    await _insterAdmin(user);
    Navigator.pop(context, _user);
  }

  Future<void> _insterAdmin(User user) async {
    if (user.isAdmin != null || user.isAdmin)
      await DatabaseProvider.db.insertUser(user);
  }

  void _adminAbort(BuildContext context) {
    Navigator.pop(context, null);
  }
}
