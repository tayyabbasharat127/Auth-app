/// Reusable validator class — keeps validation logic out of the UI layer.
class Validators {
  Validators._(); // prevent instantiation

  /// Returns an error string if [value] is null or empty, otherwise null.
  static String? required(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validates a proper email format.
  static String? email(String? value) {
    final empty = required(value, fieldName: 'Email');
    if (empty != null) return empty;

    final regex = RegExp(r'^[\w.+-]+@[\w-]+\.[a-zA-Z]{2,}$');
    if (!regex.hasMatch(value!.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  /// Validates password strength:
  /// - Minimum 6 characters
  /// - At least 1 uppercase letter
  /// - At least 1 special character
  static String? password(String? value) {
    final empty = required(value, fieldName: 'Password');
    if (empty != null) return empty;

    final v = value!;
    if (v.length < 6) return 'Password must be at least 6 characters';
    if (!v.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least 1 uppercase letter';
    }
    if (!v.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-+=\[\]\\\/`~]'))) {
      return 'Password must contain at least 1 special character';
    }
    return null;
  }

  /// Validates that [confirm] matches [original].
  static String? confirmPassword(String? confirm, String original) {
    final empty = required(confirm, fieldName: 'Confirm password');
    if (empty != null) return empty;
    if (confirm != original) return 'Passwords do not match';
    return null;
  }

  /// Validates that a dropdown value has been selected.
  static String? dropdown<T>(T? value, {String fieldName = 'Selection'}) {
    if (value == null) return '$fieldName is required';
    return null;
  }
}
