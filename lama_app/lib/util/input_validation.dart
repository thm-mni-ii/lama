abstract class InputValidation {
  static int allowedNameLength = 12;
  static int maxNumber = 99999;
  static int passwortMaxLength = 16;
  static RegExp inputFilter = RegExp('[^a-zA-Z0-9öÖäÄüÜßẞ]');
  static RegExp numberFilter = RegExp('[^0-9]');

  static String inputUsernameValidation(String username) {
    if (isEmpty(username)) return 'Der Nutzername darf nicht leer sein!';
    if (username.length > allowedNameLength)
      return 'Der Nutzername darf nur $allowedNameLength Zeichen lang sein!';
    if (_regExpInvalide(username)) return 'Bitte keine Sonderzeichen!';
    return null;
  }

  static String inputPasswortValidation(String passwort, {String secondPass}) {
    if (isEmpty(passwort)) return 'Das Passwort darf nicht leer sein!';
    if (_regExpInvalide(passwort)) return 'Bitte keine Sonderzeichen!';
    if (passwort.length > passwortMaxLength)
      return 'Das Passwort darf maximal $passwortMaxLength Zeichen haben!';
    if (secondPass != null && (passwort != secondPass)) {
      return 'Die Passwörter stimmen nicht überein';
    }
    return null;
  }

  static String inputNumberValidation(String numbers) {
    if (isEmpty(numbers)) return 'Dieses Feld darf nicht leer sein!';
    if (numberFilter.hasMatch(numbers)) return 'Es sind nur Nummern erlaubt!';
    if (int.parse(numbers) > maxNumber)
      return 'Die Zahl überschreitet den Maximalwert ($maxNumber)!';
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
