import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_manage/widgets/new_tasksets.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_manage/widgets/taskset_expansion_tile_widget.dart';
import 'package:lama_app/app/screens/admin_menu_folder/widgets/custom_appbar.dart';
import 'package:lama_app/app/screens/taskset_option_screen.dart';
// blocs

//Lama default
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';

import '../../../../bloc/taskset_options_bloc.dart';

/// Author: N. Soethe, Tim Steinmüller
/// latest Changes: 09.06.2022

class TasksetManageScreen extends StatefulWidget {
  static const routeName = "/tasksetmanagescreen";

  @override
  State<TasksetManageScreen> createState() => _TasksetManageScreenState();
}

class _TasksetManageScreenState extends State<TasksetManageScreen> {
  int _currentPageIndex = 0;

  Widget screenOfNavigator(int index) {
    switch (index) {
      case 0:
        return TasksetExpansionTileWidget(isAll: true);
      case 1:
        return TasksetExpansionTileWidget(isAll: false);
      case 2:
        return NewTasksets();
      default:
        return Placeholder();
    }
  }

  String getNameOfScreen() {
    switch (_currentPageIndex) {
      case 0:
        return "Alle Tasksets";
      case 1:
        return "Freigegebene Tasksets";
      case 2:
        return "Create new Taskset";
      default:
        return "Upsi";
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => TasksetOptionsBloc(),
      child: Scaffold(
        resizeToAvoidBottomInset: false, //oder scrollable
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (BuildContext context) => TasksetOptionsBloc(),
                    child: OptionTaskScreen(),
                  ),
                ),
              ),icon: Icon(Icons.import_export_rounded),
            ),
          ],
          title: Text(
            getNameOfScreen(),
            style: LamaTextTheme.getStyle(fontSize: 18),
          ),
          toolbarHeight: screenSize.width / 5,
          backgroundColor: LamaColors.bluePrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
        ),
        body: screenOfNavigator(_currentPageIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.workspaces_rounded),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.text_snippet_sharp),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: "",
            ),
          ],
          onTap: (int pos) => setState(() => _currentPageIndex = pos),
          currentIndex: _currentPageIndex,
        ),
      ),
    );
  }
}
