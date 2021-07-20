import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//Lama default
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';
import 'package:lama_app/util/input_validation.dart';
import 'package:lama_app/app/model/user_model.dart';
//Blocs
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/edit_user_bloc.dart';
//Events
import 'package:lama_app/app/event/edit_user_event.dart';
//States
import 'package:lama_app/app/state/edit_user_state.dart';

///This file creates the Edit User Screen
///This Screen provides every option to edit a user or delete the user.
///
///{@important} the [User] needed by the this class is the [User]
///selected by the Admin. However the [User] only needed to provides default values for
///every [User] information that could be changed in this Screen.
///This user should not be changed at any time. Make sure that all
///changes are done through the [EditUserBloc] to  [_changedUser]
///
/// * see also
///    [EditUserBloc]
///    [EditUserEvent]
///    [EditUserState]
///
/// Author: L.Kammerer
/// latest Changes: 15.07.2021
class EditUserScreen extends StatefulWidget {
  //[User] thats selected by the Admin
  final User _user;
  //constructor with the needed attribute [User] as _user that should be edit
  EditUserScreen(this._user);
  @override
  State<StatefulWidget> createState() {
    return EditUserScreenState(_user);
  }
}

///EditUserScreenState provides the state for the [EditUserScreen]
class EditUserScreenState extends State<EditUserScreen> {
  //[_formKey] should be used to identify every Form in this Screen
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Size screenSize;

  ///[User] thats selected by the Admin
  User _user;
  //temporary password for double password validation
  String _pass;
  //List of grades wich are supported in the App
  List<String> _grades = [
    'Klasse 1',
    'Klasse 2',
    'Klasse 3',
    'Klasse 4',
    'Klasse 5',
    'Klasse 6',
  ];
  //temporary save the value of the Dropdown menu
  String _dropDown;

  ///constructor with the needed attribute [User] as _user
  EditUserScreenState(this._user);

  //setting the default value for the _gradesList] by the current grade of [_user]
  @override
  void initState() {
    _dropDown = _grades[_user.grade - 1];
    super.initState();
  }

  ///override build methode [StatelessWidget]
  ///
  ///{@param} [BuildContext] as context
  ///
  ///{@return} a [Widget] decided by the incoming state of the [EditUserBloc]
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
            //avoid overflow because of the keyboard
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

