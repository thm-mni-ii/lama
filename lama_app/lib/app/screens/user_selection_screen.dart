import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
//Lama default
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';
import 'package:lama_app/app/model/user_model.dart';
//Blocs
import 'package:lama_app/app/bloc/user_selection_bloc.dart';
//Events
import 'package:lama_app/app/event/user_selection_event.dart';
//States
import 'package:lama_app/app/state/user_selection_state.dart';

///This file creates the User Selection Screen
///the User Selection Screen provides navigation
///to the Login Screen for an specific user
///
///{@important} to understand how the login works see
///[UserSelectionBloc] and [UserLoginScreen]
///
/// * see also
///    [UserSelectionBloc]
///    [UserSelectionEvent]
///    [UserSelectionState]
///
/// Author: L.Kammerer
/// latest Changes: 26.06.2021
class UserSelectionScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserSelectionScreenState();
  }
}

///UserSelectionScreenState provides the state for the [UserSelectionScreen]
class UserSelectionScreenState extends State<UserSelectionScreen> {
  GlobalKey _scaffold = GlobalKey();

  @override
  void initState() {
    super.initState();

    ///forcing the [LoadAllUsers] event to load all users
    ///stored in the Database
    BlocProvider.of<UserSelectionBloc>(context).add(LoadUsers());
  }

  ///override build methode [StatelessWidget]
  ///
  ///{@param} [BuildContext] as context
  ///
  ///{@return} [Widget] decided by the incoming state of the [UserSelectionBloc]
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffold,
      appBar: _bar(screenSize.width / 5),
      body: BlocBuilder<UserSelectionBloc, UserSelectionState>(
        builder: (context, state) {
          if (state is UsersLoaded) {
            return _userListView(state.userList);
          }
          context.read<UserSelectionBloc>().add(LoadUsers());
          return Center(child: CircularProgressIndicator());
        },
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
  ///[Card] with [ListTile]. onTap triggers the [SelectUser] event.
  ///
  ///{@param} [User] as user that should be displayed
  Widget _userCard(User user) {
    ///attache '(Admin)' to the username if the user is an Admin
    String _nameDisplay = user.isAdmin ? user.name + ' (Admin)' : user.name;
    return BlocBuilder<UserSelectionBloc, UserSelectionState>(
      builder: (context, state) {
        return Card(
          child: ListTile(
            onTap: () {
              _scaffold.currentContext
                  .read<UserSelectionBloc>()
                  .add(SelectUser(user, _scaffold.currentContext));
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
  ///porvides [AppBar] with default design for the Login Screen
  ///
  ///{@params}
  ///[AppBar] size as double size
  ///
  ///{@return} [AppBar] with specific design
  Widget _bar(double size) {
    return AppBar(
      title: Text('Nutzerauswahl', style: LamaTextTheme.getStyle(fontSize: 18)),
      toolbarHeight: size,
      backgroundColor: LamaColors.mainPink,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
    );
  }
}
