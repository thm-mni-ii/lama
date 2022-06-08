import 'package:flutter/material.dart';

/// Author: T. Steinmüller
/// latest Changes: 08.06.2022
class TasksetExpansionTileWidget extends StatelessWidget {
  final String classString;
  const TasksetExpansionTileWidget({
    Key key,
    @required this.classString,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(classString),
      children: [
        Card(
          child: Row(
            children: [
              Text("data"),
              IconButton(onPressed: () {}, icon: Icon(Icons.share)),
              IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
              IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
            ],
          ),
        )
      ],
    );
  }
}
