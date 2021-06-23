import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:lama_app/app/event/edit_user_event.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/app/state/edit_user_state.dart';
import 'package:lama_app/db/database_provider.dart';

class EditUserBloc extends Bloc<EditUserEvent, EditUserState> {
  User _user;
  User _changedUser = User();

  EditUserBloc(User user, {EditUserState initialState}) : super(initialState) {
    this._user = user;
  }

  @override
  Stream<EditUserState> mapEventToState(event) async* {
    print(_user.coins);
    if (event is EditUserAbort) _editUserReturn(event.context);
    if (event is EditUserDeleteUserCheck) yield await _deleteUserCheck();
    if (event is EditUserDeleteUserAbrove) _deleteUser(event.context);
    if (event is EditUserDeleteUserAbort) yield EditUserDefault(_user);
    if (event is EditUserPush) yield await _pushUserChanges();
    if (event is EditUserReturn) _editUserReturn(event.context);

    //Change Bloc User
    if (event is EditUserChangeUsername) _changedUser.name = event.name;
    if (event is EditUserChangePasswort) _changedUser.password = event.passwort;
    if (event is EditUserChangeCoins) {
      _changedUser.coins = (int.parse(event.coins));
    }
    if (event is EditUserChangeGrade) _changedUser.grade = event.grade;
  }

  Future<EditUserState> _pushUserChanges() async {
    //Username
    if (_changedUser.name != _user.name && _changedUser.name != null)
      await DatabaseProvider.db.updateUserName(_user, _changedUser.name);
    //Passwort
    if (_changedUser.password != _user.password &&
        _changedUser.password != null)
      await DatabaseProvider.db.updatePassword(_changedUser.password, _user);
    //Coins
    if (_changedUser.coins != _user.coins && _changedUser.coins != null)
      await DatabaseProvider.db.updateUserCoins(_user, _changedUser.coins);
    if (_changedUser.grade != _user.grade && _changedUser.grade != null)
      await DatabaseProvider.db.updateUserGrade(_user, _changedUser.grade);
    return EditUserChangeSuccess(_user, _changedUser);
  }

  Future<EditUserState> _deleteUserCheck() async {
    if (_user.isAdmin && await _checkForLastAdmin())
      return EditUserDeleteCheck(
          'HINWEIS: \n Sie sind im Begriff den letzten Admin zu löschen. \n Sind keine Nutzer dieser Art vorhanden, werden Sie nach dem Neustart der App aufgefordert einen neuen Admin Nutzer zu erstellen. \n Dies hat KEINE auswirkungen auf andere Nutzer.');
    else
      return EditUserDeleteCheck(
          'Sie möchten den Nutzer (${_user.name}) löschen.');
  }

  Future<void> _deleteUser(BuildContext context) async {
    await DatabaseProvider.db.deleteUser(_user.id);
    _editUserReturn(context);
  }

  void _editUserReturn(BuildContext context) {
    Navigator.pop(context);
  }

  Future<bool> _checkForLastAdmin() async {
    List<User> list = await DatabaseProvider.db.getUser();
    int count = 0;
    list.forEach((element) {
      if (element.isAdmin) count++;
      if (count >= 2) return false;
    });
    return true;
  }
}
