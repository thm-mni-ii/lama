import 'package:lama_app/app/model/user_model.dart';

class Password {
  int id;
 String password;

  Password({this.id, this.password});
  //Map the variables and return the map
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      UserFields.columnPassword: password,
    };
    return map;
  }
  //get the data from an map
  Password.fromMap(Map<String, dynamic> map) {
    id = map[UserFields.columnId];
    password = map[UserFields.columnPassword];
  }
}