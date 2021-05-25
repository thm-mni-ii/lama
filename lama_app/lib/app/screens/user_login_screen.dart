import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lama_app/app/bloc/user_login_bloc.dart';
import 'package:lama_app/app/event/user_login_event.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/app/state/user_login_state.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';
import 'package:lama_app/util/input_validation.dart';

class UserLoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserSelectionState();
  }
}

class UserSelectionState extends State<UserLoginScreen> {
  var _formKey = GlobalKey<FormState>();
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
            return _input(
                context, null, state.user, screenSize.width, _formKey);
          }
          if (state is UserLoginFailed) {
            return _input(
                context, state.error, state.user, screenSize.width, _formKey);
          }
          if (state is UsersLoaded) {
            return _userListView(state.userList);
          }
          if (state is UserLoginSuccessful) {
            return Container(
              alignment: Alignment(0, 0),
              child: Icon(
                Icons.check,
                color: LamaColors.greenAccent,
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

Widget _input(BuildContext context, String error, User user, double size,
    GlobalKey<FormState> key) {
  String _nameDisplay = user.isAdmin ? user.name + ' (Admin)' : user.name;
  return Form(
    key: key,
    child: Column(
      children: [
        Padding(
          child: Row(
            children: [
              CircleAvatar(
                child: SvgPicture.asset(
                  'assets/images/svg/avatars/${user.avatar}.svg',
                  semanticsLabel: 'LAMA',
                ),
                radius: 25,
                backgroundColor: LamaColors.mainPink,
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                _nameDisplay,
                style: LamaTextTheme.getStyle(
                  fontSize: 20,
                  color: LamaColors.black,
                  monospace: true,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
        ),
        TextFormField(
          decoration: InputDecoration(
            icon: Icon(Icons.security),
            hintText: 'Passwort',
            errorText: error,
          ),
          validator: (value) => InputValidation.isEmpty(value)
              ? 'Eingabe darf nicht leer sein!'
              : null,
          onChanged: (value) =>
              context.read<UserLoginBloc>().add(UserLoginChangePass(value)),
          obscureText: true,
        ),
        SizedBox(
          height: 25,
        ),
        ElevatedButton(
          onPressed: () {
            if (key.currentState.validate())
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
    ),
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
