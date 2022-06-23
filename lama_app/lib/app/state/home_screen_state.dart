 class home_screen_state {
  static bool isTTSTurnedOn = true;

  static toggle() {
    if(isTTSTurnedOn) {
      isTTSTurnedOn = false;
    } else {
      isTTSTurnedOn = true;
    }
  }
  static isTTs() {
    return isTTSTurnedOn;
  }
}