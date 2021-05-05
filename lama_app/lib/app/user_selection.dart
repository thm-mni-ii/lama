import 'package:flutter/material.dart';
import 'package:lama_app/app/user.dart';

class UserSelection extends StatelessWidget {
  List<User> userList = [
    new User(1, 'Lars', 'path'),
    new User(2, 'Kevin', 'path')
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: userList.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                onTap: () {},
                title: Text(userList[index].name),
                leading: CircleAvatar(
                  //TODO should be backgrundImage.
                  //You can use path to get the User Image.
                  backgroundColor: Color(0xFFF48FB1),
                ),
              ),
            );
          }),
    );
  }
}
