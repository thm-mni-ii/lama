import '../../db/database_provider.dart';

class Password {
  int id;
 String password;

  Password({this.id, this.password});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.columnPassword: password,
    };
    return map;
  }

  Password.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseProvider.columnId];
    password = map[DatabaseProvider.columnPassword];
  }
}