import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/edit_user_bloc.dart';
import 'package:lama_app/app/event/edit_user_event.dart';
import 'package:lama_app/app/state/edit_user_state.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';

class EditUserScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EditUserScreenState();
  }
}

class EditUserScreenState extends State<EditUserScreen> {
  var _formKey = GlobalKey<FormState>();
  //String _dropDown = 'Klasse 1';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _bar(screenSize.width / 5),
      body: BlocBuilder<EditUserBloc, EditUserState>(builder: (context, state) {
        return _userEditOptions(context);
      }),
      floatingActionButton: _userOptionsButtons(context),
    );
  }

  Widget _userEditOptions(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Nutzer Löschen'),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(Icons.delete_forever_rounded),
                ],
              ),
              onPressed: () => {},
              style: ElevatedButton.styleFrom(
                minimumSize: Size(50, 45),
                primary: LamaColors.redAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _userOptionsButtons(BuildContext context) {
    return Row(
      children: [
        Padding(
            padding: EdgeInsets.only(right: 10),
            child: Ink(
              decoration: ShapeDecoration(
                color: LamaColors.greenAccent,
                shape: CircleBorder(),
              ),
              padding: EdgeInsets.all(7.0),
              child: IconButton(
                icon: Icon(Icons.check_rounded),
                color: Colors.white,
                tooltip: 'Bestätigen',
                onPressed: () {
                  //if (_formKey.currentState.validate()) {
                  //context.read<EditUserBloc>().add(EditUserPush());
                  //}
                },
              ),
            )),
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

  Widget _bar(double size) {
    return AppBar(
      title: Text(
        'Editiere den Nutzer',
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
