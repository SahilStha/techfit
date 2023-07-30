class Validators {
  static String? validateEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }

    return null;
  }

  static String? validateGreaterThanZero(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    double? weight = double.tryParse(value);
    if (weight == null) {
      return 'Field must contain only numbers';
    }
    if (weight <= 0) {
      return 'Weight must be greater than 0';
    }
    return null;
  }
}
