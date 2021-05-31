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
  //String _dropDown = 'Klasse 1';
  User _user;

  EditUserScreenState(this._user);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return BlocBuilder<EditUserBloc, EditUserState>(
      builder: (context, state) {
        if (state is EditUserDeleteCheck)
          return _deleteUserCheck(context, screenSize.width, state);
        if (state is EditUserChangeSuccess)
          return _showChanges(context, state);
        else {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: _bar(screenSize.width / 5),
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
          child: _userTextForms(context),
        ),
      ),
    );
  }

  Widget _userTextForms(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Lamamünzen',
            labelStyle: LamaTextTheme.getStyle(
                color: LamaColors.bluePrimary, fontSize: 14),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: LamaColors.bluePrimary),
            ),
          ),
          initialValue: _user.coins.toString(),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
          validator: (value) => InputValidation.isEmpty(value)
              ? 'Eingabe darf nicht leer sein!'
              : null,
          onChanged: (value) =>
              {context.read<EditUserBloc>().add(EditUserChangeCoins(value))},
        ),
        SizedBox(height: 10),
        ElevatedButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Nutzer Löschen'),
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
        ),
      ],
    );
  }

  Widget _showChanges(BuildContext context, EditUserChangeSuccess state) {
    return Column(
      children: [
        Text('Was: ${state.user.coins} => Is: ${state.changedUser.coins}'),
        ElevatedButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Weiter'),
              SizedBox(
                width: 5,
              ),
              Icon(Icons.delete_forever_rounded),
            ],
          ),
          onPressed: () =>
              {context.read<EditUserBloc>().add(EditUserReturn(context))},
          style: ElevatedButton.styleFrom(
            minimumSize: Size(50, 45),
            primary: LamaColors.redAccent,
          ),
        ),
      ],
    );
  }

  Widget _userOptionsButtons(BuildContext context) {
    return Row(
      children: [
        Padding(
            padding: EdgeInsets.only(right: 10),
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
                  if (_formKey.currentState.validate())
                    context.read<EditUserBloc>().add(EditUserPush());
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
        appBar: _bar(size / 5),
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

  Widget _bar(double size) {
    return AppBar(
      title: Text(
        'Editiere den Nutzer',
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
