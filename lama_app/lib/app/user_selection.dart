import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/user_login_bloc.dart';
import 'package:lama_app/app/event/user_login_event.dart';
import 'package:lama_app/app/state/user_login_state.dart';
import 'package:lama_app/app/user.dart';

class UserSelection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserSelectionState();
  }
}

class UserSelectionState extends State<UserSelection> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<UserLoginBloc>(context).add(LoadUsers());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder<UserLoginBloc, UserLoginState>(
        builder: (context, state) {
          if (state is UserSelected) {
            return _userCard(state.user);
          }
          context.read<UserLoginBloc>().add(LoadUsers());
          if (state is UsersLoaded) {
            return _userListView(state.userList);
          }
          return Text('Uppsie');
        },
      ),
    );
  }
}

Widget _passwortInput() {
  return null;
}

Widget _userListView(List<User> list) {
  return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return _userCard(list[index]);
      });
}

Widget _userCard(User user) {
  return Card(
    child: ListTile(
      onTap: () {},
      title: Text(user.name),
      leading: CircleAvatar(
        //TODO should be backgrundImage.
        //You can use path to get the User Image.
        backgroundColor: Color(0xFFF48FB1),
      ),
    ),
  );
}
