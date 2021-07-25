import 'package:lama_app/app/model/user_model.dart';

import '../../db/database_provider.dart';

class Password {
  int id;
 String password;

  Password({this.id, this.password});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      UserFields.columnPassword: password,
    };
    return map;
  }

  Password.fromMap(Map<String, dynamic> map) {
    id = map[UserFields.columnId];
    password = map[UserFields.columnPassword];
  }
}