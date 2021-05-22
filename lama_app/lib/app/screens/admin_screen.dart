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
  var _formKey = GlobalKey<FormState>();
  String _dropDown = 'Klasse 1';

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
          if (state is CreateUserState) {
            return _userOptions(context, state);
          }
          if (state is UserPushSuccessfull) {
            context.read<AdminScreenBloc>().add(LoadAllUsers());
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
      floatingActionButton: BlocBuilder<AdminScreenBloc, AdminState>(
        builder: (context, state) {
          if (state is Loaded) {
            return Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                  child: FloatingActionButton(
                    heroTag: "back",
                    backgroundColor: LamaColors.bluePrimary,
                    onPressed: () => {
                      context
                          .read<AdminScreenBloc>()
                          .add(LogoutAdminScreen(context))
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
                        {context.read<AdminScreenBloc>().add(CreateUser())},
                    tooltip: 'Nutzer hinzufügen',
                    child: Icon(Icons.add)),
              ],
              mainAxisAlignment: MainAxisAlignment.end,
            );
          }
          if (state is CreateUserState) {
            return _userOptionsButtons(context);
          }
          return Container();
        },
      ),
    );
  }

  Widget _userOptions(BuildContext context, CreateUserState state) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(25, 10, 25, 0),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'Nutzername',
              ),
              validator: (value) {
                return _emptyValidation(value);
              },
              onChanged: (value) {
                context.read<AdminScreenBloc>().add(UsernameChange(value));
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(25, 25, 25, 0),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'Password',
              ),
              validator: (value) {
                return _emptyValidation(value);
              },
              onChanged: (value) {
                context.read<AdminScreenBloc>().add(UserPasswortChange(value));
              },
              obscureText: true,
            ),
          ),
          _gradesList(context, state.grades),
        ],
      ),
    );
  }

  Widget _gradesList(BuildContext context, List<String> grades) {
    return Padding(
        padding: EdgeInsets.all(20),
        child: DropdownButton<String>(
          items: grades.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: LamaTextTheme.getStyle(
                  fontSize: 16,
                  color: LamaColors.black,
                  monospace: true,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            context
                .read<AdminScreenBloc>()
                .add(UserGradeChange(grades.indexOf(value) + 1));
            setState(() {
              _dropDown = value;
            });
          },
          value: _dropDown,
        ));
  }

  Widget _userOptionsButtons(BuildContext context) {
    return Row(
      children: [
        Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: Ink(
              decoration: ShapeDecoration(
                color: LamaColors.greenAccent,
                shape: CircleBorder(),
              ),
              padding: EdgeInsets.all(7.0),
              child: IconButton(
                icon: Icon(Icons.check_rounded),
                color: Colors.white,
                tooltip: 'Bestätigen',
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    context.read<AdminScreenBloc>().add(CreateUserPush());
                  }
                },
              ),
            )),
        Ink(
          decoration: ShapeDecoration(
            color: LamaColors.redPrimary,
            shape: CircleBorder(),
          ),
          padding: EdgeInsets.all(2.0),
          child: IconButton(
            icon: Icon(Icons.close_rounded),
            color: Colors.white,
            tooltip: 'Abbrechen',
            onPressed: () {
              context.read<AdminScreenBloc>().add(CreateUserAbort());
            },
          ),
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.end,
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
        });
  }

  Widget _userCard(User user) {
    String _nameDisplay = user.isAdmin ? user.name + ' (Admin)' : user.name;
    return BlocBuilder<AdminScreenBloc, AdminState>(
      builder: (context, state) {
        return Card(
          child: ListTile(
            onTap: () {
              context.read<AdminScreenBloc>().add(SelectUser(user));
            },
            title: Text(
              _nameDisplay,
              style: LamaTextTheme.getStyle(
                fontSize: 16,
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

  String _emptyValidation(String value) {
    if (value != null && value != '' && value != ' ') {
      return null;
    } else {
      return 'Dieses Feld darf nicht leer sein!';
    }
  }
}
