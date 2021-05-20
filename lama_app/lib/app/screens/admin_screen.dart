import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/admin_screen_bloc.dart';
import 'package:lama_app/app/event/admin_screen_event.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/app/state/admin_state.dart';

class AdminScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AdminScreenState();
  }
}

class AdminScreenState extends State<AdminScreen> {
  var _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AdminScreenBloc>(context).add(LoadAllUsers());
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: _bar(screenSize.width / 5),
      body: BlocBuilder<AdminScreenBloc, AdminState>(
        builder: (context, state) {
          if (state is Loaded) {
            return _userListView(state.userList);
          }
          if (state is CreateUserState) {
            return _userOptions(context, state);
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: BlocBuilder<AdminScreenBloc, AdminState>(
        builder: (context, state) {
          if (state is Loaded) {
            return FloatingActionButton(
              onPressed: () =>
                  {context.read<AdminScreenBloc>().add(CreateUser())},
              tooltip: 'Nutzer hinzufügen',
              child: Icon(Icons.add),
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
          Expanded(child: _gradesList(context, state.grades))
        ],
      ),
    );
  }

  Widget _gradesList(BuildContext context, List<String> grades) {
    return ListView.builder(
      //scrollDirection: Axis.horizontal,
      itemCount: grades.length,
      itemBuilder: (context, index) {
        return _gradesListElement(context, grades[index], index);
      },
    );
  }

  Widget _gradesListElement(BuildContext context, String grade, int index) {
    return Card(
      child: ListTile(
        onTap: () {
          print(index);
        },
        title: Text(grade),
      ),
    );
  }

  Widget _userOptionsButtons(BuildContext context) {
    return Row(
      children: [
        Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: Ink(
              decoration: ShapeDecoration(
                color: Colors.green,
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
            color: Colors.red,
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
      title: Text('Nutzerverwaltung'),
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
    return BlocBuilder<AdminScreenBloc, AdminState>(
      builder: (context, state) {
        return Card(
          child: ListTile(
            onTap: () {
              context.read<AdminScreenBloc>().add(SelectUser(user));
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

  String _emptyValidation(String value) {
    if (value != null && value != '' && value != ' ') {
      return null;
    } else {
      return 'Dieses Feld darf nicht leer sein!';
    }
  }
}
