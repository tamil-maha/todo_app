class Validator {
  static bool validatePhoneNumber(String value) {
    if (value.isEmpty || value.length < 10)
      return false;
    else
      return true;
  }

  static bool validateString(String value) {
    if (value.isEmpty || value.length <= 0)
      return false;
    else
      return true;
  }
}
