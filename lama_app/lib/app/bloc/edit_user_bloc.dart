import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:lama_app/app/event/edit_user_event.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/app/state/edit_user_state.dart';
import 'package:lama_app/db/database_provider.dart';

///[Bloc] for the [EditUserScreen]
///
/// * see also
///    [EditUserScreen]
///    [EditUserEvent]
///    [EditUserState]
///    [Bloc]
///
/// Author: L.Kammerer
/// latest Changes: 26.06.2021
class EditUserBloc extends Bloc<EditUserEvent, EditUserState> {
  //[User] that should be updated in the database
  User _user;

  ///[User] to store the changed values
  ///incoming events are used to change the values
  User _changedUser = User();

  ///{@param}[User] as user that should be updated or deleted in the database
  EditUserBloc(User user, {EditUserState initialState}) : super(initialState) {
    this._user = user;
  }

  @override
  Stream<EditUserState> mapEventToState(event) async* {
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

  ///(private)
  ///compare specific values of [_user] with [_changedUser]
  ///if the value of [_user] is unequal to [_changedUser] and the value [_changedUser] is not null
  ///the specific value is updated in the database
  ///
  ///{@return} [EditUserChangeSuccess] containing [_user] and [_changedUser]
  Future<EditUserState> _pushUserChanges() async {
    //Username
    if (_changedUser.name != _user.name && _changedUser.name != null)
      await DatabaseProvider.db.updateUserName(_user, _changedUser.name);
    //Password
    if (_changedUser.password != _user.password &&
        _changedUser.password != null)
      await DatabaseProvider.db.updatePassword(_changedUser.password, _user);
    //Coins
    if (_changedUser.coins != _user.coins && _changedUser.coins != null)
      await DatabaseProvider.db.updateUserCoins(_user, _changedUser.coins);
    //Grade
    if (_changedUser.grade != _user.grade && _changedUser.grade != null)
      await DatabaseProvider.db.updateUserGrade(_user, _changedUser.grade);
    return EditUserChangeSuccess(_user, _changedUser);
  }

  ///(private)
  ///provides warning befor an [User] is delete in the database
  ///if the last admin in the database would be deleted an specific warning returns with [EditUserDeleteCheck]
  Future<EditUserState> _deleteUserCheck() async {
    if (_user.isAdmin && await _checkForLastAdmin())
      return EditUserDeleteCheck(
          'HINWEIS: \n Sie sind im Begriff den letzten Admin zu löschen. \n Sind keine Nutzer dieser Art vorhanden, werden Sie nach dem Neustart der App aufgefordert einen neuen Admin Nutzer zu erstellen. \n Dies hat KEINE auswirkungen auf andere Nutzer.');
    else
      return EditUserDeleteCheck(
          'Sie möchten den Nutzer (${_user.name}) löschen.');
  }

  ///(private)
  ///delete the user in the database and
  ///calls [_editUserReturn] to pop the screen
  ///
  ///{@param}[BuildContext] context
  Future<void> _deleteUser(BuildContext context) async {
    await DatabaseProvider.db.deleteUser(_user.id);
    _editUserReturn(context);
  }

  ///(private)
  ///pops the Screen
  ///
  ///{@param}[BuildContext] as context
  void _editUserReturn(BuildContext context) {
    Navigator.pop(context);
  }

  ///(private)
  ///calling the database and go through all users counting the admins
  ///if ther is only one admin stored in the database the function ends with
  ///return true else false
  Future<bool> _checkForLastAdmin() async {
    List<User> list = await DatabaseProvider.db.getUser();
    int count = 0;
    for (int i = 0; i < list.length; i++) {
      if (list[i].isAdmin) count++;
      if (count > 1) return false;
    }
    return true;
  }
}
