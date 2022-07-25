class QuestionText {
  static String _text = "";
  static String _lang = "";

  static String getText() {
    return _text;
  }
  static String getLang() {
    return _lang;
  }
  static setText(String text, String lang) {
    _text = text;
    _lang = lang;
  }

}