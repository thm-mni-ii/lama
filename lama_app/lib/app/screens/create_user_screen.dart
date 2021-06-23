import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/create_user_bloc.dart';
import 'package:lama_app/app/event/create_user_event.dart';
import 'package:lama_app/app/state/create_user_state.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';
import 'package:lama_app/util/input_validation.dart';

class CreateUserScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CreateUserScreenState();
  }
}

class CreateUserScreenState extends State<CreateUserScreen> {
  var _formKey = GlobalKey<FormState>();
  String _dropDown = 'Klasse 1';

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CreateUserBloc>(context).add(LoadGrades());
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _bar(screenSize.width / 5),
      body: BlocBuilder<CreateUserBloc, CreateUserState>(
          builder: (context, state) {
        if (state is CreateUserLoaded)
          return _userOptions(context, state.grades);
        if (state is UserPushSuccessfull)
          context.read<CreateUserBloc>().add(CreateUserAbort(context));
        return Center(child: CircularProgressIndicator());
      }),
      floatingActionButton: _userOptionsButtons(context),
    );
  }

  Widget _userOptions(BuildContext context, List<String> grades) {
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
                return InputValidation.inputUsernameValidation(value);
              },
              onChanged: (value) {
                context.read<CreateUserBloc>().add(UsernameChange(value));
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
                return InputValidation.inputPasswortValidation(value);
              },
              onChanged: (value) {
                context.read<CreateUserBloc>().add(UserPasswortChange(value));
              },
              obscureText: true,
            ),
          ),
          _gradesList(context, grades),
        ],
      ),
    );
  }

  Widget _gradesList(BuildContext context, List<String> grades) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          iconSize: 25,
          items: grades.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: LamaTextTheme.getStyle(
                  fontSize: 20,
                  color: LamaColors.black,
                  monospace: true,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            context
                .read<CreateUserBloc>()
                .add(UserGradeChange(grades.indexOf(value) + 1));
            setState(() {
              _dropDown = value;
            });
          },
          value: _dropDown,
        ),
      ),
    );
  }

  Widget _userOptionsButtons(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: Ink(
            decoration: ShapeDecoration(
              color: LamaColors.greenPrimary,
              shape: CircleBorder(),
            ),
            padding: EdgeInsets.all(7.0),
            child: IconButton(
              icon: Icon(
                Icons.save_rounded,
                size: 25,
              ),
              color: Colors.white,
              tooltip: 'Speichern',
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  context.read<CreateUserBloc>().add(CreateUserPush());
                }
              },
            ),
          ),
        ),
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
              context.read<CreateUserBloc>().add(CreateUserAbort(context));
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
        'Erstelle einen Nutzer',
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
}
