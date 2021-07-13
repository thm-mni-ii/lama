import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
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
          if (state is UserlistUrlParsingFailed)
            return _errorWidget(state.error);
          if (state is UserlistUrlParsingSuccessfull)
            return _userList(state.userList);
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

  Widget _userCard(User user) {
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

  Widget _userDetails(User user) {
    return Column(
      children: [
        //Password
        Text(
          'Passwort: ' + user.password,
          style: LamaTextTheme.getStyle(
            fontSize: 14,
            color: LamaColors.black,
            monospace: true,
            fontWeight: FontWeight.w500,
          ),
        ),
        //Grade
        Text(
          'Klasse ${user.grade}',
          style: LamaTextTheme.getStyle(
            fontSize: 14,
            color: LamaColors.black,
            monospace: true,
            fontWeight: FontWeight.w500,
          ),
        ),
        //Coins
        Row(
          children: [
            CircleAvatar(
              child: SvgPicture.asset(
                'assets/images/svg/lama_coin.svg',
                semanticsLabel: 'LAMA',
              ),
              radius: 15,
            ),
            Text(
              '${user.coins}',
              style: LamaTextTheme.getStyle(
                fontSize: 14,
                color: LamaColors.black,
                monospace: true,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        )
      ],
    );
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
