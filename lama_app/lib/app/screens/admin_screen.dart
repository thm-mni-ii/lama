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
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AdminScreenBloc>(context).add(LoadAllUsers());
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    // TODO: implement build
    return Scaffold(
      appBar: _bar(screenSize.width / 5),
      body: BlocBuilder<AdminScreenBloc, AdminState>(
        builder: (context, state) {
          if (state is Loaded) {
            return _userListView(state.userList);
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