  ///(private)
  ///provides every input that could be change in the user in [Column]
  ///
  ///{@param} [BuildContext] as context
  ///
  ///{@return} centered and spaced [Column] with all inputs
  ///that can be changed in the user
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
              //[TextFormField] to change the Username
              _usernameTextField(context),
              //[TextFormField] to change the Password
              _passwortTextField(context),
              //[TextFormField] to repead the Password for safety
              _passwortTextField2(context),
              //[TextFormField] to change the coins
              _coinsTextField(context),
              //[DropdownButtonHideUnderline] to change the grade
              _gradesList(context, _grades),
              //[ElevatedButton] to delete the user
              _deletUserButoon(context),
            ],
          ),
        ),
      ),
    );
  }

  ///(private)
  ///provides [TextFormField] that changes the Username
  ///
  ///All changes are made onChange through the [EditUserBloc] via [EditUserChangeUsername]
  ///initialValue equals to [_user.name]
  ///labelText: 'Nutzername'
  ///
  ///{@param} [BuildContext] as context
  ///
  ///{@return} [TextFormField]
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

  ///(private)
  ///provides [TextFormField] that saves the value in [_pass]
  ///only used to save the password onChange temporarily for the double Password verification
  ///labelText: 'Password'
  ///
  ///{@param} [BuildContext] as context
  ///
  ///{@return} [TextFormField]
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

  ///(private)
  ///provides [TextFormField] that changes the user password
  ///
  ///All changes are made onChange through the [EditUserBloc] via [EditUserChangePasswort]
  ///Uses [_pass] for the double verification of the password
  ///labelText: 'Password wiederholen'
  ///
  ///{@param} [BuildContext] as context
  ///
  ///{@return} [TextFormField]
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

  ///(private)
  ///provides [TextFormField] that changes the user coins
  ///
  ///All changes are made onChange through the [EditUserBloc] via [EditUserChangeCoins]
  ///initialValue equals to [_user.coins]
  ///labelText: 'Lamamünzen'
  ///
  ///{@param} [BuildContext] as context
  ///
  ///{@return} [TextFormField]
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

  ///(private)
  ///provides [DropdownButtonHideUnderline] to change the user grade
  ///
  ///All changes are made onChange through the [EditUserBloc] via [EditUserChangeGrade]
  ///Also saves the changes in [_dropDown] to change the seen value
  ///initialValue equals to [_grades[_user.grade]]
  ///
  ///{@param}
  ///[BuildContext] as context
  ///Grades that could be selected as List<String> grades
  ///
  ///{@return} [Padding] with [DropdownButtonHideUnderline]
  Widget _gradesList(BuildContext context, List<String> grades) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 100),
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

  ///(private)
  ///provides [ElevatedButton] to leads the view to the delete user check
  ///
  ///leads the view to the delete user check onPressed through the [EditUserBloc] via [EditUserDeleteUserCheck]
  ///
  ///{@param}
  ///[BuildContext] as context
  ///
  ///{@return} [ElevatedButton]
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

  ///(private)
  ///provides [Scaffold] that shows taken changes in comparison to the old values
  ///if the value isn't changed only the old value is seen
  ///With onPressed of an [ElevatedButton] the user can move on.
  ///This [ElevatedButton] triggers an action in the [EditUserBloc] via [EditUserReturn]
  ///
  ///
  ///{@param}
  ///[BuildContext] as context
  ///[EditUserChangeSuccess] (state from EditUserBloc) as state. Used to compare the changed values with the old ones
  ///
  ///{@return} [Scaffold]
  Widget _showChanges(BuildContext context, EditUserChangeSuccess state) {
    ///[passString] is used to show the password.
    ///If no changes are taken the password value of `state.changedUser` should be empty.
    String passString;

    ///The password is set equal to '******' if the password of `state.changedUser` is empty
    if (InputValidation.isEmpty(state.changedUser.password))
      passString = '******';
    else

      ///If the password of `state.changedUser.password` is not empty the passString is set as the following
      ///`state.changedUser.password` greater or equal than 9
      ///the middle part is cuted to '***' but the first and last 3 character are still available
      ///Example: "12345678910" -> 123***910
      passString = state.changedUser.password.length >= 9
          ? state.changedUser.password.substring(0, 3) +
              '***' +
              state.changedUser.password.substring(
                  state.changedUser.password.length - 3,
                  state.changedUser.password.length)
          : state.changedUser.password;

    ///END [passString]
    ///START Scaffold
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
            //Headrow for understanding where the old and new value is seen
            _changesHeadRow('Alt', 'Neu'),
            //Headline for the Username change
            _changesHeadline('Nutzername'),
            //Row that shows the username change
            _changeRow(state.user.name, state.changedUser.name),
            //Headline for the Password change
            _changesHeadline('Password'),
            //Row that shows the Password change
            _changeRow('******', passString),
            //Headline for the coin change
            _changesHeadline('Lamamünzen'),
            //Row that shows the coin change
            _changeRow(state.user.coins, state.changedUser.coins),
            //Headline for the grade change
            _changesHeadline('Klasse'),
            //Row that shows the coin change
            _changeRow(

                ///if the grade isn't changed `state.changedUser.grade` is equal to null
                ///to prevent any issues the `state.user.grade` is used on empty
                _grades[state.user.grade - 1],
                state.changedUser.grade != null
                    ? _grades[state.changedUser.grade - 1]
                    : _grades[state.user.grade - 1]),
            SizedBox(
              height: 15,
            ),
            //ElevatedButton to move on
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

  ///(private)
  ///provides view as row that shows taken changes in comparison to the old values
  ///the oldValue will be compared to the newValue
  ///if both values are equal only the old value is seen
  ///
  ///{@param}
  ///var as oldValue
  ///var as newValue
  ///
  ///{@return} [Padding] with [Stack]
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

  ///(private)
  ///provides headline as [Text] with specific stlye
  ///
  ///{@param}
  ///[String] as str
  ///
  ///{@return} [Text]
  Widget _changesHeadline(String str) {
    return Text(
      str.toString(),
      style:
          LamaTextTheme.getStyle(fontSize: 18, color: LamaColors.bluePrimary),
      textAlign: TextAlign.center,
    );
  }

  ///(private)
  ///provides headline with two [String]s
  ///one of the left side of an arrow and one on the right side
  ///
  ///{@param}
  ///[String] as left for the left [Text]
  ///[String] as right for the right [Text]
  ///
  ///{@return} [Padding] with [Stack]
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

  ///(private)
  ///porvides [Row] with default designed abort and save [Ink] Button
  ///
  ///{@params} [BuildContext] context
  ///
  ///{@return} [Row] with two [Ink] Buttons
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

  ///(private)
  ///porvides [Scaffold] to give the Admin the opportunity to
  ///abort or approve the delete of the selected user.
  ///
  ///One [ElevatedButton] is used to approve the delete of the user
  ///through the [EditUserBloc] via EditUserDeleteUserApprove
  ///The other [ElevatedButton] is used to abort the operation
  ///through the [EditUserBloc] via [EditUserDeleteUserAbort]
  ///
  ///{@params}
  ///[BuildContext] context
  ///double as size for the [AppBar] size
  ///[EditUserDeleteCheck] as state
  ///
  ///{@return} [Scaffold] with two [ElevatedButton] Buttons
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

  ///(private)
  ///porvides [AppBar] with default design for Screens used by the Admin
  ///
  ///{@params}
  ///[AppBar] size as double size
  ///[AppBar] titel as String title
  ///[AppBar] [Color] as colors
  ///
  ///{@return} [AppBar] with generel AdminMenu specific design
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
