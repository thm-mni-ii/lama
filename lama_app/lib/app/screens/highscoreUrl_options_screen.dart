import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//Lama default
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';
import 'package:lama_app/util/input_validation.dart';
import 'admin_menu_screen.dart';
//Blocs
import 'package:lama_app/app/bloc/highscoreUrl_screen_bloc.dart';
//Events

//States
import 'package:lama_app/app/state/highscoreUrl_screen_state.dart';

///This file creates the Userlist Url Screen
///This Screen provides an option to save a bunch of users via link input
///
///
///{@important} the url given via input should be validated with the
///[InputValidation] to prevent any Issue with Exceptions
///
/// * see also
///    [AdminSettingsBloc]
///    [AdminSettingsEvent]
///    [AdminSettingsState]
///
/// Author: L.Kammerer
/// latest Changes: 17.07.2021
class AdminSettingsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AdminSettingsScreenState();
  }
}

///UserlistUrlScreenState provides the state for the [UserlistUrlScreen]
class AdminSettingsScreenState extends State<AdminSettingsScreen> {
  //[_formKey] should be used to identify every Form in this Screen
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //temporary url to prevent losing the url on error states
  String _url;

  @override
  void initState() {
    super.initState();
  }

  ///override build methode [StatelessWidget]
  ///
  ///{@param} [BuildContext] as context
  ///
  ///{@return} [Widget] decided by the incoming state of the [UserlistUrlBloc]
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      //avoid overflow because of the keyboard
      resizeToAvoidBottomInset: false,
      appBar: AdminUtils.appbar(
          screenSize, LamaColors.bluePrimary, 'Nutzerliste einfügen'),
      body: BlocBuilder<HighscoreUrlScreenBloc, HighscoreUrlScreenState>(
          builder: (context, state) {
        return Text("Settings blabla");
      }),
    );
  }
}
