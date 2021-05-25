abstract class InputValidation {
  static int allowedNameLength = 12;
  static RegExp inputFilter = RegExp('[^a-zA-Z0-9]');

  static String inputUsernameValidation(String username) {
    if (isEmpty(username)) return 'Der Nutzername darf nicht leer sein!';
    if (username.length > allowedNameLength)
      return 'Der Nutzername darf nur $allowedNameLength Zeichen lang sein!';
    if (_regExpInvalide(username)) return 'Bitte keine Sonderzeichen!';
    return null;
  }

  static String inputPasswortValidation(String passwort) {
    if (isEmpty(passwort)) return 'Das Passwort darf nicht leer sein!';
    if (_regExpInvalide(passwort)) return 'Bitte keine Sonderzeichen!';
    return null;
  }

  static bool _regExpInvalide(String str) {
    if (inputFilter.hasMatch(str)) return true;
    return false;
  }

  static bool isEmpty(String str) {
    if (str != null && str != '' && str != ' ' && str.isNotEmpty) return false;
    return true;
  }
}
