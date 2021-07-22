import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/create_admin_bloc.dart';
import 'package:lama_app/app/bloc/user_selection_bloc.dart';
import 'package:lama_app/app/event/check_screen_event.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/app/screens/create_admin_screen.dart';
import 'package:lama_app/app/screens/user_selection_screen.dart';
import 'package:lama_app/app/state/check_screen_state.dart';
import 'package:lama_app/db/database_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

///[Bloc] for the [CheckScreen]
///
/// * see also
///    [CheckScreen]
///    [CheckScreenEvent]
///    [CheckScreenState]
///    [Bloc]
///
/// Author: L.Kammerer
/// latest Changes: 14.07.2021
class CheckScreenBloc extends Bloc<CheckScreenEvent, CheckScreenState> {
  CheckScreenBloc({CheckScreenState initialState}) : super(initialState);

  @override
  Stream<CheckScreenState> mapEventToState(CheckScreenEvent event) async* {
    if (event is CheckForAdmin) yield await _hasAdmin(event.context);
    if (event is DSGVOAccepted) yield await _navigator(event.context);
    if (event is CreateAdminEvent) yield await _navigator(event.context);
  }

  ///(private)
  ///check if an admin is stored in the Database
  ///if there is no admin the user has to accept the DSGVO
  ///and the 'enableDefaultTaskset' is set to default value true in the [SharedPreferences]
  ///if there is an Admin stored in the Database [_navigateAdminExist] is used
  ///
  ///{@param} [BuildContext] as context
  Future<CheckScreenState> _hasAdmin(BuildContext context) async {
    List<User> userList = await DatabaseProvider.db.getUser();
    if (userList == null) return ShowDSGVO(await _loadDSGVO());
    for (User user in userList) {
      if (user.isAdmin) {
        _navigateAdminExist(context);
        return AdminExist();
      }
    }
    //set [SharedPreferences]
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('enableDefaultTaskset', true);
    return ShowDSGVO(await _loadDSGVO());
  }

  ///(private)
  ///used if no admin exists to force the user to create an admin
  ///
  ///{@param} [BuildContext] as context
  Future<CheckScreenState> _navigator(BuildContext context) async {
    await _navigateNoAdmin(context);
    return CreateAdmin();
  }

  ///(private)
  ///loading DSGVO out of the asserts
  Future<String> _loadDSGVO() async {
    return await rootBundle.loadString('assets/md/DSGVO.md');
  }

  ///(private)
  ///navigate to [CreateAdminScreen] with await. If the [CreateAdminScreen] pops with out creating and admin
  ///the admin value is equal to null. If an admin is created the [CreateAdminScreen] return an [User] on pop
  ///so this function ends with [_navigateAdminExist]
  ///
  ///{@param} [BuildContext] as context
  Future<void> _navigateNoAdmin(BuildContext context) async {
    User admin = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (BuildContext context) => CreateAdminBloc(),
          child: CreateAdminScreen(),
        ),
      ),
    );
    if (admin != null) _navigateAdminExist(context);
  }

  ///(private)
  ///used if an admin exist or is created navigats to [UserSelectionScreen]
  ///via [Navigator].pushReplacement
  ///
  ///{@param} [BuildContext] as context
  void _navigateAdminExist(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (BuildContext context) => UserSelectionBloc(),
          child: UserSelectionScreen(),
        ),
      ),
    );
  }
}
