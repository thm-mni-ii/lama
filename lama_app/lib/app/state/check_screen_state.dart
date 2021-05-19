class CheckScreenState {}

class AdminExist extends CheckScreenState {}

class NoAdmin extends CheckScreenState {}

class ShowDSGVO extends CheckScreenState {
  String dsgvo;
  ShowDSGVO(this.dsgvo);
}

class CreateAdmin extends CheckScreenState {}
