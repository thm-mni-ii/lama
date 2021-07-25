import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lama_app/app/bloc/admin_screen_bloc.dart';
import 'package:lama_app/app/event/admin_screen_event.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/app/state/admin_state.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';

class AdminScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AdminScreenState();
  }
}

class AdminScreenState extends State<AdminScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AdminScreenBloc>(context).add(LoadAllUsers());
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _bar(screenSize.width / 5),
      body: BlocBuilder<AdminScreenBloc, AdminState>(
        builder: (context, state) {
          if (state is Loaded) {
            return _userListView(state.userList);
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 30),
            child: FloatingActionButton(
              heroTag: "back",
              backgroundColor: LamaColors.bluePrimary,
              onPressed: () => {
                context.read<AdminScreenBloc>().add(LogoutAdminScreen(context))
              },
              tooltip: 'Ausloggen',
              child: Icon(Icons.logout),
            ),
          ),
          Spacer(),
          FloatingActionButton(
              heroTag: "addUser",
              backgroundColor: LamaColors.bluePrimary,
              onPressed: () =>
                  {context.read<AdminScreenBloc>().add(CreateUser(context))},
              tooltip: 'Nutzer hinzufügen',
              child: Icon(Icons.add)),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      ),
    );
  }

  Widget _bar(double size) {
    return AppBar(
      title: Text(
        'Verwalte deine Nutzer',
        style: LamaTextTheme.getStyle(fontSize: 18),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.settings_rounded,
            color: LamaColors.white,
          ),
          onPressed: () =>
              {context.read<AdminScreenBloc>().add(TasksetOption(context))},
        ),
      ],
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
    return BlocBuilder<AdminScreenBloc, AdminState>(
      builder: (context, state) {
        return Card(
          child: ListTile(
            onTap: () {
              context.read<AdminScreenBloc>().add(EditUser(user, context));
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
