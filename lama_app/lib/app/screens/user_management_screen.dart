import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/svg.dart';
//Lama default
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';
import 'package:lama_app/app/model/user_model.dart';
//Blocs
import 'package:lama_app/app/bloc/user_management_bloc.dart';
//Events
import 'package:lama_app/app/event/user_management_event.dart';
//States
import 'package:lama_app/app/state/user_management_state.dart';

///This file creates the User Management Screen
///the User Management Screen provides navigation
///to Screens which edits user/admin and creating users/admin
///there for all [User] are shown as [ListView].
///
///
/// * see also
///    [UserManagementBloc]
///    [UserManagementEvent]
///    [UserManagementState]
///
/// Author: L.Kammerer
/// latest Changes: 26.06.2021
class UserManagementScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserManagementScreenState();
  }
}

///UserManagementScreenState provides the state for the [UserManagementScreen]
class UserManagementScreenState extends State<UserManagementScreen> {
  @override
  void initState() {
    super.initState();

    ///forcing the [LoadAllUsers] event to load all users
    ///stored in the Database
    BlocProvider.of<UserManagementBloc>(context).add(LoadAllUsers());
  }

  ///override build methode [StatelessWidget]
  ///
  ///{@param} [BuildContext] as context
  ///
  ///{@return} [Widget] decided by the incoming state of the [UserManagementBloc]
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _bar(screenSize.width / 5),
      body: BlocBuilder<UserManagementBloc, UserManagementState>(
        builder: (context, state) {
          if (state is Loaded) {
            return _userListView(state.userList);
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: _floatingButton(context),
    );
  }

  ///(private)
  ///porvides [AppBar] with default design for Screens used by the Admin
  ///
  ///{@params}
  ///[AppBar] size as double size
  ///
  ///{@return} [AppBar] with generel AdminMenu specific design
  Widget _bar(double size) {
    return AppBar(
      title: Text(
        'Nutzerverwaltung',
        style: LamaTextTheme.getStyle(fontSize: 18),
      ),
      toolbarHeight: size,
      backgroundColor: LamaColors.bluePrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
    );
  }

  ///(private)
  ///is used to show all [User] stored in the Database using
  ///[_userCard]
  ///
  ///{@params}
  ///all [User] as [List]<[User]> list
  ///
  ///{@return} [ListView] with [User]
  Widget _userListView(List<User> list) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return _userCard(list[index]);
      },
    );
  }

  ///(private)
  ///used to display an user with username and avatar as
  ///[Card] with [ListTile]. onTap triggers the [EditUser] event.
  ///
  ///{@param} [User] as user that should be displayed
  Widget _userCard(User user) {
    ///attache '(Admin)' to the username if the user is an Admin
    String _nameDisplay = user.isAdmin ? user.name + ' (Admin)' : user.name;
    return BlocBuilder<UserManagementBloc, UserManagementState>(
      builder: (context, state) {
        return Card(
          child: ListTile(
            onTap: () {
              context.read<UserManagementBloc>().add(EditUser(user, context));
            },
            title: Text(
              _nameDisplay,
              style: LamaTextTheme.getStyle(
                fontSize: 20,
                color: LamaColors.black,
                monospace: true,
                fontWeight: FontWeight.w500,
              ),
            ),
            leading: CircleAvatar(
              child: SvgPicture.asset(
                'assets/images/svg/avatars/${user.avatar}.svg',
                semanticsLabel: 'LAMA',
              ),
              radius: 25,
              backgroundColor: LamaColors.mainPink,
            ),
          ),
        );
      },
    );
  }

  ///(private)
  ///used to display an [SpeedDial] with two [SpeedDialChild]
  ///one for creating an user which triggers the [CreateUser] event
  ///and the other one for creating an admin which triggers the [CreateAdmin] event.
  ///
  ///{@param} BuildContext as context
  Widget _floatingButton(BuildContext context) {
    return SpeedDial(
      icon: Icons.add,
      backgroundColor: LamaColors.mainPink,
      foregroundColor: LamaColors.white,
      children: [
        SpeedDialChild(
          label: 'Nutzer hinzufügen',
          backgroundColor: LamaColors.mainPink,
          onTap: () =>
              {context.read<UserManagementBloc>().add(CreateUser(context))},
          child: Icon(
            Icons.group_add,
            color: LamaColors.white,
          ),
        ),
        SpeedDialChild(
          label: 'Administrator hinzufügen',
          backgroundColor: LamaColors.bluePrimary,
          onTap: () =>
              {context.read<UserManagementBloc>().add(CreateAdmin(context))},
          child: Icon(
            Icons.group_add,
            color: LamaColors.white,
          ),
        ),
      ],
    );
  }
}
