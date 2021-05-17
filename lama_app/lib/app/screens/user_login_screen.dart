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
  String _pass;
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
            return Column(
              children: [
                _userCard(state.user),
                TextFormField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.security),
                    hintText: 'Passwort',
                  ),
                  validator: (value) => null,
                  onChanged: (value) => this._pass = value,
                  obscureText: true,
                ),
                SizedBox(
                  height: 25,
                ),
                ElevatedButton(
                  onPressed: () {
                    context
                        .read<UserLoginBloc>()
                        .add(UserLogin(state.user, _pass, context));
                    _pass = null;
                  },
                  child: Text('Einloggen'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(screenSize.width, 45),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () {
                    _pass = null;
                    context.read<UserLoginBloc>().add(UserLoginAbort());
                  },
                  child: Text('Abbrechen'),
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(screenSize.width, 45),
                      primary: Colors.red),
                ),
              ],
            );
          }
          if (state is UserLoginFailed) {
            _pass = null;
            return Column(
              children: [
                _userCard(state.user),
                TextFormField(
                  decoration: InputDecoration(
                      icon: Icon(Icons.security),
                      hintText: 'Passwort',
                      errorText: state.error),
                  validator: (value) => null,
                  onChanged: (value) => this._pass = value,
                  obscureText: true,
                ),
                SizedBox(
                  height: 25,
                ),
                ElevatedButton(
                  onPressed: () {
                    context
                        .read<UserLoginBloc>()
                        .add(UserLogin(state.user, _pass, context));
                  },
                  child: Text('Einloggen'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(screenSize.width, 45),
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
                      minimumSize: Size(screenSize.width, 45),
                      primary: Colors.red),
                ),
              ],
            );
          }
          if (state is UsersLoaded) {
            _pass = null;
            return _userListView(state.userList);
          }
          if (state is UserLoginSuccessful) {
            _pass = null;
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
