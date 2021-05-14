import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lama_app/app/bloc/check_screen_bloc.dart';
import 'package:lama_app/app/event/check_screen_event.dart';
import 'package:lama_app/app/state/check_screen_state.dart';

class CheckScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CheckScreenPage();
  }
}

class CheckScreenPage extends State<CheckScreen> {
  bool _checkDone = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!_checkDone)
      context.read<CheckScreenBloc>().add(CheckForAdmin(context));
    return Scaffold(
      body: BlocBuilder<CheckScreenBloc, CheckScreenState>(
        builder: (context, state) {
          if (state is ShowDSGVO) {
            return Scaffold(
              appBar: AppBar(title: Text('Datenschutzgrunderordnung')),
              body: Column(
                children: [
                  Expanded(child: Markdown(data: state.dsgvo)),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<CheckScreenBloc>()
                          .add(DSGVOAccepted(context));
                    },
                    child: Text('Annehmen'),
                    style: ElevatedButton.styleFrom(minimumSize: Size(400, 45)),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            );
          }
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
