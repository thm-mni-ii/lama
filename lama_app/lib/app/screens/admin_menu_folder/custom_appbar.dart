import 'package:flutter/material.dart';
import 'package:lama_app/util/LamaTextTheme.dart';

/// Author: T. Steinmüller
/// latest Changes: 08.06.2022
///
///porvides [AppBar] with default design for Screens used by the Admin
///
///{@params}
///[AppBar] size as double size
///[AppBar] color of background as Color (LamaColors)
///
///{@return} [AppBar] with generel AdminMenu specific design
class CustomAppbar extends StatelessWidget with PreferredSizeWidget {
  final String titel;
  final double size;
  final Color color;
  const CustomAppbar({
    Key key,
    @required this.titel,
    @required this.size,
    @required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        titel,
        style: LamaTextTheme.getStyle(fontSize: 18),
      ),
      toolbarHeight: size,
      backgroundColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
