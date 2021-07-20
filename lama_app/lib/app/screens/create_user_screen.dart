import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//Lama defaults
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';
import 'package:lama_app/util/input_validation.dart';
//Blocs
import 'package:lama_app/app/bloc/create_user_bloc.dart';
//Events
import 'package:lama_app/app/event/create_user_event.dart';
//States
import 'package:lama_app/app/state/create_user_state.dart';

///This file creates the create user screen
///the create user screen provides the function to
///create an admin entering the name and an password
///and grade via dropdown
///
/// * see also
///    [CreateUserBloc]
///    [CreateUserEvent]
///    [CreateUserState]
///
/// Author: L.Kammerer
/// latest Changes: 26.06.2021
class CreateUserScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CreateUserScreenState();
  }
}

class CreateUserScreenState extends State<CreateUserScreen> {
  //[_formKey] should be used to identify every Form in this Screen
  var _formKey = GlobalKey<FormState>();
  //temporary save the value of the Dropdown menu
  String _dropDown = 'Klasse 1';

  @override
  void initState() {
    super.initState();

    ///forcing the [CreateUserBloc] to load all grades
    ///which are needed for the dropdown selection
    BlocProvider.of<CreateUserBloc>(context).add(LoadGrades());
  }

  ///override build methode [StatelessWidget]
  ///
  ///{@param} [BuildContext] as context
  ///
  ///{@return} [Widget] decided by the incoming state of the [CreateUserBloc]
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      //avoid overflow because of the keyboard
      resizeToAvoidBottomInset: false,
      appBar: _bar(screenSize.width / 5),
      body: BlocBuilder<CreateUserBloc, CreateUserState>(
          builder: (context, state) {
        if (state is CreateUserLoaded)
          return _userOptions(context, state.grades);
        if (state is UserPushSuccessfull)

          ///if the User is successfully stored in the Database
          ///the Screen should be pop there for the [CreateUserAbort] event is used
          context.read<CreateUserBloc>().add(CreateUserAbort(context));
        return Center(child: CircularProgressIndicator());
      }),
      floatingActionButton: _userOptionsButtons(context),
    );
  }

  ///(private)
  ///[Columne] with all inputs as [TextFormField] thats needed
  ///for creating an user.
  ///
  ///All changes are made onChange through the [CreateUserBloc] via [User***Change]
  ///to validat the input the [InputValidation] is used.
  ///
  ///{@param} [BuildContext] as context
  ///
  ///{@return} [Widget] with every input as [TextFormField]
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
      padding: EdgeInsets.all(20),
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
                  .read<CreateUserBloc>()
                  .add(UserGradeChange(grades.indexOf(value) + 1));
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

  ///(private)
  ///porvides [AppBar] with default design for Screens used by the Admin
  ///
  ///{@params}
  ///[AppBar] size as double size
  ///
  ///{@return} [AppBar] with generel AdminMenu specific design
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
