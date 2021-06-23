import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/edit_user_bloc.dart';
import 'package:lama_app/app/event/edit_user_event.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/app/state/edit_user_state.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';
import 'package:lama_app/util/input_validation.dart';

class EditUserScreen extends StatefulWidget {
  final User _user;

  EditUserScreen(this._user);
  @override
  State<StatefulWidget> createState() {
    return EditUserScreenState(_user);
  }
}

class EditUserScreenState extends State<EditUserScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Size screenSize;
  //String _dropDown = 'Klasse 1';
  User _user;
  String _pass;
  List<String> _grades = [
    'Klasse 1',
    'Klasse 2',
    'Klasse 3',
    'Klasse 4',
    'Klasse 5',
    'Klasse 6',
  ];
  String _dropDown;

  EditUserScreenState(this._user);

  @override
  void initState() {
    _dropDown = _grades[_user.grade - 1];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return BlocBuilder<EditUserBloc, EditUserState>(
      builder: (context, state) {
        if (state is EditUserDeleteCheck)
          return _deleteUserCheck(context, screenSize.width, state);
        if (state is EditUserChangeSuccess)
          return _showChanges(context, state);
        else {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: _bar(screenSize.width / 5, 'Editiere den Nutzer',
                LamaColors.bluePrimary),
            body: _userEditOptions(context),
            floatingActionButton: _userOptionsButtons(context),
          );
        }
      },
    );
  }

  Widget _userEditOptions(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Form(
        key: _formKey,
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _usernameTextField(context),
              _passwortTextField(context),
              _passwortTextField2(context),
              _coinsTextField(context),
              _gradesList(context, _grades),
              SizedBox(height: 10),
              _deletUserButoon(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _usernameTextField(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Nutzername',
        labelStyle:
            LamaTextTheme.getStyle(color: LamaColors.bluePrimary, fontSize: 14),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: LamaColors.bluePrimary),
        ),
      ),
      initialValue: _user.name,
      validator: (value) => InputValidation.inputUsernameValidation(value),
      onChanged: (value) =>
          {context.read<EditUserBloc>().add(EditUserChangeUsername(value))},
    );
  }

  Widget _passwortTextField(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Password',
        labelStyle:
            LamaTextTheme.getStyle(color: LamaColors.bluePrimary, fontSize: 14),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: LamaColors.bluePrimary),
        ),
      ),
      validator: (value) {
        return InputValidation.isEmpty(value)
            ? null
            : InputValidation.inputPasswortValidation(value);
      },
      onChanged: (value) => {_pass = value},
      obscureText: true,
    );
  }

  Widget _passwortTextField2(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Password wiederholen',
        hintText: 'Password wiederholen',
        labelStyle:
            LamaTextTheme.getStyle(color: LamaColors.bluePrimary, fontSize: 14),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: LamaColors.bluePrimary),
        ),
      ),
      validator: (value) {
        return InputValidation.isEmpty(_pass) && InputValidation.isEmpty(value)
            ? null
            : InputValidation.inputPasswortValidation(value, secondPass: _pass);
      },
      onChanged: (value) =>
          {context.read<EditUserBloc>().add(EditUserChangePasswort(value))},
      obscureText: true,
    );
  }

  Widget _coinsTextField(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Lamamünzen',
        labelStyle:
            LamaTextTheme.getStyle(color: LamaColors.bluePrimary, fontSize: 14),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: LamaColors.bluePrimary),
        ),
      ),
      initialValue: _user.coins.toString(),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
      validator: (value) => InputValidation.inputNumberValidation(value),
      onChanged: (value) => {
        if (InputValidation.inputNumberValidation(value) == null)
          context.read<EditUserBloc>().add(EditUserChangeCoins(value))
      },
    );
  }

  Widget _gradesList(BuildContext context, List<String> grades) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Container(
        padding: EdgeInsets.only(left: 100, right: 100),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: LamaColors.bluePrimary, width: 1),
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
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
                  .read<EditUserBloc>()
                  .add(EditUserChangeGrade(grades.indexOf(value) + 1));
              setState(() {
                _dropDown = value;
              });
            },
            value: _dropDown,
          ),
        ),
      ),
    );
  }

  Widget _deletUserButoon(BuildContext context) {
    return ElevatedButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Nutzer Löschen',
            style: LamaTextTheme.getStyle(fontSize: 14),
          ),
          SizedBox(
            width: 5,
          ),
          Icon(Icons.delete_forever_rounded),
        ],
      ),
      onPressed: () =>
          {context.read<EditUserBloc>().add(EditUserDeleteUserCheck())},
      style: ElevatedButton.styleFrom(
        minimumSize: Size(50, 45),
        primary: LamaColors.redAccent,
      ),
    );
  }

  Widget _showChanges(BuildContext context, EditUserChangeSuccess state) {
    String passString;
    if (InputValidation.isEmpty(state.changedUser.password))
      passString = '******';
    else
      passString = state.changedUser.password.length >= 9
          ? state.changedUser.password.substring(0, 3) +
              '***' +
              state.changedUser.password.substring(
                  state.changedUser.password.length - 3,
                  state.changedUser.password.length)
          : state.changedUser.password;
    return Scaffold(
      appBar: _bar(
        MediaQuery.of(context).size.width / 5,
        'Ihre Änderungen',
        LamaColors.bluePrimary,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
        child: Column(
          children: [
            _changesHeadRow('Alt', 'Neu'),
            _changesHeadline('Nutzername'),
            _changeRow(state.user.name, state.changedUser.name),
            _changesHeadline('Password'),
            _changeRow('******', passString),
            _changesHeadline('Lamamünzen'),
            _changeRow(state.user.coins, state.changedUser.coins),
            _changesHeadline('Klasse'),
            _changeRow(
                _grades[state.user.grade - 1],
                state.changedUser.grade != null
                    ? _grades[state.changedUser.grade - 1]
                    : _grades[state.user.grade - 1]),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Weiter',
                    style: LamaTextTheme.getStyle(fontSize: 14),
                  ),
                  Icon(
                    Icons.arrow_right_rounded,
                    size: 35,
                  ),
                ],
              ),
              onPressed: () =>
                  {context.read<EditUserBloc>().add(EditUserReturn(context))},
              style: ElevatedButton.styleFrom(
                minimumSize: Size(50, 45),
                primary: LamaColors.greenPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _changeRow(var oldValue, var newValue) {
    if (oldValue.toString() != newValue.toString() && newValue != null) {
      return Padding(
        padding: EdgeInsets.only(
            left: screenSize.width / 100 * 20,
            right: screenSize.width / 100 * 20),
        child: Container(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  oldValue.toString(),
                  style: LamaTextTheme.getStyle(
                    fontSize: 16,
                    color: LamaColors.black,
                    monospace: true,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.arrow_right_rounded,
                  size: 35,
                  color: LamaColors.bluePrimary,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  newValue.toString(),
                  style: LamaTextTheme.getStyle(
                    fontSize: 16,
                    color: LamaColors.black,
                    monospace: true,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            oldValue.toString(),
            style: LamaTextTheme.getStyle(
                fontSize: 16, color: LamaColors.black, monospace: true),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }
  }

  Widget _changesHeadline(String str) {
    return Text(
      str.toString(),
      style:
          LamaTextTheme.getStyle(fontSize: 18, color: LamaColors.bluePrimary),
      textAlign: TextAlign.center,
    );
  }

  Widget _changesHeadRow(String left, String right) {
    return Padding(
      padding: EdgeInsets.only(
          left: screenSize.width / 100 * 20,
          right: screenSize.width / 100 * 20),
      child: Container(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                left,
                style: LamaTextTheme.getStyle(
                  fontSize: 16,
                  color: LamaColors.redPrimary,
                  monospace: true,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.arrow_right_rounded,
                size: 35,
                color: LamaColors.bluePrimary,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                right,
                style: LamaTextTheme.getStyle(
                  fontSize: 16,
                  color: LamaColors.bluePrimary,
                  monospace: true,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
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
              icon: Icon(Icons.save, size: 28),
              color: Colors.white,
              tooltip: 'Bestätigen',
              onPressed: () {
                if (_formKey.currentState.validate())
                  context.read<EditUserBloc>().add(EditUserPush());
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
              context.read<EditUserBloc>().add(EditUserAbort(context));
            },
          ),
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.end,
    );
  }

  Widget _deleteUserCheck(
      BuildContext context, double size, EditUserDeleteCheck state) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _bar(size / 5, 'Nutzer löschen', LamaColors.redPrimary),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(7, 0, 7, 15),
              child: Text(
                'Sind Sie sicher, dass Sie diesen Nutzer Löschen möchten?',
                style: LamaTextTheme.getStyle(
                  color: LamaColors.black,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: Icon(Icons.check_rounded),
                  onPressed: () => {
                    context
                        .read<EditUserBloc>()
                        .add(EditUserDeleteUserAbrove(context))
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(150, 45),
                    primary: LamaColors.greenAccent,
                  ),
                ),
                SizedBox(width: 5),
                ElevatedButton(
                  child: Icon(Icons.close_rounded),
                  onPressed: () => {
                    context.read<EditUserBloc>().add(EditUserDeleteUserAbort())
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(150, 45),
                    primary: LamaColors.redAccent,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(7, 25, 7, 25),
              child: Text(
                state.message,
                style: LamaTextTheme.getStyle(
                  monospace: true,
                  color: LamaColors.black,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ));
  }

  Widget _bar(double size, String titel, Color colors) {
    return AppBar(
      title: Text(
        titel,
        style: LamaTextTheme.getStyle(fontSize: 18),
      ),
      toolbarHeight: size,
      backgroundColor: colors,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
    );
  }
}
