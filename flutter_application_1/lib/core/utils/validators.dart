import '../constants/app_strings.dart';

/// Utility class for common form validation operations.
class Validators {
  Validators._();

  /// Regular expression for email validation.
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    caseSensitive: false,
  );

  /// Regular expression for phone number validation (9-15 digits, optional +).
  static final RegExp _phoneRegExp = RegExp(r'^\+?\d{9,15}$');

  /// Returns true if [value] matches a valid email shape.
  static bool isEmailFormat(String value) {
    final trimmed = value.trim();
    return trimmed.isNotEmpty && _emailRegExp.hasMatch(trimmed);
  }

  /// Validates an email address.
  /// Returns null if valid, error message if invalid.
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.emailRequired;
    }

    final trimmed = value.trim();

    if (!_emailRegExp.hasMatch(trimmed)) {
      return AppStrings.emailInvalid;
    }

    if (trimmed.length > 254) {
      return AppStrings.emailInvalid;
    }

    return null;
  }

  /// Validates a phone number.
  /// Returns null if valid, error message if invalid.
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.phoneRequired;
    }

    // Allow various formats: +254712345678, 0712345678, 712345678
    final cleaned = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    if (!_phoneRegExp.hasMatch(cleaned)) {
      return AppStrings.phoneInvalid;
    }

    return null;
  }

  /// Validates a password.
  /// Returns null if valid, error message if invalid.
  static String? validatePassword(
    String? value, {
    int minLength = 6,
    int maxLength = 128,
    bool requireUppercase = false,
    bool requireLowercase = false,
    bool requireNumber = false,
    bool requireSpecialChar = false,
  }) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired;
    }

    if (value.length < minLength) {
      return AppStrings.passwordMinLength;
    }

    if (value.length > maxLength) {
      return 'Password cannot exceed $maxLength characters';
    }

    if (requireUppercase && !value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    if (requireLowercase && !value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }

    if (requireNumber && !value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }

    if (requireSpecialChar &&
        !value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }

    return null;
  }

  /// Validates a full name.
  /// Returns null if valid, error message if invalid.
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.nameRequired;
    }
    return null;
  }

  /// Validates password confirmation.
  /// Returns null if valid, error message if invalid.
  static String? validatePasswordConfirmation(
    String? value,
    String? password,
  ) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired;
    }

    if (password == null || password.isEmpty) {
      return AppStrings.passwordRequired;
    }

    if (value != password) {
      return AppStrings.passwordMismatch;
    }

    return null;
  }

  /// Validates a password confirmation field.
  /// Alias for [validatePasswordConfirmation].
  static String? validateConfirmPassword(String? value, String? password) {
    return validatePasswordConfirmation(value, password);
  }

  /// Validates a text field with minimum and maximum length.
  /// Returns null if valid, error message if invalid.
  static String? validateText(
    String? value, {
    int minLength = 1,
    int maxLength = 1000,
    bool required = true,
  }) {
    if (required && (value == null || value.trim().isEmpty)) {
      return 'This field is required';
    }

    if (value != null && value.isNotEmpty) {
      final trimmed = value.trim();

      if (trimmed.length < minLength) {
        return 'Minimum $minLength characters required';
      }

      if (trimmed.length > maxLength) {
        return 'Maximum $maxLength characters allowed';
      }
    }

    return null;
  }

  /// Validates a numeric field.
  /// Returns null if valid, error message if invalid.
  static String? validateNumber(
    String? value, {
    double? min,
    double? max,
    bool required = true,
    String? customError,
  }) {
    if (required && (value == null || value.trim().isEmpty)) {
      return customError ?? 'This field is required';
    }

    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final number = double.tryParse(value.trim());

    if (number == null) {
      return 'Please enter a valid number';
    }

    if (min != null && number < min) {
      return 'Value must be at least $min';
    }

    if (max != null && number > max) {
      return 'Value cannot exceed $max';
    }

    return null;
  }

  /// Validates a URL.
  /// Returns null if valid, error message if invalid.
  static String? validateUrl(String? value, {bool required = true}) {
    if (required && (value == null || value.trim().isEmpty)) {
      return 'URL is required';
    }

    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final trimmed = value.trim();

    if (!RegExp(
      r'^https?:\/\/',
      caseSensitive: false,
    ).hasMatch(trimmed) &&
        !RegExp(
          r'^www\.',
          caseSensitive: false,
        ).hasMatch(trimmed)) {
      return 'Please enter a valid URL (http:// or https://)';
    }

    if (!RegExp(
      r'^https?:\/\/[^\s]+$',
      caseSensitive: false,
    ).hasMatch(trimmed) &&
        !RegExp(
          r'^www\.[^\s]+$',
          caseSensitive: false,
        ).hasMatch(trimmed)) {
      return 'Please enter a valid URL';
    }

    return null;
  }

  /// Validates that a value is within a range (for ratings, percentages, etc.).
  /// Returns null if valid, error message if invalid.
  static String? validateRange(
    int? value, {
    int min = 0,
    int max = 100,
    bool required = true,
  }) {
    if (required && value == null) {
      return 'This field is required';
    }

    if (value == null) {
      return null;
    }

    if (value < min || value > max) {
      return 'Value must be between $min and $max';
    }

    return null;
  }

  /// Validates a date string in a common format.
  /// Returns null if valid, error message if invalid.
  static String? validateDate(String? value, {bool required = true}) {
    if (required && (value == null || value.trim().isEmpty)) {
      return 'Date is required';
    }

    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final formats = [
      RegExp(r'^\d{4}-\d{2}-\d{2}$'),
      RegExp(r'^\d{2}\/\d{2}\/\d{4}$'),
      RegExp(r'^\d{2}-\d{2}-\d{4}$'),
    ];

    final isValidFormat = formats.any((format) => format.hasMatch(value.trim()));

    if (!isValidFormat) {
      return 'Please enter a valid date (YYYY-MM-DD or MM/DD/YYYY)';
    }

    return null;
  }

  /// Validates that a string contains only alphanumeric characters.
  /// Returns null if valid, error message if invalid.
  static String? validateAlphanumeric(String? value, {bool required = true}) {
    if (required && (value == null || value.trim().isEmpty)) {
      return 'This field is required';
    }

    if (value == null || value.trim().isEmpty) {
      return null;
    }

    if (!RegExp(r'^[a-zA-Z0-9]+$', caseSensitive: false).hasMatch(value.trim())) {
      return 'Only letters and numbers are allowed';
    }

    return null;
  }

  /// Validates that a value is not empty (just checks for presence).
  /// Returns null if present, error message if empty.
  static String? validateRequired(String? value, {String? customMessage}) {
    if (value == null || value.trim().isEmpty) {
      return customMessage ?? 'This field is required';
    }
    return null;
  }

  /// Validates that a value is present.
  /// Returns null if present, [customMessage] (or a default) if empty.
  static String? required(String? value, [String? customMessage]) {
    if (value == null || value.trim().isEmpty) {
      return customMessage ?? 'This field is required';
    }
    return null;
  }

  /// Combines multiple validators and returns the first error.
  static String? validateWith(
    String? value,
    List<String? Function(String?)> validators,
  ) {
    for (final validator in validators) {
      final error = validator(value);
      if (error != null) {
        return error;
      }
    }
    return null;
  }

  /// Strips all non-digit characters from a phone number.
  static String stripPhone(String value) {
    return value.replaceAll(RegExp(r'\D'), '');
  }

  /// Formats a phone number for display.
  static String formatPhone(String phone, {bool withPlus = true}) {
    final digits = stripPhone(phone);
    if (digits.isEmpty) return phone;

    if (withPlus && digits.startsWith('254')) {
      return '+${digits.substring(0, 4)} ${digits.substring(4, 7)} ${digits.substring(7)}';
    }

    if (digits.length >= 12 && digits.startsWith('0')) {
      return '${digits.substring(0, 4)} ${digits.substring(4, 7)} ${digits.substring(7)}';
    }

    if (digits.length >= 10) {
      return '${digits.substring(0, 3)} ${digits.substring(3, 6)} ${digits.substring(6)}';
    }

    return phone;
  }
}