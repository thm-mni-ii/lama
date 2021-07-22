import 'package:lama_app/app/model/user_model.dart';

///This class help to work with the entry in the column password in the table User
///
/// Author: F.Brecher
class Password {
  int id;
 String password;

  Password({this.id, this.password});

  ///Map the variables
  ///
  ///{@return} Map<String, dynamic>
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      UserFields.columnPassword: password,
    };
    return map;
  }

  ///get the data from the map
  ///
  ///{@param} Map<String, dynamic> map
  Password.fromMap(Map<String, dynamic> map) {
    id = map[UserFields.columnId];
    password = map[UserFields.columnPassword];
  }
}