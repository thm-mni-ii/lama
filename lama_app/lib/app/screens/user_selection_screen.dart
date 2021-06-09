import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lama_app/app/bloc/user_login_bloc.dart';
import 'package:lama_app/app/event/user_login_event.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/app/state/user_login_state.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';

class UserSelectionScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserSelectionScreenState();
  }
}

class UserSelectionScreenState extends State<UserSelectionScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<UserLoginBloc>(context).add(LoadUsers());
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: _bar(screenSize.width / 5),
      body: BlocBuilder<UserLoginBloc, UserLoginState>(
        builder: (context, state) {
          if (state is UsersLoaded) {
            return _userListView(state.userList);
          }
          context.read<UserLoginBloc>().add(LoadUsers());
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
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
  return BlocBuilder<UserLoginBloc, UserLoginState>(
    builder: (context, state) {
      return Card(
        child: ListTile(
          onTap: () {
            context.read<UserLoginBloc>().add(SelectUser(user));
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
