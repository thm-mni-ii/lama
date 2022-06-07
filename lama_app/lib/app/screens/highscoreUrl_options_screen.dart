import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lama_app/app/event/highscoreUrl_screen_event.dart';
import 'package:lama_app/app/model/user_model.dart';

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

///This file creates the Highscroe Url Screen
///This Screen provides an option to save an url for Highscore upload and
///change the user permission
///
///
///{@important} the url given via input should be validated with the
///[InputValidation] to prevent any Issue with Exceptions
///
/// * see also
///    [HighscoreUrlScreenBloc]
///    [HighscoreUrlScreenEvent]
///    [HighscoreUrlScreenState]
///
/// Author: L.Kammerer
/// latest Changes: 21.09.2021
class HighscoreUrlOptionScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HighscoreUrlOptionScreenState();
  }
}

///UserlistUrlScreenState provides the state for the [UserlistUrlScreen]
class HighscoreUrlOptionScreenState extends State<HighscoreUrlOptionScreen> {
  //[_formKey] should be used to identify every Form in this Screen
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //temporary url to prevent losing the url on error states
  String _url;
  //used to store the stats of all true or at least one false
  bool _allPermissionValue = false;
  //store all changes to all users. Is used to apply this changes via [WillPopScope]
  List<User> _changedUserList = [];

  @override
  void initState() {
    super.initState();
  }

  ///override build methode [StatelessWidget]
  ///
  ///{@param} [BuildContext] as context
  ///
  ///{@return} [Widget] decided by the incoming state of the [HighscoreUrlScreenBloc]
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      //avoid overflow because of the keyboard
      resizeToAvoidBottomInset: false,
      appBar: AdminUtils.appbar(
          screenSize, LamaColors.bluePrimary, 'Highscore-URL Einstellungen'),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, _changedUserList);
          return null;
        },
        child: BlocBuilder<HighscoreUrlScreenBloc, HighscoreUrlScreenState>(
            builder: (context, state) {
          if (state is HighscoreUrlPullState) {
            _changedUserList = state.userList;
            _url = state.currentUrl;
            _setAllPermissionValue();
            return Column(
              children: [
                _headline("Highscore-URL einfügen"),
                Padding(
                  padding: EdgeInsets.only(right: 25, left: 25),
                  child: _inputFields(context),
                ),
                _headline("Erlaubnis der Nutzer"),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: _listButtons(),
                ),
                _userList(_changedUserList),
              ],
            );
          }
          context.read<HighscoreUrlScreenBloc>().add(HighscoreUrlPullEvent());
          return Center(child: CircularProgressIndicator());
        }),
      ),
    );
  }

  ///(private)
  ///is used to input an url
  ///
  ///{@important} the input should be saved in local
  ///variable to avoid lost on error. The url that is used for the https request
  ///is stored in [HighscoreUrlScreenBloc]. The onChanged is used to send the
  ///[TextFormField] value through [HighscoreUrlScreenBloc] via [HighscoreUrlChangeEvent]
  ///
  ///{@param} [BuildContext] context
  ///
  ///{@return} [Form] with [TextFormField] to provide input with validation
  Widget _inputFields(BuildContext context) {
    return Form(
      key: _formKey,
      child: TextFormField(
        textInputAction: TextInputAction.done,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: 'https://beispiel.de/',
        ),
        initialValue: _url,
        onChanged: (value) {
          _url = value;
          context
              .read<HighscoreUrlScreenBloc>()
              .add(HighscoreUrlChangeEvent(value));
        },
        validator: (value) => InputValidation.inputURLValidation(value),
        onFieldSubmitted: (value) => {
          if (_formKey.currentState.validate())
            {
              context
                  .read<HighscoreUrlScreenBloc>()
                  .add(HighscoreUrlPushEvent())
            }
        },
      ),
    );
  }

  ///(private)
  ///is used for headlines
  ///
  ///{@param} headline as [String] headline
  ///
  ///{@return} [Align] with [Text]
  Widget _headline(String headline) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.only(top: 20),
        child: Text(
          headline,
          style: LamaTextTheme.getStyle(
            fontSize: 12,
            color: LamaColors.bluePrimary,
          ),
        ),
      ),
    );
  }

  ///(private)
  ///is used to provide Buttons to reset alle changes or select all
  ///
  ///
  ///{@return} [Row] with [Buttons]
  Widget _listButtons() {
    return Stack(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            label: Text(
              "Zurücksetzten",
              style: LamaTextTheme.getStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            icon: Icon(Icons.replay_rounded, color: LamaColors.white),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(50, 45),
              primary: LamaColors.bluePrimary,
              shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(0)),
            ),
            onPressed: () {
              context
                  .read<HighscoreUrlScreenBloc>()
                  .add(HighscoreUrlReloadEvent());
            },
          ),
        ),
        SizedBox(
          width: 90,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            label: Text(
              "Alle",
              style: LamaTextTheme.getStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            icon: _allPermissionValue
                ? Icon(Icons.close_outlined, color: LamaColors.white)
                : Icon(Icons.check_box_rounded, color: LamaColors.white),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(50, 45),
              primary: _allPermissionValue
                  ? LamaColors.redPrimary
                  : LamaColors.greenPrimary,
              shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(0)),
            ),
            onPressed: () {
              setState(() {
                _changedUserList.forEach((user) {
                  user.highscorePermission = _allPermissionValue ? false : true;
                });
              });
            },
          ),
        ),
      ],
    );
  }

  ///(private)
  ///provides [ListView] for alle [User]s, except admins
  ///
  ///{@return} [ListView] with all users via [_userCard]
  Widget _userList(List<User> userlist) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: 3, right: 3),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: userlist.length,
          itemBuilder: (context, index) {
            return _userCard(userlist[index]);
          },
        ),
      ),
    );
  }

  ///(private)
  ///used to display an user with username and avatar as
  ///[Card] with [ListTile]. onTap triggers the [SelectUser] event.
  ///
  ///{@param} [User] as user that should be displayed
  Widget _userCard(User user) {
    ///attache '(Admin)' to the username if the user is an Admin
    return BlocBuilder<HighscoreUrlScreenBloc, HighscoreUrlScreenState>(
      builder: (context, state) {
        return Card(
          child: ListTile(
            onTap: () {
              setState(() {
                int indexOf = _changedUserList.indexOf(user);
                if (_changedUserList[indexOf].highscorePermission) {
                  _changedUserList[indexOf].highscorePermission = false;
                  user.highscorePermission = false;
                } else {
                  _changedUserList[indexOf].highscorePermission = true;
                  user.highscorePermission = true;
                }
              });
            },
            title: Text(
              user.name,
              style: LamaTextTheme.getStyle(
                fontSize: 20,
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
            trailing: user.highscorePermission
                ? Icon(Icons.check_box_rounded, color: LamaColors.greenPrimary)
                : Icon(Icons.close_outlined, color: LamaColors.redPrimary),
          ),
        );
      },
    );
  }

  void _setAllPermissionValue() {
    for (int i = 0; i < _changedUserList.length; i++) {
      if (!_changedUserList[i].highscorePermission) {
        _allPermissionValue = false;
        return;
      }
    }
    _allPermissionValue = true;
  }
}
