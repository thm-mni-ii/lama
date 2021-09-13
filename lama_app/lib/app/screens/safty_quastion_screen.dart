import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//Lama default
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';
import 'package:lama_app/util/input_validation.dart';
import 'package:lama_app/app/model/user_model.dart';
//Blocs
import 'package:lama_app/app/bloc/safty_question_bloc.dart';
//Events
import 'package:lama_app/app/event/safty_quastion_event.dart';

//States
import 'package:lama_app/app/state/safty_question_state.dart';

///This file creates the safty question screen
///This Screen provides the forgot password function
///
///
/// * see also
///    [SaftyQuestionBloc]
///    [SaftyQuestionEvent]
///    [SaftyQuestionState]
///
/// Author: L.Kammerer
/// latest Changes: 13.09.2021
class SaftyQuestionScreen extends StatefulWidget {
  User _user;
  SaftyQuestionScreen(this._user);

  @override
  State<StatefulWidget> createState() {
    return SaftyQuestionScreenState(_user);
  }
}

///UserLoginScreenState provides the state for the [UserLoginScreen]
class SaftyQuestionScreenState extends State<SaftyQuestionScreen> {
  //[_formKey] should be used to identify every Form in this Screen
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  User _user;
  SaftyQuestionScreenState(this._user);

  @override
  void initState() {
    super.initState();
  }

  ///override build methode [StatelessWidget]
  ///
  ///{@param} [BuildContext] as context
  ///
  ///{@return} [Widget] decided by the incoming state of the [SaftyQuestionBloc]
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      //avoid overflow because of the keyboard
      resizeToAvoidBottomInset: false,
      appBar: _bar(screenSize.width / 5),
      body: BlocBuilder<SaftyQuestionBloc, SaftyQuestionState>(
        builder: (context, state) {
          if (!_user.isAdmin) return _userNoAdmin();

          if (state is SaftyQuestionContent) {
            if (InputValidation.isEmpty(state.question))
              return _saftyQuestionNull();
            return _input(context, state, _formKey);
          }
          context.read<SaftyQuestionBloc>().add(SaftyQuestionPull());
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

///(private)
///provides input as [TextFormField] for the safty question
///
///{@params}
///[BuildContext] as context
///[User] as user for default values
///
///{@return} [Widget] decided by the incoming state of the [SaftyQuestionBloc]
Widget _input(BuildContext context, SaftyQuestionContent state,
    GlobalKey<FormState> key) {
  return Form(
    key: key,
    child: Center(
      child: Column(
        children: [
          SizedBox(height: 50),
          Text(state.question,
              textAlign: TextAlign.center,
              style: LamaTextTheme.getStyle(color: LamaColors.black)),
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: TextFormField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'Antwort',
              ),
              validator: (value) =>
                  value == state.answer ? null : 'Eingabe stimmt nicht!',
              onFieldSubmitted: (value) => {
                if (key.currentState.validate())
                  context
                      .read<SaftyQuestionBloc>()
                      .add(SaftyQuestionPush(context, value))
              },
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _saftyQuestionNull() {
  return Center(
    child: Text(
      "Für dieses Konto ist keine Sicherheitsfrage hinterlegt!",
      style: LamaTextTheme.getStyle(fontSize: 14, color: LamaColors.black),
    ),
  );
}

Widget _userNoAdmin() {
  return Center(
    child: Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Text(
        "Wenn du dein Passwort vergessen hast, wende dich an eine Aufsichtsperson!",
        textAlign: TextAlign.center,
        style: LamaTextTheme.getStyle(fontSize: 14, color: LamaColors.black),
      ),
    ),
  );
}

///(private)
///porvides [AppBar] with default design for the safty question screen
///
///{@params}
///[AppBar] size as double size
///
///{@return} [AppBar] with specific design
Widget _bar(double size) {
  return AppBar(
    title: Text('Anmeldung', style: LamaTextTheme.getStyle(fontSize: 18)),
    toolbarHeight: size,
    backgroundColor: LamaColors.bluePrimary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(30),
      ),
    ),
  );
}
