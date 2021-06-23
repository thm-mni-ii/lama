import 'package:flutter/cupertino.dart';

abstract class CreateAdminEvent {}

class CreateAdminPush extends CreateAdminEvent {
  BuildContext context;
  CreateAdminPush(this.context);
}

class CreateAdminChangeName extends CreateAdminEvent {
  String name;
  CreateAdminChangeName(this.name);
}

class CreateAdminChangePassword extends CreateAdminEvent {
  String password;
  CreateAdminChangePassword(this.password);
}

class CreateAdminAbort extends CreateAdminEvent {
  BuildContext context;
  CreateAdminAbort(this.context);
}
