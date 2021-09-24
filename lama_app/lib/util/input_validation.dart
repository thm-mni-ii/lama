import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

///This file provides basic input validation for
///password, usernames, numbers and url input.
///
///function names -> input <%what should be validated%> Validation
///
///{@important} to understand how the validation works
///an at least basic knowledge about [RegExp] is necessary.
///
///
/// Author: L.Kammerer
/// Latest Changes: 14.09.2021
abstract class InputValidation {
  //MAX_LENGTH for Usernamens
  static int allowedNameLength = 12;
  //MAX_LENGTH for Password
  //TODO should be password... not passwort...
  static int passwortMaxLength = 16;
  //MAX_VALUE for coins per User
  static int maxNumber = 99999;
  //allowed symbols for Username and Password as inverted whitelist
  static RegExp inputFilter = RegExp('[^a-zA-Z0-9öÖäÄüÜßẞ]');
  //allowed numbers for number inputs as inverted whitelist
  static RegExp numberFilter = RegExp('[^0-9]');
  //Defines how an url should looks like
  static RegExp urlFilter = RegExp('((https://)' '.+)');

  ///Used to validate username input
  ///
  ///{@param} String as username
  static String inputUsernameValidation(String username) {
    if (isEmpty(username)) return 'Der Nutzername darf nicht leer sein!';
    if (username.length > allowedNameLength)
      return 'Der Nutzername darf nur $allowedNameLength Zeichen lang sein!';
    if (_regExpInvalide(username))
      return 'Bitte keine Sonderzeichen im Nutzernamen!';
    return null;
  }

  ///Used to validate password input
  ///
  ///To provide two password verfication use password and secondPass
  ///the first input password will be validat.
  ///If the secondPass is not null password and secondPass will be compared
  ///if password is not equal to secondPass an error message is return.
  ///
  ///{@params}
  ///String as password
  ///(Optional) secondPass to use the function for two password verfication
  //TODO should be Password not Passwort
  static String inputPasswortValidation(String passwort, {String secondPass}) {
    if (isEmpty(passwort)) return 'Das Passwort darf nicht leer sein!';
    if (_regExpInvalide(passwort))
      return 'Bitte keine Sonderzeichen im Passwort!';
    if (passwort.length > passwortMaxLength)
      return 'Das Passwort darf maximal $passwortMaxLength Zeichen haben!';
    if (secondPass != null && (passwort != secondPass)) {
      return 'Die Passwörter stimmen nicht überein';
    }
    return null;
  }

  ///Used to validate number input
  ///
  ///{@param} [String] as numbers
  static String inputNumberValidation(String numbers) {
    if (isEmpty(numbers)) return 'Dieses Feld darf nicht leer sein!';
    if (numberFilter.hasMatch(numbers)) return 'Es sind nur Nummern erlaubt!';
    if (int.parse(numbers) > maxNumber)
      return 'Die Zahl überschreitet den Maximalwert ($maxNumber)!';
    return null;
  }

  ///Used to validate url input
  ///
  ///{@important} [inputURLValidation] is not used to check any connection Exceptions
  ///ther for use [inputUrlWithJsonValidation]. However this function only validate the String
  ///like if it could be parsed to Url.
  ///
  ///{@param} [String] as url
  static String inputURLValidation(String url) {
    if (isEmpty(url)) return 'Dieses Feld darf nicht leer sein!';
    if (RegExp('http://').hasMatch(url))
      return 'URL darf aus Sicherheitsgründen keine "http" Adresse sein!';
    if (!urlFilter.hasMatch(url)) return 'Die URL muss mit "https://" beginen!';
    if (!Uri.tryParse(url).hasAbsolutePath)
      return 'URL Fehlerhaft! Einige URLs müssen mit "/" enden.';
    return null;
  }

  ///Used to validate url input to prevent connection and parsing issues
  ///there for [SocketException], [HandshakeException] and [TimeoutException] are catched
  ///
  ///{@important} this function runs into [TimeoutException] after 4 seconds if the url
  ///does not leads to any response. The [TimeoutException] will be catched in every case and
  ///leads to an error Message.
  ///Also this function should only be used when json is expected.
  ///
  ///{@param} [String] as url
  static Future<String> inputUrlWithJsonValidation(String url) async {
    if (inputURLValidation(url) != null) return inputURLValidation(url);
    //SocketException
    //HandshakeException
    //TimeoutException
    try {
      final response = await Future.wait([
        http
            .get(Uri.parse(url))
            .timeout(Duration(seconds: 4))
            .whenComplete(() {})
            .catchError((e) {
          return null;
        })
      ]).catchError((e) {
        return null;
      });

      //Check if URL is reachable
      if (response[0].statusCode == 200) {
        //Check if URL contains valid json code
        try {
          await jsonDecode(response[0].body);
        } on FormatException {
          return '"json" fehlerhaft oder nicht gefunden!';
        }
        //Testing successfull
        return null;
      } else {
        return 'URL ist nicht erreichbar!';
      }
    } catch (e) {
      if (e is TimeoutException) return 'Zeitüberschreitung!';
      return 'Da ist etwas gewaltig schiefgelaufen!';
    }
  }

  ///(private)
  ///used for inverting the [RegExp].hasMatch result of
  ///inverted whitelist [inputFilter]
  ///
  ///{@param} [String] as str
  static bool _regExpInvalide(String str) {
    if (inputFilter.hasMatch(str)) return true;
    return false;
  }

  ///Used to check str on empty url
  ///
  ///{@param} [String] as str
  static bool isEmpty(String str) {
    if (str != null && str != '' && str != ' ' && str.isNotEmpty) return false;
    return true;
  }
}
