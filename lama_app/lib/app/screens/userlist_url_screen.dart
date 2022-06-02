import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
//Lama default
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';
import 'package:lama_app/util/input_validation.dart';
import 'admin_menu_screen.dart';
//Blocs
import 'package:lama_app/app/bloc/userlist_url_bloc.dart';
//Events
import 'package:lama_app/app/event/userlist_url_event.dart';
//States
import 'package:lama_app/app/state/userlist_url_state.dart';
import 'package:lama_app/app/model/user_model.dart';

///This file creates the Userlist Url Screen
///This Screen provides an option to save a bunch of users via link input
///
///
///{@important} the url given via input should be validated with the
///[InputValidation] to prevent any Issue with Exceptions
///
/// * see also
///    [UserlistUrlBloc]
///    [UserlistUrlEvent]
///    [UserlistUrlState]
///
/// Author: L.Kammerer
/// latest Changes: 17.07.2021
class UserlistUrlScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserlistUrlScreenState();
  }
}

///UserlistUrlScreenState provides the state for the [UserlistUrlScreen]
class UserlistUrlScreenState extends State<UserlistUrlScreen> {
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
        body: BlocBuilder<UserlistUrlBloc, UserlistUrlState>(
            builder: (context, state) {
          if (state is UserlistUrlTesting)
            return _loadingWidget('Inhalt wird geprüft und geladen!');
          if (state is UserlistUrlParsingFailed)
            return _errorWidget(state.error);
          if (state is UserlistUrlParsingSuccessfull)
            return _userList(state.userList);
          if (state is UserlistUrlInsertSuccess) return _insertSuccessWidget();
          return _defaultWidget();
        }),
        floatingActionButton: BlocBuilder<UserlistUrlBloc, UserlistUrlState>(
          builder: (contextB, state) {
            if (state is UserlistUrlParsingSuccessfull)
              return AdminUtils.saveAboardButtons(
                  () =>
                      context.read<UserlistUrlBloc>().add(UserlistInsertList()),
                  () => context.read<UserlistUrlBloc>().add(UserlistAbort()));
            return Container();
          },
        ));
  }

  ///(private)
  ///defines default view for the [UserlistUrlScreen]
  ///
  ///{@return} [Padding] with [Wrap] and url input via [_inputFields]
  Widget _defaultWidget() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Wrap(
        children: [
          Center(
            child: Icon(
              Icons.assignment_ind_outlined,
              color: LamaColors.bluePrimary,
              size: 30,
            ),
          ),
          _headline('Nutzerlisten URL eingeben'),
          _inputFields(context),
        ],
      ),
    );
  }

  ///(private)
  ///provides [ListView] for alle [User]s
  ///
  ///{@return} [ListView] with all users via [_userCard]
  Widget _userList(List<User> userlist) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: ListView.builder(
        itemCount: userlist.length,
        itemBuilder: (context, index) {
          return _userCard(userlist[index]);
        },
      ),
    );
  }

  ///(private)
  ///shows [User] with avatar and username
  ///
  ///{@return} [Widget] with [CircleAvatar] with [User] avatar and username
  //TODO Show more details of the users
  Widget _userCard(User user) {
    ///attache '(Admin)' to the username if the user is an Admin
    String _nameDisplay = user.isAdmin ? user.name + ' (Admin)' : user.name;
    return Padding(
      padding: EdgeInsets.all(5),
      child: Row(
        children: [
          //User Avatar
          CircleAvatar(
            child: SvgPicture.asset(
              'assets/images/svg/avatars/${user.avatar}.svg',
              semanticsLabel: 'LAMA',
            ),
            radius: 25,
          ),
          SizedBox(width: 15),
          Column(
            children: [
              //Name
              Text(
                _nameDisplay,
                style: LamaTextTheme.getStyle(
                  fontSize: 20,
                  color: LamaColors.black,
                  monospace: true,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  ///(private)
  ///is used to show an successfull insert of all [User]s
  ///
  ///
  ///{@return} [Widget] like [_defaultWidget] but with an success icon and message
  Widget _insertSuccessWidget() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Wrap(
        children: [
          Center(
            child: Icon(
              Icons.assignment_ind_outlined,
              color: LamaColors.bluePrimary,
              size: 30,
            ),
          ),
          _headline('Nutzerlisten URL eingeben'),
          _inputFields(context),
          Padding(
            padding: EdgeInsets.only(top: 60, bottom: 10),
            child: Center(
              child: Icon(
                Icons.check_circle_outline_rounded,
                color: LamaColors.greenPrimary,
                size: 80,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Text(
                'Eingabe erfolgreich!',
                style: LamaTextTheme.getStyle(
                  fontSize: 14,
                  color: LamaColors.greenPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///(private)
  ///is used to show an specific loading state to
  ///provide loading information to the App user
  ///view more like [_defaultWidget] but without [_inputFields]
  ///
  ///{@param} waiting message as [String] text
  ///
  ///{@return} [Widget] with waiting message and [Icons].watch_later_sharp (clock)
  Widget _loadingWidget(String text) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Wrap(
        children: [
          Center(
            child: Icon(
              Icons.assignment_ind_outlined,
              color: LamaColors.bluePrimary,
              size: 30,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 60, bottom: 10),
            child: Center(
              child: Icon(
                Icons.watch_later_sharp,
                color: LamaColors.bluePrimary,
                size: 65,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Text(
                text,
                style: LamaTextTheme.getStyle(
                  fontSize: 12,
                  color: LamaColors.bluePrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///(private)
  ///is used to show an specific error to the App user
  ///
  ///{@param} error message as [String] error
  ///
  ///{@return} [Widget] like [_defaultWidget] but with specific error message and
  ///alert [Icons].warning_amber_sharp
  Widget _errorWidget(String error) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Wrap(
        children: [
          Center(
            child: Icon(
              Icons.assignment_ind_outlined,
              color: LamaColors.bluePrimary,
              size: 30,
            ),
          ),
          _headline('Nutzerlisten URL eingeben'),
          _inputFields(context),
          Padding(
            padding: EdgeInsets.only(top: 60, bottom: 10),
            child: Center(
              child: Icon(
                Icons.warning_amber_sharp,
                color: LamaColors.redPrimary,
                size: 65,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Text(
                error,
                style: LamaTextTheme.getStyle(
                  fontSize: 12,
                  color: LamaColors.redPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///(private)
  ///is used to input an url
  ///
  ///{@important} the input should be saved in local
  ///variable to avoid lost on error. The url that is used for the https request
  ///is stored in [UserlistUrlBloc]. The onChanged is used to send the
  ///[TextFormField] value through [UserlistUrlBloc] via [UserlistUrlChangeUrl]
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
          hintText: 'https://beispiel.de/nutzerliste.json',
        ),
        initialValue: _url,
        onChanged: (value) {
          context.read<UserlistUrlBloc>().add(UserlistUrlChangeUrl(value));
          _url = value;
        },
        validator: (value) => InputValidation.isEmpty(value)
            ? 'Feld darf nicht leer sein!'
            : null,
        onFieldSubmitted: (value) => {
          if (_formKey.currentState.validate())
            {
              context.read<UserlistUrlBloc>().add(UserlistParseUrl()),
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
}
