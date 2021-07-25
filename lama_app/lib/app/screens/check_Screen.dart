import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/flutter_svg.dart';
//Lama defaults
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';
//Blocs
import 'package:lama_app/app/bloc/check_screen_bloc.dart';
//Events
import 'package:lama_app/app/event/check_screen_event.dart';
//States
import 'package:lama_app/app/state/check_screen_state.dart';

///This file creates the Check Screen
///Check Screen is the first entry on app start
///This screen ensures that the DSGVO is accepted
///and an Admin User exist
///
/// * see also
///    [CheckScreenBloc]
///    [CheckScreenEvent]
///    [CheckScreenState]
///
/// Author: L.Kammerer
/// latest Changes: 15.07.2021
class CheckScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CheckScreenPage();
  }
}

///CheckScreenPage provides the state for the [CheckScreen]
class CheckScreenPage extends State<CheckScreen> {
  //used to ensure the check if an Admin exist
  bool _checkDone = false;
  @override
  void initState() {
    super.initState();
  }

  ///override build methode [StatelessWidget]
  ///
  ///{@param} [BuildContext] as context
  ///
  ///{@return} [Widget] decided by the incoming state of the [CheckScreenBloc]
  @override
  Widget build(BuildContext context) {
    ///if [_checkDone] is not true the [CheckForAdmin] event is triggert
    ///if the event is triggert [_checkDone] is set to true.
    if (!_checkDone) {
      context.read<CheckScreenBloc>().add(CheckForAdmin(context));
      _checkDone = true;
    }
    return Scaffold(
      body: BlocBuilder<CheckScreenBloc, CheckScreenState>(
        builder: (context, state) {
          ///view for the DSGVO
          ///if the user accept the DSGVO the [DSGVOAccepted] event is triggert
          ///which leads to another state
          if (state is ShowDSGVO) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Datenschutzgrundverordnung'),
                backgroundColor: LamaColors.bluePrimary,
              ),
              body: Column(
                children: [
                  Expanded(child: Markdown(data: state.dsgvo)),
                  ElevatedButton(
                    child: Row(
                      children: [
                        Icon(Icons.check_rounded),
                        SizedBox(width: 10),
                        Text(
                          'Akzeptieren',
                          style: LamaTextTheme.getStyle(fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(50, 60),
                      primary: LamaColors.bluePrimary,
                      shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(0)),
                    ),
                    onPressed: () {
                      context
                          .read<CheckScreenBloc>()
                          .add(DSGVOAccepted(context));
                    },
                  ),
                ],
              ),
            );
          }

          ///provides view which explain why ther should be an admin created
          ///also provides an [ElevatedButton] which triggers the [CreateAdminEvent] event
          ///to switch to the [CreateAdminScreen]
          ///
          /// * see also [CheckScreenBloc]
          if (state is CreateAdmin) {
            return Padding(
              padding: EdgeInsets.only(top: 200, left: 25, right: 25),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      'Für den einwandfreien Gebrauch der Anwendung muss ein Administrator-Konto angelegt werden!',
                      style: LamaTextTheme.getStyle(
                          fontSize: 14, color: LamaColors.black),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 25),
                    Container(
                      width: 250,
                      child: ElevatedButton(
                        child: Row(
                          children: [
                            Icon(Icons.save_sharp),
                            SizedBox(width: 10),
                            Text(
                              'Admin erstellen',
                              style: LamaTextTheme.getStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(50, 50),
                          primary: LamaColors.bluePrimary,
                          shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.circular(0)),
                        ),
                        onPressed: () {
                          context
                              .read<CheckScreenBloc>()
                              .add(CreateAdminEvent(context));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          ///default waiting screen with app icon
          return Container(
            alignment: Alignment.center,
            child: SvgPicture.asset(
              'assets/images/svg/lama_head.svg',
              semanticsLabel: 'LAMA',
            ),
          );
        },
      ),
    );
  }
}
