import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/user_login_bloc.dart';
import 'package:lama_app/app/event/user_login_event.dart';
import 'package:lama_app/app/state/user_login_state.dart';
import 'package:lama_app/app/user.dart';

class UserLoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserSelectionState();
  }
}

class UserSelectionState extends State<UserLoginScreen> {
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
          if (state is UserSelected) {
            return _userCard(state.user);
          }
          if (state is UsersLoaded) {
            return _userListView(state.userList);
          }
          return Text('Uppsie');
        },
      ),
    );
  }
}

Widget _bar(double size) {
  return AppBar(
    title: Text('Nutzerauswahl'),
    toolbarHeight: size,
    backgroundColor: Color.fromARGB(255, 253, 74, 111),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(30),
      ),
    ),
  );
}

Widget _passwortInput() {
  return TextFormField(
    decoration: InputDecoration(
      icon: Icon(Icons.security),
      hintText: 'Passwort',
    ),
    validator: (value) => null,
  );
}

Widget _userListView(List<User> list) {
  return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return _userCard(list[index]);
      });
}

Widget _userCard(User user) {
  return BlocBuilder<UserLoginBloc, UserLoginState>(builder: (context, state) {
    return Card(
      child: ListTile(
        onTap: () {
          context.read<UserLoginBloc>().add(SelectUser(user));
        },
        title: Text(user.name),
        leading: CircleAvatar(
          //TODO should be backgrundImage.
          //You can use path to get the User Image.
          backgroundColor: Color(0xFFF48FB1),
        ),
      ),
    );
  });
}
