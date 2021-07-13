import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/userlist_url_bloc.dart';
import 'package:lama_app/app/event/userlist_url_event.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/app/state/userlist_url_state.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';
import 'package:lama_app/util/input_validation.dart';

import 'admin_menu_screen.dart';

class UserlistUrlScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserlistUrlScreenState();
  }
}

class UserlistUrlScreenState extends State<UserlistUrlScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _url;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AdminUtils.appbar(
          screenSize, LamaColors.bluePrimary, 'Nutzerliste einfügen'),
      body: BlocBuilder<UserlistUrlBloc, UserlistUrlState>(
          builder: (context, state) {
        if (state is UserlistUrlTesting)
          return _loadingWidget('Inhalt wird geprüft und geladen!');
        if (state is UserlistUrlParsingFailed) return _errorWidget(state.error);
        if (state is UserlistUrlParsingSuccessfull)
          return _userList(state.userList);
        return _defaultWidget();
      }),
    );
  }

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

  Widget _userList(List<User> userlist) {
    return Container();
  }

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
