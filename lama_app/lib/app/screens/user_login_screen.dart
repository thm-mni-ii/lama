import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/user_login_bloc.dart';
import 'package:lama_app/app/event/user_login_event.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/app/state/user_login_state.dart';

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
            return _input(context, null, state.user, screenSize.width);
          }
          if (state is UserLoginFailed) {
            return _input(context, state.error, state.user, screenSize.width);
          }
          if (state is UsersLoaded) {
            return _userListView(state.userList);
          }
          if (state is UserLoginSuccessful) {
            return Container(
              alignment: Alignment(0, 0),
              child: Icon(
                Icons.check,
                color: Colors.green,
                size: 100,
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

Widget _input(BuildContext context, String error, User user, double size) {
  return Column(
    children: [
      Padding(
        child: Row(
          children: [
            CircleAvatar(
              //TODO should be backgrundImage.
              //You can use path to get the User Image.
              backgroundColor: Color(0xFFF48FB1),
              radius: 20,
            ),
            SizedBox(
              width: 15,
            ),
            Text(user.name),
          ],
        ),
        padding: EdgeInsets.fromLTRB(20, 15, 0, 0),
      ),
      TextFormField(
        decoration: InputDecoration(
          icon: Icon(Icons.security),
          hintText: 'Passwort',
          errorText: error,
        ),
        validator: (value) => null,
        onChanged: (value) =>
            context.read<UserLoginBloc>().add(UserLoginChangePass(value)),
        obscureText: true,
      ),
      SizedBox(
        height: 25,
      ),
      ElevatedButton(
        onPressed: () {
          context.read<UserLoginBloc>().add(UserLogin(user, context));
        },
        child: Text('Einloggen'),
        style: ElevatedButton.styleFrom(
          minimumSize: Size(size, 45),
        ),
      ),
      SizedBox(
        height: 15,
      ),
      ElevatedButton(
        onPressed: () {
          context.read<UserLoginBloc>().add(UserLoginAbort());
        },
        child: Text('Abbrechen'),
        style: ElevatedButton.styleFrom(
            minimumSize: Size(size, 45), primary: Colors.red),
      ),
    ],
  );
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

Widget _userListView(List<User> list) {
  return ListView.builder(
    itemCount: list.length,
    itemBuilder: (context, index) {
      return _userCard(list[index]);
    },
  );
}

Widget _userCard(User user) {
  return BlocBuilder<UserLoginBloc, UserLoginState>(
    builder: (context, state) {
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
    },
  );
}
