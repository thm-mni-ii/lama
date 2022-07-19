import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_manage/widgets/new_tasksets.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_manage/widgets/taskset_expansion_tile_widget.dart';
import 'package:lama_app/app/screens/admin_menu_folder/widgets/custom_appbar.dart';
// blocs

//Lama default
import 'package:lama_app/util/LamaColors.dart';

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

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    // ?? manage block auf höchste ebene überall relevant! wenn tasksets geloaded werden wird wrid der block initial befüllt

    return BlocProvider(
      create: (context) => TasksetOptionsBloc(),
      child: Scaffold(
        appBar: CustomAppbar(
          size: screenSize.width / 5,
          titel: "Meine erstellten Tasks",
          color: LamaColors.bluePrimary,
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
