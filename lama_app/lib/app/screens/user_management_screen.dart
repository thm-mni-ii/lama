import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lama_app/app/bloc/user_management_bloc.dart';
import 'package:lama_app/app/event/user_management_event.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/app/state/user_management_state.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';

class UserManagementScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserManagementScreenState();
  }
}

class UserManagementScreenState extends State<UserManagementScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<UserManagementBloc>(context).add(LoadAllUsers());
  }

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
      floatingActionButton: Wrap(
        children: [
          FloatingActionButton(
            heroTag: "addUser",
            backgroundColor: LamaColors.mainPink,
            onPressed: () =>
                {context.read<UserManagementBloc>().add(CreateUser(context))},
            tooltip: 'Nutzer hinzufügen',
            child: Icon(Icons.group_add),
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            heroTag: "addAdmin",
            backgroundColor: LamaColors.bluePrimary,
            onPressed: () =>
                {context.read<UserManagementBloc>().add(CreateAdmin(context))},
            tooltip: 'Admin hinzufügen',
            child: Icon(Icons.group_add),
          ),
        ],
      ),
    );
  }

  Widget _bar(double size) {
    return AppBar(
      title: Text(
        'Verwalte deine Nutzer',
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

  Widget _userListView(List<User> list) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return _userCard(list[index]);
      },
    );
  }

  Widget _userCard(User user) {
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
}
